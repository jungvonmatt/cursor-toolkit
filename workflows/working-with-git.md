# Working with Git: Complete Reference for AI Assistants

This document provides comprehensive Git workflows, GitHub CLI commands, and Pull Request templates for AI assistants working with code repositories.

## 🎯 Overview

This guide covers Git operations, GitHub CLI usage, and Pull Request management patterns that can be referenced by other cursor rule documents. It focuses on **generically applicable** workflows that are not specific to any particular development methodology.

## 📋 Core Principles

- **GitHub CLI Only**: All GitHub interactions via `gh` commands
- **English Content**: All GitHub content in English regardless of communication language
- **Atomic Commits**: Small, focused commits with clear messages
- **Conventional Commits**: Follow conventional commit message format
- **Branch Naming**: Consistent branch naming conventions
- **Simple Tools**: Use Git built-in commands over complex scripts

## Repository

The repository of this product is `georgi-io/sales1-prototype`

## 🌿 Git Branching Strategy

### Branch Naming Conventions

```bash
# Feature branches
feature/issue-[number]-[short-description]
feature/user-authentication
feature/payment-integration

# Bug fix branches
fix/issue-[number]-[short-description]
fix/login-validation-error
fix/memory-leak-in-processor

# Documentation branches
docs/[description]
docs/api-documentation
docs/readme-updates

# Hotfix branches
hotfix/[description]
hotfix/security-patch
hotfix/critical-bug-fix
```

### Branch Management

```bash
# Create and switch to new branch
git checkout -b feature/issue-123-user-auth

# Keep branches small and focused
# Merge frequently to avoid conflicts
# Delete branches after merge

# Clean up local branches
git branch -d feature/issue-123-user-auth
git remote prune origin
```

## 💬 Commit Message Standards

### Conventional Commits Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types

```bash
# Features
feat: add user authentication system
feat(auth): implement OAuth2 integration

# Bug fixes
fix: resolve login validation error
fix(api): handle null response from external service

# Documentation
docs: update API documentation
docs(readme): add installation instructions

# Code style/formatting
style: fix indentation in user service
style(lint): resolve ESLint warnings

# Refactoring
refactor: extract user validation logic
refactor(auth): simplify token generation

# Performance improvements
perf: optimize database queries
perf(cache): implement Redis caching

# Tests
test: add unit tests for user service
test(integration): add API endpoint tests

# Configuration changes
config: update webpack configuration
config(env): add production environment variables

# Build/deployment
build: update Docker configuration
ci: add GitHub Actions workflow
```

### Commit Message Examples

```bash
# Good commit messages provide good information about the changes
git commit -m "feat: add user registration endpoint"
git commit -m "fix: resolve memory leak in image processor"
git commit -m "docs: update API documentation with new endpoints"
git commit -m "refactor: extract email validation logic to utility"

# Avoid these patterns because they provide minimal information
git commit -m "updates"
git commit -m "fix stuff"
git commit -m "WIP"
git commit -m "changes"
```

## 🛠️ GitHub CLI Commands Reference

### Authentication

```bash
# Check authentication status
gh auth status

# Login to GitHub
gh auth login

# Logout
gh auth logout
```

### Repository Operations

```bash
# View repository information
gh repo view [org]/[repo]

# List repositories
gh repo list [org] --limit 20

# Clone repository
gh repo clone [org]/[repo]

# Fork repository
gh repo fork [org]/[repo]
```

### Issue Management

```bash
# View issue
gh issue view [issue-number] --repo [org]/[repo]

# View issue with comments
gh issue view [issue-number] --comments --repo [org]/[repo]

# Create issue
gh issue create \
  --repo [org]/[repo] \
  --title "Issue Title" \
  --body-file issue-body.md \
  --label "bug,high-priority"

# Edit issue
gh issue edit [issue-number] --repo [org]/[repo] --body-file updated-body.md

# Add comment to issue
gh issue comment [issue-number] --repo [org]/[repo] --body-file comment.md

# Add labels to issue
gh issue edit [issue-number] --repo [org]/[repo] --add-label "needs-review"

# Remove labels from issue
gh issue edit [issue-number] --repo [org]/[repo] --remove-label "in-progress"

# Close issue
gh issue close [issue-number] --repo [org]/[repo]

# List issues
gh issue list --repo [org]/[repo] --state open --label "bug"
```

### Pull Request Management

