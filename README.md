# Cursor Toolkit

Reusable Cursor rules, prompts, and workflows for AI-assisted development as used at Jung von Matt TECH.

> **Tip**: View this README with `⌘+Shift+V` (macOS) or `Ctrl+Shift+V` (Windows/Linux) in Cursor for better formatting.


## Quick Start

```bash
# Clone into your project or a central location
git clone https://github.com/jungvonmatt/cursor-toolkit.git
# Cherry-pick what you need manually or copy files
cp -r ${HOME}/cursor-toolkit/cursor ./.cursor
```

**What's included:**
- **Cursor Rules**: Development standards and AI guidance (`cursor/rules/general-use/`)
- **Prompts**: Story creation, commit messages, PR descriptions, TDD workflows (`cursor/prompts/general-use/`)
- **MCP Servers**: Optional tools for extended AI capabilities (`cursor/mcp.json`)
- **Workflows**: Agent documentation on using Git and story-based development (`/workflows/`)

**For customization:**
- Add your own rules to `cursor/rules/project-specific/`
- Add your own prompts to `cursor/prompts/project-specific/`

## Contributing

Contributions welcome! See [Contributing Guide](docs/CONTRIBUTING.md) for guidelines.
