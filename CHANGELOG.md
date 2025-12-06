# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-06

### Added
- Initial release of DynamoDB Migration Tool
- Attribute removal functionality
- Attribute renaming functionality
- Default value setting (text and SSML support)
- Verbose logging with timestamps
- Dry run mode for testing
- Batch processing with configurable batch size
- Progress tracking and statistics
- Error handling and retry logic
- Support for AWS profiles
- Configurable scan limits and delays

### Features
- Remove unwanted attributes from source table
- Rename attributes during migration
- Set default values for new or existing attributes
- SSML format support for voice applications
- Detailed logging of every operation
- Real-time progress updates
- Success/failure statistics
- Automatic pagination for large tables
- Batch write optimization

### Documentation
- Comprehensive README with examples
- Contributing guidelines
- MIT License
- Example configuration file
- GitHub workflows for testing

## [Unreleased]

### Planned
- Parallel processing support
- Custom transformation functions
- Cross-account migration support
- Resume from checkpoint functionality
- Item filtering based on conditions
- Statistics export to CSV
- CloudWatch metrics integration
