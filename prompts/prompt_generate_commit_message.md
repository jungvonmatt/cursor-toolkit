# Git Commit Message Generation Prompt

## Task

Generate a Git commit message based on the staged files and their changes. Follow the strict format and conventions defined below.

## Process

1. **Analyze Staged Files**: Check which files are staged using `git diff --staged`
2. **Understand Changes**: Analyze the actual changes in the staged files to understand what was modified
3. **Determine Commit Type**: Based on the changes, select the appropriate commit type
4. **Extract Scope**: Identify the module, service, or component affected
5. **Write Subject**: Create a concise summary (max 50 characters)
6. **Compose Body**: Explain what and why (not how) in detail
7. **Add Footer**: Include issue references and breaking changes if applicable

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature or functionality
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (build process, dependencies, etc.)
- `perf`: Performance improvements
- `ci`: CI/CD configuration changes
- `build`: Build system or external dependency changes

### Scope

The scope should be the name of the module, service, or component affected:

- For backend services: use service name (e.g., `auth-service`, `customer-service`)
- For frontend: use component or feature name (e.g., `checkout`, `navigation`)
- For infrastructure: use the area (e.g., `terraform`, `docker`)
- For docs: use the documentation area (e.g., `api`, `architecture`)

### Subject Rules

- Use imperative mood ("Add feature" not "Added feature")
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters
- Be specific and meaningful

### Body Guidelines

- Wrap at 72 characters
- Explain what and why, not how
- Include motivation for the change
- Contrast behavior with previous behavior
- Use bullet points for multiple items
- Leave blank line between subject and body

### Footer Format

- Reference issues: `Refs: #123` or `Closes: #123`
- Breaking changes: Start with `BREAKING CHANGE:`
- Co-authors: `Co-authored-by: Name <email>`

## Examples

### Feature Commit

```
feat(auth-service): add JWT refresh token rotation

Implement automatic refresh token rotation to enhance security.
- Refresh tokens are now single-use
- New refresh token issued with each access token refresh
- Old refresh tokens are invalidated after use

Closes: #234
```

### Bug Fix Commit

```
fix(checkout): prevent double order submission

Add debounce mechanism to checkout button to prevent users from
accidentally submitting orders multiple times. This was causing
duplicate charges and inventory issues.

The button is now disabled for 2 seconds after click and shows
a loading state during order processing.

Refs: #456
```

### Documentation Commit

```
docs(api): update authentication flow documentation

- Add sequence diagram for JWT refresh flow
- Update API endpoints with new response codes
- Include examples for error handling
- Fix outdated bearer token examples

Refs: #789
```

## Instructions for Cursor

When generating a commit message:

1. **First**, run `git status` and `git diff --staged` to see what files are staged and what changes they contain

2. **Analyze** the changes:
   - What files were modified?
   - What was the nature of the changes?
   - Are there any breaking changes?
   - Is there an associated issue number?

3. **Generate** the commit message following this structure:
   - Choose the most appropriate type based on the primary change
   - Determine the scope from the affected files/modules
   - Write a clear, imperative subject line
   - Compose a detailed body explaining the changes
   - Add footer with issue references

4. **Validate** before presenting:
   - Subject line ≤ 50 characters
   - Body lines ≤ 72 characters
   - Correct type for the changes
   - Proper issue reference format
   - No trailing whitespace

## Quick Reference Format

For simple commits without body:

```
<type>(<scope>): <subject>
```

For commits with issue reference:

```
<type>(<scope>): <subject>

Refs: #<issue-number>
```

## GitLens Integration Note

If using GitLens experimental commit message generation:

- Set `gitlens.experimental.generateCommitMessagePrompt` to use this format
- Ensure issue numbers are properly referenced
- The generated message should be ready to commit without manual editing
