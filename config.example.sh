#!/bin/bash

# Example Configuration for DynamoDB Migration
# Copy this to migrate.sh and customize for your needs

# ============================================
# BASIC CONFIGURATION
# ============================================

SOURCE_TABLE="my-source-table"
TARGET_TABLE="my-target-table"
REGION="us-east-1"
PROFILE=""  # Leave empty for default, or specify AWS profile name

# ============================================
# TRANSFORMATION RULES
# ============================================

# Remove these attributes from source table
REMOVE_ATTRS=(
    "temporary_field"
    "debug_data"
)

# Rename attributes (format: "old_name:new_name")
RENAME_ATTRS=(
    "user_id:userId"
    "email_address:email"
)

# Set default values (format: "attribute_name:value")
SET_DEFAULTS=(
    "status:active"
    "version:1.0"
)

# ============================================
# ADVANCED OPTIONS
# ============================================

DRY_RUN=true   # Set to false for actual migration
BATCH_SIZE=25  # DynamoDB max is 25
SCAN_LIMIT=100 # Items to scan per iteration

# ============================================
# EXAMPLE CONFIGURATIONS
# ============================================

# Example 1: Simple cleanup migration
# REMOVE_ATTRS=("temp_data" "old_field")
# RENAME_ATTRS=()
# SET_DEFAULTS=()

# Example 2: Schema evolution
# REMOVE_ATTRS=()
# RENAME_ATTRS=("oldName:newName" "old_id:id")
# SET_DEFAULTS=("migrated:true" "schema_version:2.0")

# Example 3: Voice app with SSML
# REMOVE_ATTRS=()
# RENAME_ATTRS=()
# SET_DEFAULTS=("greeting:<speak>Hello <emphasis>world</emphasis></speak>")
