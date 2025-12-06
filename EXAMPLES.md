# Advanced Examples: Adding Attributes

## Current Configuration (Test1 to Test2)

The default script configuration migrates from Test1 to Test2:

```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=()
```

This will:
- Remove the "RemoveThis" attribute
- Rename "Queue" to "QueueARN"
- Rename "Name" to "firstname"

## Adding String Attributes

String attributes are simple key-value pairs where the value is stored as a DynamoDB String type.

### Example 1: Add Tracking Fields

Based on the Test1→Test2 migration, add tracking metadata:

```bash
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "migration_version:1.0.0"
    "source_table:Test1"
    "target_table:Test2"
)
```

**Result:** Each item will have these new string attributes added.

**Complete Configuration:**
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "migration_version:1.0.0"
    "source_table:Test1"
)
ADD_MAPS=()
```

### Example 2: Add Environment Context

```bash
ADD_STRINGS=(
    "environment:production"
    "region:us-west-2"
    "deployment:blue-green"
    "cluster:main-cluster"
)
```

### Example 3: Add User Metadata

```bash
ADD_STRINGS=(
    "account_type:premium"
    "subscription_tier:gold"
    "signup_source:mobile_app"
    "referral_code:FRIEND2024"
)
```

## Adding Map Attributes

Map attributes allow you to add complex nested structures. The JSON must be in DynamoDB format.

### Real-World Example: Test1 to Test2 Migration

Since Test1 items have Queue attributes (which became QueueARN after rename), you might want to add additional queue configuration:

```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=(
    'queue_config:{"M":{"enabled":{"BOOL":true},"max_contacts":{"N":"100"},"timeout":{"N":"300"}}}'
    'office_settings:{"M":{"timezone":{"S":"America/Los_Angeles"},"business_hours":{"S":"9-5"}}}'
)
```

This adds queue configuration and office settings to all migrated items.

### DynamoDB Data Type Reference

- **S** - String: `{"S": "value"}`
- **N** - Number: `{"N": "123"}`
- **BOOL** - Boolean: `{"BOOL": true}` or `{"BOOL": false}`
- **M** - Map: `{"M": {...}}`
- **L** - List: `{"L": [...]}`
- **NULL** - Null: `{"NULL": true}`
- **SS** - String Set: `{"SS": ["val1", "val2"]}`
- **NS** - Number Set: `{"NS": ["1", "2", "3"]}`

### Example 1: Simple Configuration Map

```bash
ADD_MAPS=(
    'app_config:{"M":{"theme":{"S":"dark"},"language":{"S":"en-US"},"notifications":{"BOOL":true}}}'
)
```

**Result:**
```json
{
  "app_config": {
    "M": {
      "theme": {"S": "dark"},
      "language": {"S": "en-US"},
      "notifications": {"BOOL": true}
    }
  }
}
```

### Example 2: Pricing Information

```bash
ADD_MAPS=(
    'pricing:{"M":{"amount":{"N":"99.99"},"currency":{"S":"USD"},"discount":{"N":"10"},"tax_included":{"BOOL":false}}}'
)
```

### Example 3: User Preferences

```bash
ADD_MAPS=(
    'preferences:{"M":{"email_notifications":{"BOOL":true},"sms_notifications":{"BOOL":false},"newsletter":{"BOOL":true},"theme":{"S":"light"},"timezone":{"S":"America/Los_Angeles"}}}'
)
```

### Example 4: Multi-Language Content

```bash
ADD_MAPS=(
    'translations:{"M":{"en-US":{"S":"Hello World"},"es-ES":{"S":"Hola Mundo"},"fr-FR":{"S":"Bonjour le monde"},"de-DE":{"S":"Hallo Welt"}}}'
)
```

### Example 5: Nested Maps (Complex Structure)

```bash
ADD_MAPS=(
    'profile:{"M":{"personal":{"M":{"first_name":{"S":"John"},"last_name":{"S":"Doe"},"age":{"N":"30"}}},"contact":{"M":{"email":{"S":"john@example.com"},"phone":{"S":"+1234567890"}}},"settings":{"M":{"privacy":{"S":"public"},"notifications":{"BOOL":true}}}}}'
)
```

**Result:**
```json
{
  "profile": {
    "M": {
      "personal": {
        "M": {
          "first_name": {"S": "John"},
          "last_name": {"S": "Doe"},
          "age": {"N": "30"}
        }
      },
      "contact": {
        "M": {
          "email": {"S": "john@example.com"},
          "phone": {"S": "+1234567890"}
        }
      },
      "settings": {
        "M": {
          "privacy": {"S": "public"},
          "notifications": {"BOOL": true}
        }
      }
    }
  }
}
```

### Example 6: Feature Flags

```bash
ADD_MAPS=(
    'features:{"M":{"dark_mode":{"BOOL":true},"beta_access":{"BOOL":false},"max_uploads":{"N":"100"},"storage_gb":{"N":"50"}}}'
)
```

### Example 7: API Configuration

```bash
ADD_MAPS=(
    'api_config:{"M":{"endpoint":{"S":"https://api.example.com"},"timeout":{"N":"30"},"retries":{"N":"3"},"enabled":{"BOOL":true},"headers":{"M":{"Content-Type":{"S":"application/json"},"X-API-Version":{"S":"1.0"}}}}}'
)
```

### Example 8: List within Map

```bash
ADD_MAPS=(
    'metadata:{"M":{"tags":{"L":[{"S":"important"},{"S":"reviewed"},{"S":"archived"}]},"version":{"N":"2"},"active":{"BOOL":true}}}'
)
```

### Example 9: Voice App Locales (Alexa/Google Assistant)

```bash
ADD_MAPS=(
    'voice_prompts:{"M":{"en-US":{"M":{"welcome":{"S":"<speak>Welcome to our service</speak>"},"help":{"S":"<speak>Say help for assistance</speak>"}}},"es-ES":{"M":{"welcome":{"S":"<speak>Bienvenido a nuestro servicio</speak>"},"help":{"S":"<speak>Diga ayuda para asistencia</speak>"}}}}}'
)
```

### Example 10: E-commerce Product Data

```bash
ADD_MAPS=(
    'product_details:{"M":{"sku":{"S":"PROD-12345"},"inventory":{"N":"100"},"dimensions":{"M":{"length":{"N":"10"},"width":{"N":"5"},"height":{"N":"3"},"unit":{"S":"cm"}}},"shipping":{"M":{"weight":{"N":"0.5"},"free_shipping":{"BOOL":true},"carriers":{"L":[{"S":"USPS"},{"S":"FedEx"},{"S":"UPS"}]}}}}}'
)
```

## Combining String and Map Attributes

You can use both together:

```bash
# Add simple tracking strings
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "environment:production"
)