```bash
# Create pull request
gh pr create \
  --repo [org]/[repo] \
  --title "PR Title" \
  --body-file pr-description.md \
  --base main \
  --head feature/branch-name \
  --label "ready-for-review"

# View pull request
gh pr view [pr-number] --repo [org]/[repo]

# View pull request with comments
gh pr view [pr-number] --comments --repo [org]/[repo]

# List pull requests
gh pr list --repo [org]/[repo] --state open

# Add reviewer to PR
gh pr edit [pr-number] --repo [org]/[repo] --add-reviewer "username"

# Merge pull request
gh pr merge [pr-number] --repo [org]/[repo] --squash --delete-branch

# Close pull request
gh pr close [pr-number] --repo [org]/[repo]

# Check PR status
gh pr status --repo [org]/[repo]
```

### Data Export

```bash
# Export issue data as JSON
gh issue view [issue-number] --json title,body,comments --repo [org]/[repo]

# Export PR data as JSON
gh pr view [pr-number] --json title,body,comments,commits --repo [org]/[repo]

# Export repository data
gh repo view [org]/[repo] --json name,description,url,defaultBranch
```

## 🤖 AI-Assisted Commit Message Generation

### Quick Git Diff Commands

```bash
# For commit message generation (staged/unstaged changes)
git diff HEAD > .temp/commit-diff.txt

# For PR description (changes vs target branch)
git diff origin/dev > .temp/pr-diff.txt

# For commit history context
git log origin/dev...HEAD --oneline > .temp/recent-commits.txt
git log origin/dev...HEAD --pretty=format:"%H%n%B%n---" > .temp/detailed-commits.txt
```

### AI Commit Message Analysis Process

1. **Generate Diff for Analysis**

   ```bash
   # Simple command - no scripts needed
   git diff HEAD > .temp/commit-diff.txt
   ```

2. **Analyze Changes**
   - Review the git diff output
   - Identify affected files and components
   - Understand the nature of changes (feature, fix, refactor, etc.)
   - Categorize: code changes, config, docs, dependencies, build/CI

3. **Generate Commit Message**
   Follow conventional commits format with AI assistance:

   ```
   <type>(<scope>): <subject>

   <body>

   <footer>
   ```

4. **Apply and Cleanup**

   ```bash
   # Prepare commit message
   echo "feat(auth): add OAuth2 authentication support

   Implement OAuth2 authentication flow using Auth0:
   - Add OAuth2 client configuration
   - Create authentication middleware
   - Add user session management
   - Update login/logout flows

   Fixes #234" > .temp/commit-message.txt

   # Apply commit
   git commit -F .temp/commit-message.txt

   # Cleanup
   rm .temp/commit-message.txt .temp/commit-diff.txt
   ```

### Commit Message Quality Guidelines

**Types and Usage:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding missing tests
- `chore`: Maintenance tasks, dependency updates
- `build`: Build system or external dependency changes
- `ci`: CI configuration changes
- `perf`: Performance improvements

**Subject Line Rules:**

- Imperative mood ("add" not "added" or "adds")
- No period at the end
- Maximum 50 characters
- Start with lowercase
- Clear and concise

**Body Guidelines:**

- Wrap at 72 characters
- Explain what and why vs. how
- Include motivation for change
- Use bullet points for multiple points

## 🤖 AI-Assisted PR Description Generation

### Generate PR Context

```bash
# Target branch (usually origin/dev)
TARGET_BRANCH=${GIT_DIFF_BRANCH:-origin/dev}

# Generate all needed context in one go
git fetch
git diff "$TARGET_BRANCH" > .temp/pr-diff.txt
git log "$TARGET_BRANCH...HEAD" --oneline > .temp/pr-commits.txt
git log "$TARGET_BRANCH...HEAD" --pretty=format:"%H%n%B%n---" > .temp/pr-detailed-commits.txt

echo "PR context generated in .temp/ directory"
```

### AI PR Description Analysis Process

1. **Analyze Git Diff and Commits**
   - Review `.temp/pr-diff.txt` for technical changes
   - Review `.temp/pr-detailed-commits.txt` for context and ticket references
   - Identify key changes, affected components, and overall impact

2. **Extract Ticket References**
   - Find all ticket numbers mentioned in commit messages
   - Ensure all tickets are properly tagged in PR description
   - Include closing references (e.g., "Closes #123")

3. **Generate Comprehensive PR Description**
   - Title: Concise, under 72 characters, with main ticket number
   - Overview: Brief description of changes and purpose
   - Key Changes: Major modifications and their impact
   - Technical Details: Implementation approach and architecture considerations
   - Testing: Coverage and verification steps

### PR Creation Workflow

