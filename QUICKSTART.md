# Quick Start Guide

Get started with DynamoDB Migration Tool in 5 minutes!

## Prerequisites Check

```bash
# Check AWS CLI
aws --version

# Check jq
jq --version

# Check AWS credentials
aws sts get-caller-identity
```

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dynamodb-migration-tool.git
cd dynamodb-migration-tool

# Make script executable
chmod +x migrate.sh
```

## Basic Usage

### Step 1: Configure the Script

Edit `migrate.sh` and set your configuration:

```bash
SOURCE_TABLE="my-old-table"
TARGET_TABLE="my-new-table"
REGION="us-east-1"
```

### Step 2: Define Transformations

```bash
# Remove unwanted attributes
REMOVE_ATTRS=(
    "temp_field"
)

# Rename attributes
RENAME_ATTRS=(
    "user_id:userId"
)

# Set default values
SET_DEFAULTS=(
    "status:active"
)
```

### Step 3: Test with Dry Run

```bash
# Enable dry run
DRY_RUN=true

# Run the script
./migrate.sh
```

### Step 4: Run Actual Migration

```bash
# Disable dry run
DRY_RUN=false

# Run the migration
./migrate.sh > migration.log 2>&1
```

### Step 5: Verify Results

```bash
# Check the log
cat migration.log

# Verify items in target table
aws dynamodb scan --table-name my-new-table --limit 5
```

## Common Scenarios

### Scenario 1: Clean Up Old Fields

```bash
REMOVE_ATTRS=("old_field1" "old_field2")
RENAME_ATTRS=()
SET_DEFAULTS=()
```

### Scenario 2: Modernize Schema

```bash
REMOVE_ATTRS=()
RENAME_ATTRS=(
    "firstName:first_name"
    "lastName:last_name"
)
SET_DEFAULTS=("schema_version:2.0")
```

### Scenario 3: Add Missing Data

```bash
REMOVE_ATTRS=()
RENAME_ATTRS=()
SET_DEFAULTS=(
    "status:pending"
    "created_by:migration"
)
```

## Troubleshooting

### Script won't run
```bash
chmod +x migrate.sh
```

### Missing jq
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

### Access denied
```bash
# Check your AWS credentials
aws configure list

# Verify table access
aws dynamodb describe-table --table-name SOURCE_TABLE
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [CONTRIBUTING.md](CONTRIBUTING.md) to contribute
- Review [config.example.sh](config.example.sh) for more examples

## Need Help?

- Open an issue on GitHub
- Check existing issues for solutions
- Review AWS DynamoDB documentation
