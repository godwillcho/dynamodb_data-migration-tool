# Contributing to DynamoDB Migration Tool

Thank you for considering contributing to this project! 

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your environment (OS, AWS CLI version, bash version)
- Relevant logs (sanitized of sensitive data)

### Suggesting Enhancements

We welcome feature requests! Please open an issue with:
- A clear description of the feature
- Use case and why it would be valuable
- Any implementation ideas you might have

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly with dry run mode
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Guidelines

- Keep the script compatible with bash 4.0+
- Maintain verbose logging for all operations
- Test with both dry run and actual migrations
- Update README.md with any new features
- Ensure error handling is robust

### Testing Checklist

Before submitting a PR, please test:
- [ ] Dry run mode works correctly
- [ ] Attribute removal works
- [ ] Attribute renaming works
- [ ] Default value setting works (text and SSML)
- [ ] Batch processing handles large datasets
- [ ] Error handling works for failed writes
- [ ] Statistics calculation is accurate
- [ ] Logging is clear and helpful

## Questions?

Feel free to open an issue for any questions about contributing!
