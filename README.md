# DynamoDB Migration Tool

A powerful bash script for migrating data between DynamoDB tables with support for attribute transformation, removal, renaming, and setting default values.

## ✨ Features

- 🔄 **Attribute Removal** - Remove unwanted attributes during migration
- 🏷️ **Attribute Renaming** - Rename attributes (e.g., snake_case to camelCase)
- ⚙️ **Default Values** - Set default values for attributes (text or SSML format)
- 📝 **Add String Attributes** - Add new string attributes to all items
- 🗺️ **Add Map Attributes** - Add complex map structures to items
- 🔍 **Verbose Logging** - Detailed timestamped logs for every action
- 🧪 **Dry Run Mode** - Preview transformations without writing data
- 📦 **Batch Processing** - Efficient batch writes with configurable delays
- 📊 **Progress Tracking** - Real-time progress updates and statistics

## 📋 Prerequisites

- AWS CLI installed and configured
- `jq` command-line JSON processor
- AWS credentials with DynamoDB access

### Install Dependencies

**macOS:**
```bash
brew install awscli jq
```

**Ubuntu/Debian:**
```bash
apt-get install awscli jq
```

**Amazon Linux:**
```bash
yum install awscli jq
```

## 🚀 Quick Start

1. **Download the script:**
```bash
curl -O https://raw.githubusercontent.com/your-repo/migrate.sh
chmod +x migrate.sh
```

2. **Edit configuration in the script:**
```bash
nano migrate.sh
```

3. **Run the migration:**
```bash
./migrate.sh
```

## ⚙️ Configuration

Edit the configuration section at the top of `migrate.sh`:

```bash
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
SET_DEFAULTS=(
)

# Add string attributes (format: "attribute_name:value")
ADD_STRINGS=(
)

# Add map attributes (format: "attribute_name:json_object")
ADD_MAPS=(
)

DRY_RUN=false  # Set to true to preview without writing
BATCH_SIZE=25
SCAN_LIMIT=100
```

## 📖 Usage Examples

### Example 1: Current Default (Test1 to Test2)

```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=(
    "RemoveThis"
)

RENAME_ATTRS=(
    "Queue:QueueARN"
    "Name:firstname"
)

SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=()
```

This configuration:
- Removes the "RemoveThis" attribute
- Renames "Queue" to "QueueARN"
- Renames "Name" to "firstname"

### Example 2: Add Migration Tracking

```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")

ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "source_table:Test1"
    "migration_version:1.0.0"
)

ADD_MAPS=()
SET_DEFAULTS=()
```

### Example 3: Basic Migration with Attribute Removal

### Example 3: Basic Migration with Attribute Removal

```bash
SOURCE_TABLE="users-old"
TARGET_TABLE="users-new"
REGION="us-east-1"

REMOVE_ATTRS=(
    "temp_data"
    "debug_flag"
    "internal_notes"
)

RENAME_ATTRS=()
SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=()
```

### Example 4: Rename Attributes (snake_case to camelCase)

```bash
SOURCE_TABLE="products-v1"
TARGET_TABLE="products-v2"

REMOVE_ATTRS=()

RENAME_ATTRS=(
    "product_id:productId"
    "product_name:productName"
    "created_at:createdAt"
    "updated_at:updatedAt"
)

SET_DEFAULTS=()
```

### Example 5: Set Default Values

```bash
SOURCE_TABLE="orders-old"
TARGET_TABLE="orders-new"

REMOVE_ATTRS=()
RENAME_ATTRS=()
ADD_STRINGS=()
ADD_MAPS=()

SET_DEFAULTS=(
    "status:pending"
    "priority:normal"
    "notification_enabled:true"
)
```

### Example 6: Add String Attributes

```bash
SOURCE_TABLE="users-old"
TARGET_TABLE="users-new"

REMOVE_ATTRS=()
RENAME_ATTRS=()
SET_DEFAULTS=()

ADD_STRINGS=(
    "account_type:premium"
    "signup_source:web"
    "onboarding_complete:true"
)

ADD_MAPS=()
```

### Example 7: Add Map Attributes

```bash
SOURCE_TABLE="products-old"
TARGET_TABLE="products-new"

REMOVE_ATTRS=()
RENAME_ATTRS=()
SET_DEFAULTS=()
ADD_STRINGS=()

ADD_MAPS=(
    'pricing:{"M":{"amount":{"N":"99.99"},"currency":{"S":"USD"}}}'
    'metadata:{"M":{"created":{"S":"2024-01-01"},"author":{"S":"admin"}}}'
    'features:{"M":{"premium":{"BOOL":true},"trial_days":{"N":"30"}}}'
)
```

