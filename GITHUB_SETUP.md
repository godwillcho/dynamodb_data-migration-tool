# GitHub Repository Setup Instructions

## Repository Structure

```
dynamodb-migration-tool/
├── .github/
│   └── workflows/
│       └── test.yml           # GitHub Actions workflow
├── .gitignore                 # Git ignore file
├── CHANGELOG.md               # Version history
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # MIT License
├── QUICKSTART.md             # Quick start guide
├── README.md                 # Main documentation
├── config.example.sh         # Example configuration
└── migrate.sh                # Main migration script
```

## Step-by-Step GitHub Upload

### Option 1: Create New Repository via GitHub Web Interface

1. **Go to GitHub** and create a new repository
   - Repository name: `dynamodb-migration-tool`
   - Description: `A powerful bash script for migrating DynamoDB tables with attribute transformation support`
   - Choose: Public or Private
   - DO NOT initialize with README (we have our own)

2. **Clone and upload files:**
```bash
# Create local git repository
cd /path/to/files
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: DynamoDB Migration Tool v1.0.0"

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/dynamodb-migration-tool.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Option 2: Using GitHub CLI

```bash
# Install GitHub CLI if needed
# macOS: brew install gh
# Linux: https://github.com/cli/cli#installation

# Login to GitHub
gh auth login

# Create repository
gh repo create dynamodb-migration-tool --public --source=. --remote=origin

# Push files
git add .
git commit -m "Initial commit: DynamoDB Migration Tool v1.0.0"
git push -u origin main
```

### Option 3: Using Git Commands (if repo exists)

```bash
# Navigate to your files directory
cd /path/to/files

# Initialize git
git init

# Add files
git add .

# Commit
git commit -m "Initial commit: DynamoDB Migration Tool v1.0.0"

# Add remote (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/dynamodb-migration-tool.git

# Push
git branch -M main
git push -u origin main
```

## Repository Settings (After Upload)

### 1. Enable GitHub Actions
- Go to Settings → Actions → General
- Enable "Allow all actions and reusable workflows"

### 2. Add Topics/Tags
Add these topics to help others discover your repo:
- `dynamodb`
- `aws`
- `migration`
- `bash`
- `database`
- `etl`
- `data-migration`
- `aws-cli`

### 3. Add Description
Set the repository description:
```
A powerful bash script for migrating DynamoDB tables with support for attribute removal, renaming, and default values. Features verbose logging, dry run mode, and batch processing.
```

### 4. Setup Branch Protection (Optional)
- Go to Settings → Branches
- Add rule for `main` branch
- Enable "Require pull request reviews before merging"

### 5. Create Release
```bash
# Tag the release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

Then on GitHub:
- Go to Releases → Create a new release
- Choose tag: v1.0.0
- Title: "DynamoDB Migration Tool v1.0.0"
- Description: Copy from CHANGELOG.md

## Recommended GitHub README Badges

Add these to the top of README.md:

```markdown
# DynamoDB Migration Tool

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Bash](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)
![AWS](https://img.shields.io/badge/AWS-DynamoDB-orange.svg)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
```

## Clone URL for Others

After upload, users can clone with:

```bash
# HTTPS
git clone https://github.com/YOUR_USERNAME/dynamodb-migration-tool.git

# SSH
git clone git@github.com:YOUR_USERNAME/dynamodb-migration-tool.git

# GitHub CLI
gh repo clone YOUR_USERNAME/dynamodb-migration-tool
```

## Quick Test After Upload

```bash
# Clone your repo
git clone https://github.com/YOUR_USERNAME/dynamodb-migration-tool.git
cd dynamodb-migration-tool

# Make executable
chmod +x migrate.sh

# Test syntax
bash -n migrate.sh

# View help (if you add help flag)
./migrate.sh --help
```

## Update Repository Later

```bash
# Make changes to files
nano migrate.sh

# Stage changes
git add .

# Commit
git commit -m "Update: Add new feature X"

# Push
git push origin main

# Create new release (if major update)
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0
```

## Social Sharing

Share your repository:
- **Twitter/X**: "Just released a DynamoDB migration tool! 🚀 Features: attribute transformation, SSML support, verbose logging. Check it out: [URL]"
- **LinkedIn**: Post about solving DynamoDB migration challenges
- **Reddit**: Share in r/aws, r/devops
- **Dev.to**: Write an article about the tool

## Star and Watch

Encourage users to:
- ⭐ Star the repository
- 👁️ Watch for updates
- 🍴 Fork to contribute

## License Notice

Make sure LICENSE file contains:
- MIT License text
- Current year (2024)
- Your name or organization

## Final Checklist

- [ ] All files uploaded
- [ ] README displays correctly
- [ ] Actions workflow runs successfully  
- [ ] Example config works
- [ ] Quick start guide tested
- [ ] License added
- [ ] Topics/tags added
- [ ] Description set
- [ ] First release created
- [ ] Repository public/private as intended