1. **Generate Description**

   ```bash
   # Create PR description file
   cat > .temp/pr-description.md << 'EOT'
   ## Overview
   Brief description of the changes and their purpose

   ## Key Changes
   - Major change 1
   - Major change 2
   - Major change 3

   ## Technical Details
   - Detailed technical change 1
   - Implementation approach details
   - Architecture considerations

   ## Testing
   - Test coverage description
   - Verification steps completed
   - Manual testing scenarios

   ## Ticket References
   Closes #123, #456
   Related to #789
   EOT
   ```

2. **Create PR with GitHub CLI**

   ```bash
   # Recommended approach - create then edit
   gh pr create \
     --title "feat: implement user authentication [TKD-84]" \
     --body "Initial PR - updating description..." \
     --base dev

   # Get PR number and update with formatted content
   PR_NUMBER=$(gh pr list --head $(git branch --show-current) --json number --jq '.[0].number')
   gh pr edit $PR_NUMBER --body-file .temp/pr-description.md
   ```

3. **Cleanup**
   ```bash
   rm .temp/pr-*.txt .temp/pr-description.md
   ```

### GitHub CLI Troubleshooting

**Common Issues and Solutions:**

1. **Newline Problems in --body**

   ```bash
   # ❌ Don't do this
   gh pr create --body "Line 1\nLine 2"

   # ✅ Use file-based approach
   gh pr create --body-file description.md
   ```

2. **Quote Escaping Issues**

   ```bash
   # ❌ Avoid complex inline quoting
   gh pr create --body "Quote: \"complex content\""

   # ✅ Use heredoc approach
   cat > .temp/pr-body.md << 'EOT'
   Quote: "simple content"
   EOT
   gh pr create --body-file .temp/pr-body.md
   ```

3. **Large PR Descriptions**
   ```bash
   # Always use file-based approach for multi-line content
   gh pr create --title "Title" --body-file .temp/description.md
   ```

## 📝 Pull Request Templates

### Comprehensive PR Template (AI-Generated)

```markdown
# [type]: [Brief description] [#ticket]

Closes #[issue-number]

## 📋 Overview

[AI-generated summary based on git diff and commit analysis]

## 🔧 Key Changes

### Modified Components

- **[Component 1]**: [Description of changes]
- **[Component 2]**: [Description of changes]
- **[Component 3]**: [Description of changes]

### Technical Implementation

- [High-level approach description]
- [Key technical decisions made]
- [Architecture patterns used]

## 🧪 Testing & Validation

### Test Coverage

- **Unit Tests**: [Coverage description]
- **Integration Tests**: [Coverage description]
- **Manual Testing**: [Scenarios covered]

### Verification Checklist

- [ ] All existing tests pass
- [ ] New functionality is tested
- [ ] Code follows project standards
- [ ] Documentation updated

## 📊 Impact Analysis

### Performance Impact

- [Expected performance impact or "No significant impact"]

### Breaking Changes

- [List any breaking changes or "No breaking changes"]

### Security Considerations

- [Security implications or "No security implications"]

## 🎯 Ticket References

### Primary Tickets

- Closes #[main-ticket]: [Brief description]
- Fixes #[bug-ticket]: [Brief description]

### Related Work

- Related to #[related-ticket]: [Brief description]
- Follows up on #[previous-ticket]: [Brief description]

## 📚 Additional Context

[Any additional context, screenshots, or references that would help reviewers]

---

_This PR description was generated with AI assistance based on git diff analysis and commit message review._
```

## 🔄 AI-Enhanced Git Workflows

### Feature Development with AI Assistance

```bash
# 1. Create feature branch
git checkout -b feature/issue-123-new-feature

# 2. Develop with regular commits (AI-assisted messages)
git add .
git diff HEAD > .temp/commit-diff.txt
# [Use AI to generate commit message based on diff]
echo "Generated commit message" > .temp/commit-message.txt
git commit -F .temp/commit-message.txt
rm .temp/commit-*.txt

# 3. Push and create AI-enhanced PR
git push -u origin feature/issue-123-new-feature

# Generate PR context
git diff origin/dev > .temp/pr-diff.txt
git log origin/dev...HEAD --pretty=format:"%H%n%B%n---" > .temp/pr-commits.txt

# [Use AI to generate PR description]
# Create PR with generated content
gh pr create --title "feat: New feature [#123]" --body-file .temp/pr-description.md

# Cleanup
rm .temp/pr-*.txt .temp/pr-description.md
```

### Bug Fix with AI Documentation

```bash
# 1. Create bug fix branch
git checkout -b fix/issue-456-memory-leak

# 2. Fix with detailed AI-assisted commit
git add src/processor.js
git diff HEAD > .temp/commit-diff.txt
# [AI analyzes diff and generates detailed fix description]
git commit -F .temp/commit-message.txt

# 3. Add tests with separate commit
git add tests/processor.test.js
git diff HEAD > .temp/commit-diff.txt
# [AI generates test commit message]
git commit -F .temp/commit-message.txt

# 4. Create comprehensive PR
git push -u origin fix/issue-456-memory-leak
# [AI generates bug fix PR with root cause analysis]
gh pr create --title "fix: Resolve memory leak in processor [#456]" --body-file .temp/fix-description.md
```

