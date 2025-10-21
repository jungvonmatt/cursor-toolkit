# MCP Servers Configuration

## What are MCP Servers?

**MCP (Model Context Protocol) servers** extend your AI assistant's capabilities by connecting it to external tools and services. Think of them as plugins that give your AI direct access to specialized functionality.

## Current Configuration

This DevKit includes a minimal MCP configuration:

- **`Sequential Thinking`** - Breaks down complex problems into structured steps
- **`eslint`** - JavaScript/TypeScript code quality checks
- **`context7`** - Knowledge graph access (optional API key for higher limits)
- **`Figma`** - Interact with Figma design files (requires local Figma plugin)
- **`chrome-devtools`** - Browser automation and debugging

### Why Minimal?

Most development tasks work better via shell commands (git, file operations, testing). MCP servers add value for **structured data access** that's hard to achieve via CLI alone.

## Setup Instructions

1. Copy the MCP configuration:

```bash
cp mcp/mcp.json .cursor/mcp.json
```

2. (Optional) Edit `.cursor/mcp.json` to add credentials:

- **context7**: Add API key for higher rate limits and private repos
- **Figma**: Requires local Figma plugin running on port 3845

3. Restart Cursor to load the servers

**Note**: MCP files must be at `.cursor/mcp.json` in your project root.

## Customizing Your Setup

Modify `.cursor/mcp.json` to fit your needs:

- Remove unused servers
- Add servers from the [Official MCP Registry](https://github.com/modelcontextprotocol/servers)
- Adjust args, env variables, or commands

Restart Cursor after changes.

## Additional Servers to Consider

**Language-Specific:**

- `@modelcontextprotocol/server-filesystem` - Enhanced file operations
- `@modelcontextprotocol/server-prettier` - Code formatting

**Infrastructure:**

- `@modelcontextprotocol/server-postgres` - Database queries
- `@modelcontextprotocol/server-kubernetes` - K8s management

**Integrations:**

- `@modelcontextprotocol/server-jira` - Issue tracking
- `@modelcontextprotocol/server-slack` - Team communication

Browse the [official registry](https://github.com/modelcontextprotocol/servers) for more.

## Security Notes

- Add `.cursor/mcp.json` to `.gitignore` (contains sensitive tokens)
- Use development tokens, not production credentials

## Additional Resources

- [Official Cursor MCP Documentation](https://docs.cursor.com/mcp)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
