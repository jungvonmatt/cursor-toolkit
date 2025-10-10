# MCP Servers Configuration

## What are MCP Servers?

**MCP (Model Context Protocol) servers** extend your AI assistant's capabilities by connecting it to external tools and services. Think of them as plugins that give your AI direct access to specialized functionality.

## Current Configuration

This DevKit includes a minimal MCP configuration focused on universal utility:

- **`Sequential Thinking`** - Helps AI break down complex problems into structured steps
- **`eslint`** - JavaScript/TypeScript code quality checks (for JS/TS projects)
- **`context7`** - Access to a knowledge graph (requires separate account)
- **`Figma`** - Interact with Figma design files (requires Figma token)

### Why Minimal?

**Most development tasks are better handled via shell commands:**
- Git operations → Use `git` and `gh` CLI (see `/workflows/working-with-git.md`)
- File operations → Built into Cursor
- Testing/linting → Run via terminal (e.g., `npx eslint .`)

MCP servers add value when they provide **structured data access** that's hard to achieve via CLI alone.


## Setup Instructions

1. Copy the MCP configuration:
   ```bash
   cp cursor/mcp/mcp.json .cursor/mcp.json
   ```

2. Edit `cursor/mcp.json` and configure credentials:
   - **GitHub**: Add your Personal Access Token (Settings → Developer settings → Tokens)
   - **Time**: Adjust timezone if needed (default: `Europe/Berlin`)

3. Restart Cursor to load the MCP servers

### Configuration File Location

**Important**: MCP files must be at `.cursor/mcp.json` in your project root. Cursor will not recognize MCP configurations in other locations or with different filenames.

## Customizing Your Setup

You can modify `.cursor/mcp.json` to fit your needs:

- **Remove servers you don't need** - Delete entries from the JSON
- **Add project-specific servers** - See [Official MCP Registry](https://github.com/modelcontextprotocol/servers)
- **Adjust configurations** - Modify args, env variables, or commands

**Note**: After changes, restart Cursor to apply the new configuration.

## Common MCP Servers to Consider

If you need additional functionality, here are well-maintained options:

**Language-Specific:**
- `@modelcontextprotocol/server-filesystem` - Enhanced file operations
- `@modelcontextprotocol/server-prettier` - Code formatting

**Infrastructure:**
- `@modelcontextprotocol/server-postgres` - Database queries
- `@modelcontextprotocol/server-kubernetes` - K8s management

**Integrations:**
- `@modelcontextprotocol/server-jira` - Issue tracking
- `@modelcontextprotocol/server-slack` - Team communication

Browse the [official registry](https://github.com/modelcontextprotocol/servers) for more options.

## Security Notes

- API keys are stored in `.cursor/mcp.json` (local file, not committed to git)
- Add `.cursor/mcp.json` to `.gitignore` if it contains sensitive tokens
- Use environment-specific tokens, not production credentials

## Additional Resources

- [Official Cursor MCP Documentation](https://docs.cursor.com/mcp)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
