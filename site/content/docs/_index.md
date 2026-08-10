---
title: "Documentation"
description: "Learn how to install and use Claude skills across supported coding agents"
---

## Getting Started

Skills are reusable instruction sets that extend supported coding agents for specific tasks. Choose the installation path that matches the tool in use.

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

### Cursor

Cursor adds the repository through its dashboard based marketplace flow and installs the same bundles from there.

1. Open **Dashboard → Plugins → Team Marketplaces → Add Marketplace → Import from Repo**
2. Point it at `britt/claude-code-skills`
3. Install `claude-code-skills` or `project-foundations` from **Customize**

### Shared `.agents/skills/` Path

Codex CLI, OpenCode, and Cursor can also read a shared `.agents/skills/` directory. Use this fallback when a marketplace flow is not available.

```bash
git clone https://github.com/britt/claude-code-skills.git ~/.agents-skills-src
mkdir -p ~/.agents/skills
for dir in ~/.agents-skills-src/skills/*/; do
  ln -s "$dir" ~/.agents/skills/"$(basename "$dir")"
done
```

### Claude.ai

Claude.ai uses project knowledge uploads.

1. Download the skill zip from the [Releases page](https://github.com/britt/claude-code-skills/releases/)
2. Open the target project in Claude.ai
3. Upload the zip file under **Project knowledge**

Browse the [Skills](../skills/) index for the full catalog.

## Creating Your Own Skills

See the [Contributing Guide](https://github.com/britt/claude-code-skills/blob/main/CONTRIBUTING.md) for details on creating new skills.

## Rules

The repository also includes reusable rule sets in the `rules/` directory. The most notable is **TDD.rules.md** which enforces strict Test-Driven Development practices.
