#!/bin/bash

set -e

# ============================================
# CONFIGURATION - EDIT THESE VALUES
# ============================================

SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"
PROFILE=""  # Leave empty for default credentials

# Attributes to remove from source table
REMOVE_ATTRS=(
    "RemoveThis"
)

# Attributes to rename (format: "old_name:new_name")
RENAME_ATTRS=(
    "Queue:QueueARN"
    "Name:firstname"
)

# Set default values for attributes (format: "attribute_name:value")
# For text values, use plain text
# For SSML, wrap in <speak></speak> tags
SET_DEFAULTS=(
    "status:active"
    "version:1.0"
    "description:<speak>This is a <emphasis>sample</emphasis> SSML text</speak>"
)

DRY_RUN=false  # Set to true to preview without writing
BATCH_SIZE=25
SCAN_LIMIT=100

# ============================================
# SCRIPT - DO NOT EDIT BELOW THIS LINE
# ============================================

AWS_CMD="aws dynamodb"
if [[ -n "$PROFILE" ]]; then
    AWS_CMD="$AWS_CMD --profile $PROFILE"
fi
AWS_CMD="$AWS_CMD --region $REGION"

echo "=============================================="
echo "DynamoDB Migration"
echo "=============================================="
echo "Source: $SOURCE_TABLE"
echo "Target: $TARGET_TABLE"
echo "Region: $REGION"
echo "Attributes to remove: ${REMOVE_ATTRS[@]}"
echo "Attributes to rename: ${RENAME_ATTRS[@]}"
echo "Default values to set: ${SET_DEFAULTS[@]}"
if [[ "$DRY_RUN" == true ]]; then
    echo "Mode: DRY RUN"
fi
echo "=============================================="

transform_item() {
    local item="$1"
    local transformed="$item"
    
    # Remove specified attributes
    for attr in "${REMOVE_ATTRS[@]}"; do
        transformed=$(echo "$transformed" | jq "del(.${attr})")
    done
    
    # Rename attributes
    for rename_pair in "${RENAME_ATTRS[@]}"; do
        IFS=':' read -r old_name new_name <<< "$rename_pair"
        if echo "$transformed" | jq -e ".${old_name}" > /dev/null 2>&1; then
            transformed=$(echo "$transformed" | jq ".${new_name} = .${old_name} | del(.${old_name})")
        fi
    done
    
    # Set default values for attributes
    for default_pair in "${SET_DEFAULTS[@]}"; do
        IFS=':' read -r attr_name attr_value <<< "$default_pair"
        # Check if value contains SSML (starts with <speak>)
        if [[ "$attr_value" == "<speak>"* ]]; then
            # SSML value - store as string with S type
            transformed=$(echo "$transformed" | jq --arg key "$attr_name" --arg val "$attr_value" '.[$key] = {"S": $val}')
        else
            # Plain text value - store as string with S type
            transformed=$(echo "$transformed" | jq --arg key "$attr_name" --arg val "$attr_value" '.[$key] = {"S": $val}')
        fi
    done
    
    echo "$transformed"
}

ITEMS_MIGRATED=0
ITEMS_FAILED=0
LAST_EVALUATED_KEY=""
TEMP_BATCH_FILE="/tmp/dynamodb_batch_$$.json"

cleanup() {
    rm -f "$TEMP_BATCH_FILE"
}
trap cleanup EXIT

echo ""
echo "Starting migration..."
echo ""

ITERATION=0