### Example 8: Add Nested Map for Localization

```bash
ADD_MAPS=(
    'translations:{"M":{"en-US":{"M":{"title":{"S":"Hello"},"desc":{"S":"Welcome"}}},"es-ES":{"M":{"title":{"S":"Hola"},"desc":{"S":"Bienvenido"}}}}}'
)
```

### Example 9: SSML Default Values

```bash
SET_DEFAULTS=(
    "greeting:<speak>Hello <emphasis>world</emphasis></speak>"
    "message:<speak>Welcome to our <break time='500ms'/> service</speak>"
)
```

### Example 10: Complete Transformation

```bash
SOURCE_TABLE="legacy-users"
TARGET_TABLE="modern-users"

REMOVE_ATTRS=(
    "old_password_hash"
    "deprecated_role"
    "temp_token"
)

RENAME_ATTRS=(
    "user_id:userId"
    "first_name:firstName"
    "last_name:lastName"
    "email_address:email"
)

SET_DEFAULTS=(
    "status:active"
    "email_verified:false"
    "created_by:migration_script"
)
```

## 🔍 Dry Run Mode

Always test with dry run first:

```bash
DRY_RUN=true
```

This will:
- ✅ Scan the source table
- ✅ Transform items
- ✅ Show what would be written
- ❌ NOT write to the target table

## 📊 Output Example

```
==============================================
DynamoDB Migration
==============================================
Source: Test1
Target: Test2
Region: us-west-2
Attributes to remove: RemoveThis
Attributes to rename: Queue:QueueARN Name:firstname
Default values to set: 
String attributes to add: 
Map attributes to add: 
==============================================

Starting migration...

[2024-12-06 10:15:23] Iteration 1: Scanning source table...
[2024-12-06 10:15:23] Executing: aws dynamodb --region us-west-2 scan --table-name Test1 --limit 100
[2024-12-06 10:15:24] Scan returned 2 items
[2024-12-06 10:15:24] Processing item 1...
[2024-12-06 10:15:24]   Original item: {"Queue":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"RemoveThis":{"S":"12345gfghj"},"SystemEndpoint":{"S":"12345"},"Name":{"S":"Godwill Cho"}}
[2024-12-06 10:15:24]   Transformed item: {"SystemEndpoint":{"S":"12345"},"QueueARN":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"firstname":{"S":"Godwill Cho"}}
[2024-12-06 10:15:24] Processing item 2...
[2024-12-06 10:15:24]   Original item: {"Queue":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"RemoveThis":{"S":"12345gfghj"},"SystemEndpoint":{"S":"123457"},"Name":{"S":"Jane Doe"}}
[2024-12-06 10:15:24]   Transformed item: {"SystemEndpoint":{"S":"123457"},"QueueARN":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"firstname":{"S":"Jane Doe"}}
[2024-12-06 10:15:24] Writing final batch of 2 items...
[2024-12-06 10:15:24] Creating batch write request file...
[2024-12-06 10:15:24] Executing batch-write-item for 2 items...
[2024-12-06 10:15:25] ✓ Successfully wrote 2 items to Test2
[2024-12-06 10:15:26] Progress: 2 items processed so far
[2024-12-06 10:15:26] No more pages to scan. Migration loop complete.

==============================================
Migration completed!
==============================================
Total items migrated: 2
Total items failed: 0
Success rate: 100.00%
```

## 🎯 Use Cases

### Use Case 1: Schema Evolution
Migrate from old schema to new schema with renamed fields:
```bash
RENAME_ATTRS=(
    "createdTime:created_at"
    "modifiedTime:updated_at"
    "userId:user_id"
)
```

### Use Case 2: Data Cleanup
Remove temporary or deprecated fields:
```bash
REMOVE_ATTRS=(
    "temp_processing_flag"
    "old_metadata"
    "debug_timestamp"
)
```

### Use Case 3: Add Missing Fields
Populate new required fields with default values:
```bash
SET_DEFAULTS=(
    "api_version:2.0"
    "schema_version:latest"
    "migrated:true"
)
```

### Use Case 4: Voice Applications
Add SSML formatted responses for Alexa/voice apps:
```bash
SET_DEFAULTS=(
    "welcome_message:<speak>Welcome to <emphasis>our service</emphasis></speak>"
    "help_text:<speak>Say <break time='300ms'/> help for assistance</speak>"
)
```

