---
title: "Documentation"
description: "Learn how to install and use Claude skills across supported coding agents"
---

## Getting Started

Claude skills are reusable instruction sets that extend supported coding agents for specific tasks. Choose the installation path that matches the tool in use, then browse the [Skills](../skills/) page for the catalog of bundles and individual skills.

## Installation Methods

### Claude Code

Claude Code installs skills through the plugin marketplace and also supports manual cloning into the standard Claude Code skill folders.

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install claude-code-skills@britt
/plugin install project-foundations@britt
git clone https://github.com/britt/claude-code-skills.git ~/.claude/skills/claude-code-skills
git clone https://github.com/britt/claude-code-skills.git .claude/skills/claude-code-skills
```

### Codex CLI

Codex CLI installs the repository through its plugin marketplace.

```bash
codex plugin marketplace add britt/claude-code-skills
codex plugin install claude-code-skills@britt
codex plugin install project-foundations@britt
```

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