while true; do
    ITERATION=$((ITERATION + 1))
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iteration $ITERATION: Scanning source table..."
    
    SCAN_CMD="$AWS_CMD scan --table-name $SOURCE_TABLE --limit $SCAN_LIMIT"
    
    if [[ -n "$LAST_EVALUATED_KEY" ]]; then
        SCAN_CMD="$SCAN_CMD --exclusive-start-key '$LAST_EVALUATED_KEY'"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Continuing scan from last evaluated key"
    fi
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing: $SCAN_CMD"
    SCAN_RESULT=$(eval $SCAN_CMD)
    
    ITEMS=$(echo "$SCAN_RESULT" | jq -c '.Items[]')
    ITEM_COUNT=$(echo "$ITEMS" | wc -l)
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Scan returned $ITEM_COUNT items"
    
    if [[ -z "$ITEMS" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No more items to process. Exiting scan loop."
        break
    fi
    
    BATCH=()
    BATCH_COUNT=0
    ITEM_NUM=0
    
    while IFS= read -r item; do
        if [[ -z "$item" ]]; then
            continue
        fi
        
        ITEM_NUM=$((ITEM_NUM + 1))
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Processing item $ITEM_NUM..."
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')]   Original item: $(echo $item | jq -c '.')"
        
        TRANSFORMED=$(transform_item "$item")
        
        echo "[$(date '+%Y-%m-%d %H:%M:%S')]   Transformed item: $(echo $TRANSFORMED | jq -c '.')"
        
        BATCH+=("$TRANSFORMED")
        BATCH_COUNT=$((BATCH_COUNT + 1))
        
        if [[ $BATCH_COUNT -ge $BATCH_SIZE ]]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Batch full ($BATCH_COUNT items). Writing to target table..."
            
            if [[ "$DRY_RUN" == false ]]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating batch write request file..."
                echo -n "{\"$TARGET_TABLE\": [" > "$TEMP_BATCH_FILE"
                for i in "${!BATCH[@]}"; do
                    echo -n "{\"PutRequest\": {\"Item\": ${BATCH[$i]}}}" >> "$TEMP_BATCH_FILE"
                    if [[ $i -lt $((${#BATCH[@]} - 1)) ]]; then
                        echo -n "," >> "$TEMP_BATCH_FILE"
                    fi
                done
                echo -n "]}" >> "$TEMP_BATCH_FILE"
                
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing batch-write-item for $BATCH_COUNT items..."
                WRITE_RESULT=$($AWS_CMD batch-write-item --request-items file://"$TEMP_BATCH_FILE" 2>&1)
                
                if [[ $? -eq 0 ]]; then
                    ITEMS_MIGRATED=$((ITEMS_MIGRATED + BATCH_COUNT))
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Successfully wrote $BATCH_COUNT items to $TARGET_TABLE"
                else
                    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✗ Error writing batch: $WRITE_RESULT"
                    ITEMS_FAILED=$((ITEMS_FAILED + BATCH_COUNT))
                fi
            else
                ITEMS_MIGRATED=$((ITEMS_MIGRATED + BATCH_COUNT))
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DRY RUN] Would migrate $BATCH_COUNT items"
            fi
            
            BATCH=()
            BATCH_COUNT=0
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Waiting 0.5 seconds before next batch..."
            sleep 0.5
        fi
    done <<< "$ITEMS"
    
    if [[ $BATCH_COUNT -gt 0 ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Writing final batch of $BATCH_COUNT items..."
        
        if [[ "$DRY_RUN" == false ]]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Creating batch write request file..."
            echo -n "{\"$TARGET_TABLE\": [" > "$TEMP_BATCH_FILE"
            for i in "${!BATCH[@]}"; do
                echo -n "{\"PutRequest\": {\"Item\": ${BATCH[$i]}}}" >> "$TEMP_BATCH_FILE"
                if [[ $i -lt $((${#BATCH[@]} - 1)) ]]; then
                    echo -n "," >> "$TEMP_BATCH_FILE"
                fi
            done
            echo -n "]}" >> "$TEMP_BATCH_FILE"
            
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing batch-write-item for $BATCH_COUNT items..."
            WRITE_RESULT=$($AWS_CMD batch-write-item --request-items file://"$TEMP_BATCH_FILE" 2>&1)
            
            if [[ $? -eq 0 ]]; then
                ITEMS_MIGRATED=$((ITEMS_MIGRATED + BATCH_COUNT))
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Successfully wrote $BATCH_COUNT items to $TARGET_TABLE"
            else
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✗ Error writing batch: $WRITE_RESULT"
                ITEMS_FAILED=$((ITEMS_FAILED + BATCH_COUNT))
            fi
        else
            ITEMS_MIGRATED=$((ITEMS_MIGRATED + BATCH_COUNT))
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DRY RUN] Would migrate $BATCH_COUNT items"
        fi
        sleep 0.5
    fi
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Progress: $ITEMS_MIGRATED items processed so far"
    
    LAST_EVALUATED_KEY=$(echo "$SCAN_RESULT" | jq -r '.LastEvaluatedKey // empty')
    if [[ -z "$LAST_EVALUATED_KEY" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No more pages to scan. Migration loop complete."
        break
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] More items available. Continuing to next page..."
    fi
done

echo ""
echo "=============================================="
echo "Migration completed!"
echo "=============================================="
echo "Total items migrated: $ITEMS_MIGRATED"
echo "Total items failed: $ITEMS_FAILED"

if [[ $((ITEMS_MIGRATED + ITEMS_FAILED)) -gt 0 ]]; then
    SUCCESS_RATE=$(awk "BEGIN {printf \"%.2f\", ($ITEMS_MIGRATED * 100) / ($ITEMS_MIGRATED + $ITEMS_FAILED)}")
    echo "Success rate: ${SUCCESS_RATE}%"
fi
