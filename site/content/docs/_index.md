---
title: "Documentation"
description: "Learn how to install and use Claude skills across supported coding agents"
---

## Getting Started

Claude skills are reusable instruction sets that enhance Claude's capabilities for specific tasks. They work in both Claude Code and Claude.ai (with some limitations).

## Installation Methods

### Claude Code Plugin Marketplace

The easiest way to install skills in Claude Code:

```bash
/plugin marketplace add britt/claude-code-skills
```

Once the marketplace is added, install everything, a curated bundle, or a single skill:

```bash
# Install all skills
/plugin install claude-code-skills@britt

# Install a curated bundle (e.g. project-foundations)
/plugin install project-foundations@britt

# Install a single skill
/plugin install setting-up-a-project@britt
```

See the [Skills](../skills/) page for the full list of individual skills and bundles.

### Global Installation

Install skills globally so they're available in all projects:

```bash
git clone https://github.com/britt/claude-code-skills.git ~/.claude/skills/claude-code-skills
```

### Project-Specific Installation

Install skills for a specific project:

```bash
# Clone the entire repository into the project
git clone https://github.com/britt/claude-code-skills.git .claude/skills/claude-code-skills
```

### Claude.ai

1. Download the skill zip from the [Releases page](https://github.com/britt/claude-code-skills/releases/)
2. Go to your Claude.ai project
3. Click **Project knowledge** and upload the zip file

## Creating Your Own Skills

See the [Contributing Guide](https://github.com/britt/claude-code-skills/blob/main/CONTRIBUTING.md) for details on creating new skills.

## Rules

The repository also includes reusable rule sets in the `rules/` directory. The most notable is **TDD.rules.md** which enforces strict Test-Driven Development practices.
