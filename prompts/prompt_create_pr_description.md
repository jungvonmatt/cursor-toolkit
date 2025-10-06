You will now create a pull request description for this feature branch.

1. Fetch the default branch for the repository (origin/dev or origin/main)
2. Git diff the changes between this feature branch and the default branch
3. Based on the diff, create a pull request description. In your pull request description, focus on the key modifications to logic, structure, and functionality. Write a clear pull request description that includes:
   - A summary of the purpose of the changes
   - A breakdown of major changes or refactors
   - Any relevant context or decisions
   - Optional: instructions for reviewers or testing

   Note: Use markdown formatting in the pull request description.

4. Write the pull request description to a temporary file. The file path is: .cursor/temp/temp-pr-description.md.

5. Use the Github CLI to create a pull request and paste in the pull request description from the temporary file.

6. Delete the temporary file.

## Pull Request Title Guidelines

A good pull request title should follow these conventions:

### Format

Use the format: `{type}({scope}): {description}` or `{type}: {description}`

### Types

- `feat`: New feature or functionality
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code formatting, missing semicolons, etc.
- `refactor`: Code restructuring without changing functionality
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates
- `perf`: Performance improvements
- `ci`: CI/CD pipeline changes
- `build`: Build system or external dependency changes

### Examples of Good PR Titles

1. `feat(auth): implement OAuth2 login with Google provider`
2. `fix(api): resolve memory leak in user session handling`
3. `docs: update installation guide with Docker setup`
4. `refactor(components): extract reusable Button component`
5. `test(user-service): add integration tests for user creation`
6. `chore: upgrade React from v17 to v18`
7. `perf(database): optimize user query with proper indexing`
8. `style: format codebase with Prettier configuration`
9. `ci: add automated testing workflow for pull requests`
10. `fix(frontend): correct responsive layout on mobile devices`

### Additional Tips

- Use imperative mood ("add" not "added" or "adds")
- Keep titles under 72 characters when possible
- Include issue numbers: `feat: implement user auth (closes #123)`
- Be specific about what changed, not just where
- Avoid generic titles like "bug fixes" or "updates"