### Use Case 5: Add Metadata to All Items
Add tracking and metadata fields:
```bash
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "migration_version:1.0"
    "source_table:legacy_table"
)
```

### Use Case 6: Add Configuration Maps
Add complex configuration to all items:
```bash
ADD_MAPS=(
    'app_config:{"M":{"theme":{"S":"dark"},"notifications":{"BOOL":true},"max_retries":{"N":"3"}}}'
    'permissions:{"M":{"read":{"BOOL":true},"write":{"BOOL":false},"admin":{"BOOL":false}}}'
)
```

### Use Case 7: Multi-Language Support
Add localized content:
```bash
ADD_MAPS=(
    'locales:{"M":{"en-US":{"S":"English content"},"es-ES":{"S":"Contenido en español"},"fr-FR":{"S":"Contenu français"}}}'
)
```

## ⚡ Performance Tuning

### For Large Tables
```bash
BATCH_SIZE=25        # Maximum allowed by DynamoDB
SCAN_LIMIT=1000      # Scan more items per iteration
```

### For Rate Limiting
```bash
BATCH_SIZE=10        # Smaller batches
SCAN_LIMIT=50        # Scan fewer items
# Add sleep in the script for more delay between batches
```

### Temporary Capacity Increase
Before migration, consider temporarily increasing write capacity:
```bash
aws dynamodb update-table \
    --table-name Test2 \
    --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=50
```

## 🔒 AWS Permissions Required

Ensure your IAM user/role has these permissions:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Scan",
                "dynamodb:BatchWriteItem",
                "dynamodb:PutItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:*:*:table/SOURCE_TABLE_NAME",
                "arn:aws:dynamodb:*:*:table/TARGET_TABLE_NAME"
            ]
        }
    ]
}
```

## 🐛 Troubleshooting

### Issue: "jq: command not found"
**Solution:** Install jq using your package manager
```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq
```

### Issue: "Throttling errors"
**Solution:** Reduce batch size or add delays
```bash
BATCH_SIZE=10
# Increase sleep time in the script
```

### Issue: "Access Denied"
**Solution:** Check AWS credentials and IAM permissions
```bash
aws sts get-caller-identity
aws dynamodb describe-table --table-name SOURCE_TABLE
```

### Issue: "Invalid JSON in batch write"
**Solution:** Check for special characters in your data. The script handles most cases, but complex nested structures may need adjustment.

## 📝 Best Practices

1. **Always backup first** - Create a backup or on-demand snapshot of your source table
2. **Test with dry run** - Set `DRY_RUN=true` first
3. **Start small** - Test with a subset of data by limiting `SCAN_LIMIT`
4. **Monitor CloudWatch** - Watch for throttling and errors
5. **Verify data** - After migration, verify a sample of items in the target table
6. **Keep logs** - Redirect output to a file: `./migrate.sh > migration.log 2>&1`

## 🔄 Migration Workflow

```
┌─────────────────────┐
│  Configure Script   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Set DRY_RUN=true    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Run Migration      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Review Logs       │
└──────────┬──────────┘
           │
           ▼
      ┌────────┐
      │ Good?  │
      └───┬────┘
          │
    ┌─────┴─────┐
    │           │
   No          Yes
    │           │
    ▼           ▼
┌─────────┐ ┌──────────────────┐
│ Adjust  │ │ Set DRY_RUN=false│
│ Config  │ └────────┬─────────┘
└────┬────┘          │
     │               ▼
     └──────► ┌─────────────────┐
              │  Run Actual     │
              │  Migration      │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │  Verify Data    │
              └────────┬────────┘
                       │
                       ▼
                   ┌──────┐
                   │ Done │
                   └──────┘
```

## 📊 Migration Statistics

The script provides detailed statistics at the end:
- Total items migrated
- Total items failed
- Success rate percentage
- Detailed logs for each operation

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - feel free to use and modify as needed.

## 🆘 Support

For issues and questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review AWS DynamoDB documentation

## 🔗 Related Resources

- [AWS DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)
- [AWS CLI DynamoDB Reference](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [SSML Reference](https://developer.amazon.com/docs/custom-skills/speech-synthesis-markup-language-ssml-reference.html)

## 📈 Version History

### v1.0.0 (Current)
- ✅ Initial release
- ✅ Attribute removal
- ✅ Attribute renaming
- ✅ Default value setting
- ✅ SSML support
- ✅ Verbose logging
- ✅ Dry run mode
- ✅ Batch processing

---

Made with ❤️ for DynamoDB migrations
