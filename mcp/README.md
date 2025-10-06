# MCP Servers for AI-Powered Development

## What are MCP Servers?

**MCP (Model Context Protocol) servers** are specialized tools that extend your AI assistant's capabilities by connecting it to external services, databases, APIs, and development tools. Think of them as "plugins" that give your AI direct access to the tools you use every day.

Instead of manually switching between your IDE, terminal, browser, and various tools, MCP servers allow your AI assistant to:

- Execute Git commands and manage repositories
- Query databases and APIs
- Interact with cloud services (AWS, Docker, etc.)
- Run tests and analyze code quality
- Manage project documentation and tickets

## Key Developer Benefits

### 🚀 **Increased Development Velocity**

- **Faster context switching**: AI can access multiple tools without you leaving your IDE
- **Automated routine tasks**: Let AI handle repetitive operations like API calls, database queries, and deployments
- **Instant information retrieval**: Get real-time data from external services without manual lookups

### 🎯 **Enhanced Code Quality**

- **Integrated quality checks**: AI can run linters, formatters, and security scans as part of the development flow
- **Real-time validation**: Validate APIs, test database connections, and check deployments instantly
- **Consistent standards**: Automated enforcement of coding standards and best practices

### 🧠 **Smarter Development Decisions**

- **Data-driven insights**: AI can analyze metrics from monitoring tools, databases, and APIs
- **Historical context**: Access to Git history, issue tracking, and project documentation
- **Cross-system correlation**: Connect information from multiple tools to provide better recommendations

## Business Impact

### 💰 **Cost Reduction**

- **Reduced context switching time**: Developers spend less time navigating between tools
- **Fewer manual errors**: Automated operations reduce human mistakes and rework
- **Faster onboarding**: New developers can be productive immediately with AI assistance

### 📈 **Improved Delivery Speed**

- **Accelerated development cycles**: Faster access to information and automated tasks
- **Reduced debugging time**: AI can quickly correlate issues across multiple systems
- **Streamlined workflows**: Integrated toolchain reduces friction in development process

### 🔒 **Better Security & Compliance**

- **Automated security checks**: Continuous scanning and validation through AI workflows
- **Audit trail**: All AI-assisted operations are logged and traceable
- **Consistent compliance**: Automated enforcement of security and regulatory requirements

## Recommended MCP Servers

### **Tier 1 - Essential for All Teams**

Start with these servers that provide universal utility across all projects:

- **`mcp-server-git`** - Enhanced Git operations beyond basic commands
- **`mcp-server-github`** - GitHub API integration for PRs, issues, releases
- **`mcp-server-filesystem`** - Enhanced file system operations
- **`mcp-server-fetch`** - HTTP requests and API testing
- **`mcp-server-eslint`** - JavaScript/TypeScript linting and code quality
- **`mcp-server-prettier`** - Code formatting across multiple languages

### **Tier 2 - Common Use Cases**

Add these based on your team's tech stack:

- **`mcp-server-docker`** - Container management and operations
- **`mcp-server-postgres`** - PostgreSQL database management
- **`mcp-server-aws`** - AWS service integration and management
- **`mcp-server-jira`** - Project management and issue tracking
- **`mcp-server-openapi`** - OpenAPI/Swagger documentation and validation
- **`mcp-server-jest`** - JavaScript testing framework integration

### **Tier 3 - Specialized Teams**

For teams with specific infrastructure or tooling needs:

- **`mcp-server-kubernetes`** - K8s cluster management
- **`mcp-server-terraform`** - Infrastructure as code operations
- **`mcp-server-vault`** - HashiCorp Vault secrets management
- **`mcp-server-datadog`** - Application monitoring and metrics
- **`mcp-server-selenium`** - Web automation and testing

## How to Install an MCP Server

### Step 1: Open Cursor Settings

1. Open Cursor IDE
2. Go to **Settings** (Cursor → Settings on macOS, or Ctrl+, on Windows/Linux)
3. Click on **MCP** in the left sidebar

### Step 2: Add a New MCP Server

1. Click **"+ Add a new global MCP server"**
2. A JSON configuration dialog will appear

### Step 3: Configure the Server

Copy and paste the server configuration. Here's an example for the GitHub MCP server:

```json
{
  "mcpServers": {
    "GitHub": {
      "command": "npx",
      "args": ["-y", "github-mcp-server", "--github-token=YOUR_GITHUB_TOKEN_HERE"]
    }
  }
}
```

### Step 4: Get Required Credentials

Most MCP servers need API keys or tokens:

