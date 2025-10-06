# Contributing to AI DevKit

The AI DevKit is designed to maximize developer productivity and AI adoption across Jung von Matt. We welcome contributions that enhance ease of use, reduce manual work, and improve the developer experience.

## 🎯 Core Contribution Principles

**The #1 priority for AI DevKit contributions is ease of use, improved developer experience, and increasing adoption of AI tooling across Jung von Matt.**

Every contribution should:

- ✨ Be super user-friendly
- 🚀 Reduce manual work for other developers
- 🤖 Automate as much as possible
- 🎯 Aim for one-click installation/usage where feasible
- 🌍 Be general-purpose (not project-specific), providing value to any Jung von Matt codebase.
- 📦 Work with minimal developer input

## 📋 What Can You Contribute?

We accept contributions to all areas of the AI DevKit:

1. **Cursor Rules** (`cursor/cursor-rules/`)
   - New AI behavior patterns
   - Improvements to existing rules
   - Technology-specific guidelines

2. **Workflows** (`workflows/`)
   - New development workflows
   - Enhanced AI assistant guidance
   - Cross-repository patterns

3. **Scripts** (setup/update scripts)
   - Automation improvements
   - Error handling enhancements
   - Cross-platform compatibility

4. **Documentation**
   - Clarity improvements
   - Additional examples
   - Troubleshooting guides

## 🔍 Contribution Requirements

**CRITICAL**: All contributions must be general-purpose. They should work across different codebases at Jung von Matt, not be specific to a single project.

## ✅ Pre-Submission Checklist

Before submitting your pull request, ensure you've completed this checklist:

### General Requirements

- [ ] Contribution is general-purpose (not project-specific)
- [ ] Code/content follows existing patterns and conventions
- [ ] All text is in clear, professional English
- [ ] No hardcoded paths or project-specific references

### Testing & Validation

- [ ] Tested in at least 2 different project types
- [ ] Verified setup script still works correctly
- [ ] Confirmed no breaking changes to existing functionality
- [ ] Tested on relevant platforms (macOS/Linux/Windows if applicable)

### Documentation

- [ ] Updated relevant documentation
- [ ] Added clear examples where appropriate
- [ ] Included any new setup requirements
- [ ] Documented any new dependencies

### Automation & UX

- [ ] Maximizes automation (minimal manual steps)
- [ ] Reduces friction for end users
- [ ] Works with minimal developer input
- [ ] Includes helpful error messages
- [ ] Provides clear success confirmations

### Code Quality

- [ ] Follows existing code style
- [ ] Includes appropriate error handling
- [ ] Uses consistent naming conventions
- [ ] Avoids unnecessary complexity

## 📝 Submission Process

1. **Fork the repository** and create a feature branch
2. **Make your changes** following the guidelines above
3. **Test thoroughly** in multiple environments
4. **Complete the checklist** above
5. **Submit a pull request** with:
   - Clear title describing the change
   - Detailed description of what and why
   - Examples of usage (if applicable)
   - Screenshots/recordings for UI changes

## 👥 Review Process

All contributions must be reviewed by one of the original AI DevKit contributors:

- Sebastian Giorgio
- Florian Struck
- Adam Zdrzalka

Reviews will focus on:

- Adherence to contribution principles
- General-purpose applicability
- Impact on developer experience
- Automation and ease of use

## 💡 Contribution Ideas

Looking for ways to contribute? Consider:

- Automating repetitive development tasks
- Creating new AI workflows for common patterns
- Adding powerful new prompts, Cursor rules and helpful MCP servers
- Improving error messages and troubleshooting
- Adding support for new technologies
- Enhancing cross-platform compatibility
- Reducing setup complexity

## 🚫 What NOT to Contribute

Please avoid:

- Project-specific configurations
- Hardcoded values or paths
- Features requiring extensive manual setup
- Complex dependencies without clear value
- Anything that increases friction for users

## 🌟 Recognition

We value all contributions that improve the developer experience. Significant contributions will be recognized in our documentation and release notes.

Remember: **Maximize adoption. Automate as much as possible. Reduce friction.**

## 🎨 Code Formatting

The AI DevKit uses Prettier for automatic code formatting to ensure consistent code style.

### Setup (Already Complete)

The project is configured with:

- **Prettier** for code formatting
- **Husky** for Git hooks
- **lint-staged** for formatting only changed files on commit

### Usage

**Format all files:**

```bash
pnpm format
```

**Check formatting without changes:**

```bash
pnpm format:check
```

**Automatic formatting on commit:**
Files are automatically formatted when you commit changes. The pre-commit hook runs prettier on all staged files matching these patterns:

- `*.js`, `*.jsx`, `*.ts`, `*.tsx` - JavaScript/TypeScript files
- `*.json` - JSON files
- `*.css`, `*.scss` - Stylesheets
- `*.md` - Markdown files
- `*.yaml`, `*.yml` - YAML files

### Configuration

- **`.prettierrc`** - Prettier formatting rules
- **`.prettierignore`** - Files/folders to skip formatting
- **`.husky/pre-commit`** - Git hook configuration