# Add complex configuration maps
ADD_MAPS=(
    'config:{"M":{"version":{"N":"2"},"enabled":{"BOOL":true}}}'
    'metadata:{"M":{"created_by":{"S":"admin"},"tags":{"L":[{"S":"important"}]}}}'
)
```

## Tips for Creating Map Attributes

1. **Always use single quotes** around the entire map definition to preserve the JSON
2. **Use double quotes** for JSON keys and string values
3. **Format numbers as strings** in the DynamoDB format: `{"N": "123"}`
4. **Test with dry run** first to verify the structure is correct
5. **Use a JSON validator** to check your map structure before adding it

## Common Map Patterns

### Settings Map
```bash
'settings:{"M":{"key1":{"S":"value1"},"key2":{"BOOL":true},"key3":{"N":"100"}}}'
```

### Localization Map
```bash
'locales:{"M":{"en-US":{"S":"English"},"es-ES":{"S":"Spanish"}}}'
```

### Configuration Map
```bash
'config:{"M":{"enabled":{"BOOL":true},"timeout":{"N":"30"},"endpoint":{"S":"https://api.com"}}}'
```

### Metadata Map
```bash
'metadata:{"M":{"created":{"S":"2024-01-01"},"author":{"S":"system"},"version":{"N":"1"}}}'
```

## Complete Test1 to Test2 Migration Examples

### Example 1: Basic Migration (Current Default)
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=()
```