- **GitHub**: Generate a Personal Access Token in GitHub Settings → Developer settings → Personal access tokens
- **AWS**: Use your AWS Access Key ID and Secret Access Key
- **Database servers**: Use your database connection credentials

### Step 5: Save and Restart

1. Click **Save** to apply the configuration
2. **Restart Cursor** to load the new MCP server
3. Your AI assistant now has access to the new capabilities!

## Important Configuration Notes

### MCP Configuration File Requirements

MCP servers require proper configuration file placement to function correctly. Understanding these requirements is crucial for successful setup:

#### File Location Requirements

- **Required location**: MCP configuration files **MUST** be placed at `.cursor/mcp.json` in your project root
- **Single file per project**: You cannot have multiple `mcp.json` files within a single project
- **No subdirectories**: The file cannot be placed in subdirectories (e.g., `.cursor/servers/mcp.json` will NOT work)
- **Personal vs. Project configuration**: You can have at most:
  - One project-specific MCP file at `<project-root>/.cursor/mcp.json`
  - One personal MCP file at `~/.cursor/mcp.json` (applies across all projects)

#### Common Configuration Mistakes

❌ **Incorrect**: These configurations will NOT be recognized by Cursor:

```
project-root/
├── .cursor/
│   └── servers/
│       └── mcp.json           # Wrong: In subdirectory
├── config/
│   └── mcp.json               # Wrong: Not in .cursor directory
└── devkit.mcp.json            # Wrong: Incorrect filename
```

✅ **Correct**: This is the only valid configuration structure:

```
project-root/
└── .cursor/
    └── mcp.json               # Correct: Direct child of .cursor
```

#### Why Configuration Location Matters

- Cursor scans for MCP configuration files at startup
- Only files named exactly `mcp.json` in the `.cursor` directory are loaded
- Misplaced configuration files will silently fail - no error messages will appear
- Changes to configuration files require a Cursor restart to take effect

## Devkit MCP Setup

The AI Development Kit includes a recommended MCP configuration to help teams get started quickly with pre-configured servers.

### Automatic Setup Behavior

When running the devkit setup process:

1. **If no existing configuration**:
   - The devkit will automatically copy its recommended `mcp.json` to `.cursor/mcp.json`
   - You'll have immediate access to all recommended MCP servers

2. **If configuration already exists**:
   - The devkit will NOT overwrite your existing configuration
   - You'll receive a notification to review the devkit's recommended servers
   - You can manually merge useful servers into your existing configuration

### Keeping Your Configuration Updated

As new MCP servers become available or existing ones are improved:

- The devkit's recommended configuration will be updated
- Run `git pull` on the devkit to get the latest recommendations
- Compare your current configuration with the updated recommendations
- Selectively add new servers that benefit your workflow

### Team Standardization

For consistent team development environments:

1. Start with the devkit's recommended configuration
2. Customize based on your team's specific needs
3. Commit the `.cursor/mcp.json` to your project repository
4. Document any required API keys or credentials in your team's secure credential management system

## Example: Setting Up GitHub MCP Server

1. **Get GitHub Token**:
   - Go to GitHub.com → Settings → Developer settings → Personal access tokens
   - Generate new token with `repo`, `issues`, and `pull_requests` permissions

2. **Add to Cursor**:

   ```json
   {
     "mcpServers": {
       "GitHub": {
         "command": "npx",
         "args": ["-y", "github-mcp-server", "--github-token=ghp_your_token_here"]
       }
     }
   }
   ```

3. **Test it**: Ask your AI assistant to "list my recent GitHub repositories" or "create a new issue in my project"

## Security Note

**Environment Variables**: Cursor currently doesn't support environment variables for MCP servers, so API keys need to be stored in the configuration. These are stored locally in your user directory and are not part of your project repository.

## Additional Resources

- **Official Cursor MCP Documentation**: [https://docs.cursor.com/mcp](https://docs.cursor.com/mcp)
- **MCP Server Registry**: Browse available servers and their configurations
- **Team Setup Guide**: Instructions for standardizing MCP servers across your development team

---

## Figma MCP Server Example

For teams using Figma, here's how to set up the Figma MCP server:

### Get Figma Access Token

1. Figma → Account Settings → Security → Personal Access Token
2. Generate new Token with read permissions on File content and Dev resources
3. Reference: https://help.figma.com/hc/en-us/articles/8085703771159-Manage-personal-access-tokens

### Add to Cursor Settings

```json
{
  "mcpServers": {
    "Figma": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--figma-api-key=YOUR_FIGMA_TOKEN_HERE", "--stdio"]
    }
  }
}
```