## 📁 File Management Patterns

### Temporary Files Structure

```bash
# Recommended temporary file organization
.temp/
├── git/                    # Git-related temporary files
│   ├── commit-messages/    # Commit message drafts
│   ├── pr-descriptions/    # PR description drafts
│   └── branch-notes/       # Branch-specific notes
├── docs/                   # Documentation drafts
└── scripts/               # Temporary scripts
```

### Commit Message Workflow

**Standard Process**: All commit messages should be prepared, used, and cleaned up using a standardized file approach.

```bash
# 1. Prepare commit message in standardized location
echo "feat: implement user authentication

- Add JWT token generation
- Implement middleware for auth checking
- Add user login/logout endpoints
- Include comprehensive error handling

Closes #123" > .temp/commit-message.txt

# 2. Use the prepared message
git commit -F .temp/commit-message.txt

# 3. Clean up the message file
rm .temp/commit-message.txt
```

**For AI Assistants**: When executing Git commits:

1. **Always** prepare commit message in `.temp/commit-message.txt`
2. Use `git commit -F .temp/commit-message.txt` to apply the message
3. **Always** delete `.temp/commit-message.txt` after successful commit
4. If commit fails, leave message file for debugging and retry

### Legacy Commit Message Drafts

```bash
# For complex commits that need revision, you can still save drafts
echo "feat: complex feature implementation

[Draft message for review]" > .temp/git/commit-messages/auth-feature-draft.txt

# Edit and finalize, then copy to standard location
cp .temp/git/commit-messages/auth-feature-draft.txt .temp/commit-message.txt
git commit -F .temp/commit-message.txt
rm .temp/commit-message.txt
```

## ⚠️ Git Best Practices

### AI-Assisted Development Do's

- ✅ **Use AI for commit message quality** - Better descriptions and consistency
- ✅ **Generate comprehensive PR descriptions** - Save time and improve clarity
- ✅ **Use simple Git commands** - Avoid overengineered scripts
- ✅ **Analyze diffs before committing** - Understand what you're committing
- ✅ **Clean up temporary files** - Don't clutter the workspace
- ✅ **Use file-based GitHub CLI operations** - Avoid quote/newline issues

### Don'ts

- ❌ **Don't commit without understanding changes** - Even with AI assistance
- ❌ **Don't use complex scripts for simple Git tasks**
- ❌ **Don't skip manual review** - AI assists, doesn't replace judgment
- ❌ **Don't leave temporary files around** - Clean up .temp/ directory

### Security Considerations

```bash
# Check for sensitive data before committing
git diff --cached

# Use .gitignore to exclude sensitive files
echo "*.env" >> .gitignore
echo "config/secrets.json" >> .gitignore
echo ".temp/" >> .gitignore

# Remove sensitive data from history (if needed)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/sensitive/file' \
  --prune-empty --tag-name-filter cat -- --all
```

## 🚨 Emergency Procedures

### Fixing Broken Main Branch

```bash
# 1. Identify the problem commit
git log --oneline -10

# 2. Create revert commit
git revert [commit-hash]

# 3. Push fix immediately
git push origin main

# 4. Create incident issue
gh issue create --title "INCIDENT: Broken main branch" --body-file incident-report.md --label "incident"
```

### Recovering Lost Commits

```bash
# 1. Find lost commits
git reflog

# 2. Recover commit
git cherry-pick [commit-hash]

# 3. Create recovery branch
git checkout -b recovery/lost-commits
git push -u origin recovery/lost-commits
```

## 🔗 Integration with Other Cursor Rules

This document is designed to be referenced by other cursor rule documents:

### Usage in Other Documents

```markdown
## Git Operations

**Load Git documentation when needed**: Reference project documentation for Git workflows and policies.

**Validation**: Agent must confirm successful loading before Git operations.

**Project-Specific Policies**: [Add project-specific git policies here]
```

### Common References

- **Basic Git Commands**: Reference "Git Workflows" section
- **GitHub CLI**: Reference "GitHub CLI Commands Reference" section
- **PR Templates**: Reference "Pull Request Templates" section
- **Commit Standards**: Reference "Commit Message Standards" section

---

**Usage**: This document provides complete Git and GitHub CLI context for development workflows. Reference specific sections as needed via project documentation references to avoid circular loading patterns.