**What it does:**
- Removes "RemoveThis" attribute
- Renames "Queue" to "QueueARN"
- Renames "Name" to "firstname"

### Example 2: Add Migration Tracking
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "migration_source:Test1"
    "migration_status:completed"
)
ADD_MAPS=()
```

### Example 3: Add Office Configuration
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=(
    "office_region:us-west-2"
)
ADD_MAPS=(
    'config:{"M":{"timezone":{"S":"America/Los_Angeles"},"max_agents":{"N":"50"},"enabled":{"BOOL":true}}}'
)
```

### Example 4: Add Multi-Locale Queue Names
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=()
ADD_MAPS=(
    'queue_names:{"M":{"en-US":{"S":"Main Queue"},"es-US":{"S":"Cola Principal"}}}'
)
```

### Example 5: Complete Office Setup
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=(
    "migrated_at:2024-12-06"
    "environment:production"
    "office_type:hearings"
)
ADD_MAPS=(
    'office_config:{"M":{"timezone":{"S":"America/Los_Angeles"},"max_contacts":{"N":"100"},"hours":{"M":{"start":{"S":"09:00"},"end":{"S":"17:00"}}}}}' \
    'notifications:{"M":{"email":{"BOOL":true},"sms":{"BOOL":false},"webhook":{"S":"https://api.example.com/notify"}}}' \
    'locales:{"M":{"en-US":{"S":"English"},"es-US":{"S":"Spanish"}}}'
)
```

### Example 6: Voice-Enabled Office
```bash
SOURCE_TABLE="Test1"
TARGET_TABLE="Test2"
REGION="us-west-2"

REMOVE_ATTRS=("RemoveThis")
RENAME_ATTRS=("Queue:QueueARN" "Name:firstname")
SET_DEFAULTS=()
ADD_STRINGS=(
    "voice_enabled:true"
)
ADD_MAPS=(
    'voice_prompts:{"M":{"en-US":{"M":{"welcome":{"S":"<speak>Welcome to the office</speak>"},"queue_message":{"S":"<speak>Please wait while we connect you</speak>"}}},"es-US":{"M":{"welcome":{"S":"<speak>Bienvenido a la oficina</speak>"},"queue_message":{"S":"<speak>Por favor espere mientras le conectamos</speak>"}}}}}'
)
```

## Testing Your Configuration

### Step 1: Enable Dry Run
```bash
DRY_RUN=true
```

### Step 2: Run the Script
```bash
./migrate.sh
```

### Step 3: Review Output
Check the logs to see how items are transformed:
```
[2024-12-06 10:15:05]   Original item: {"Queue":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"RemoveThis":{"S":"12345gfghj"},"SystemEndpoint":{"S":"12345"},"Name":{"S":"Godwill Cho"}}
[2024-12-06 10:15:05]   Transformed item: {"SystemEndpoint":{"S":"12345"},"QueueARN":{"M":{"es-US":{"S":"345678"},"en-US":{"S":"12345"}}},"firstname":{"S":"Godwill Cho"},"migrated_at":{"S":"2024-12-06"}}
```

### Step 4: Verify Attributes
Ensure:
- ✅ RemoveThis is gone
- ✅ Queue renamed to QueueARN
- ✅ Name renamed to firstname
- ✅ New attributes added
- ✅ Existing attributes preserved (SystemEndpoint, etc.)

### Step 5: Run Actual Migration
```bash
DRY_RUN=false
./migrate.sh
```

## Troubleshooting

### Invalid JSON
If you get JSON parsing errors:
- Check that all quotes are properly escaped
- Verify the JSON structure with a validator
- Ensure the map follows DynamoDB format

### Attribute Not Added
If attributes don't appear:
- Check dry run output to see the transformation
- Verify the attribute name doesn't conflict with existing attributes
- Review logs for any parsing errors

### Complex Structures
For very complex maps:
1. Create the structure in a file first
2. Validate the JSON
3. Convert to single-line format
4. Test with a small dataset first
