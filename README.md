# AI DevKit

> [!WARNING]
> Forked from Fielmann, only here for inspiration, not to be used directly

A comprehensive toolkit for AI-assisted development workflows, including story management, Git operations, and cross-repository development patterns.

💪 Read this README in full to get the most out of the AI DevKit.

> 💡 **Tip**: Open the README in Cursor, then press `⌘+Shift+V` (macOS) or `Ctrl+Shift+V` (Windows/Linux) to view a nice preview of this README.

## 📖 Table of Contents

- [🎯 Overview](#-overview)
- [🚀 Quick Start](#-quick-start)
- [📚 Available Workflows](#-available-workflows)
  - [AI Development Workflows](#ai-development-workflows)
- [🔧 Repository Structure](#-repository-structure)
  - [Integration in Your Project](#integration-in-your-project)
- [🔄 Working with the Submodule](#-working-with-the-submodule)
  - [Team Setup](#team-setup)
- [⚙️ Setup Script Details](#️-setup-script-details)
  - [What the Setup Script Does](#what-the-setup-script-does)
  - [Troubleshooting](#troubleshooting)
- [🤝 Contributing](#-contributing)

## 🎯 Overview

This repository contains reusable development patterns and Cursor rules designed to streamline AI-assisted development across multiple projects and repositories. It's designed to be integrated as a Git Submodule for easy cross-project usage.

## 🚀 Quick Start

### Step 1: Add AI DevKit as a Git Submodule

```bash
# Navigate to your project root
cd [your-project]

# Add ai-devkit as submodule
git submodule add https://github.com/jungvonmatt/ai-devkit.git .ai-devkit

# Initialize and update the submodule
git submodule update --init --recursive
```

### Step 2: Run the DevKit Setup Script

```bash
# Navigate into the AI DevKit directory
cd .ai-devkit

# Make the setup script executable (macOS/Linux)
chmod +x ai-devkit-setup.sh

# Run the setup script
./ai-devkit-setup.sh
```

This will copy all AI the devkit's prompts, rules and workflows to your parent project's `.cursor` directory ⚡️

---

## ⚙️ Troubleshooting The Setup Script

**For Windows users:**

- Use Git Bash, PowerShell, or WSL (Windows Subsystem for Linux)
- If using Command Prompt, you may need to use `bash ai-devkit-setup.sh` instead

**If you get "Permission denied" error:**

```bash
# Make sure the script is executable
chmod +x ai-devkit-setup.sh
```

**If you get "must be run from within the .ai-devkit directory":**

```bash
# Make sure you're in the right directory
cd .ai-devkit
pwd  # Should show: /path/to/your/project/.ai-devkit
```

**If you get "Source directory not found":**

```bash
# Update your submodule to get the latest files
cd ..  # Go back to project root
git submodule update --remote .ai-devkit
cd .ai-devkit
```

---

## How To Keep The AI DevKit Updated

_Do this step regularly (e.g. every 30 days) as the devkit is frequently updated with new prompts, rules and workflows._

```bash
# Navigate to AI DevKit directory
cd .ai-devkit

# Run the update script
./ai-devkit-update.sh
```

This script pulls the latest devkit updates and propagates any new Cursor rules, powerful prompts and workflows to your project 💪 And don't worry, any prompts or rules that you have written yourself will remain untouched :)

---

## Integration in Your Project

After running the `ai-devkit-setup.sh` script, you'll find the following structure:

```
your-project/
│
├── .ai-devkit/                # Git submodule
│   ├── workflows/             # AI workflows
│   │   ├── working-with-stories.md    # Story lifecycle workflows
│   │   └── working-with-git.md        # Git operations and PR workflows
│   ├── cursor
│   │   └── cursor-rules/         # Copied to .cursor/rules/general-use/
│   │   ├── cursor-custom-modes/  # Custom Cursor modes
│   │   ├── cursor-mcp/           # MCP servers
│   └── prompts/                  # Copied to .cursor/prompts/general-use/
│
├── .cursor/                   # Cursor IDE configuration (created by setup script)
│   ├── rules/
│   │   ├── general-use/       # 📋 Copied Cursor rules from AI DevKit
│   │   └── project-specific/  # 🎯 Put your project-specific Cursor rules here
│   └── prompts/
│       ├── general-use/       # 📝 Copied prompts from AI DevKit
│       └── project-specific/  # 🎯 Put your project-specific prompts here
│
└── [your project files]
```

**After running the setup script, you'll find:**

- **Cursor Rules**: Available in `.cursor/rules/general-use/` - These provide AI assistant guidance and development standards
- **Prompts**: Available in `.cursor/prompts/general-use/` - These include specialized prompts for story creation, commit messages, PR descriptions, and TDD workflows

**For your own customizations:**

- **Project-Specific Cursor Rules**: Create files in `.cursor/rules/project-specific/` - Add your own Cursor rules tailored to your project's specific needs
- **Project-Specific Prompts**: Create files in `.cursor/prompts/project-specific/` - Add your own custom prompts for project-specific workflows
- The `project-specific` directories won't be affected by the devkit scripts, and we encourage you to use them to store your own team's prompts and rules.

## 📚 Available Workflows

### AI Development Workflows

Located in `ai-devkit/workflows/` - Comprehensive AI assistant guidance for development workflows.

- **[Story Workflows](workflows/working-with-stories.md)** - Complete 3-step story lifecycle from business requirements to implementation
- **[Git Operations](workflows/working-with-git.md)** - Git workflows, GitHub CLI commands, and PR templates

## 🤝 Contributing

We welcome contributions that enhance ease of use, reduce manual work, and improve the developer experience. Please see our detailed [Contributing Guide](docs/CONTRIBUTING.md) for guidelines, requirements, and the submission process.
