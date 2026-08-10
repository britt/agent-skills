---
title: "Project Analysis"
description: "Analyze project codebase structure, architecture, key files, and dependencies"
---

Perform comprehensive analysis of a project codebase to understand its structure, architecture, key files, and dependencies. This skill scans the codebase, identifies the project type and architectural patterns, reads key configuration files, and produces a detailed analysis report.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install project-analysis@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Supported coding agents

| Agent | Supported |
|------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Starting work on an unfamiliar codebase
- Reviewing project architecture before making changes
- Generating documentation about project structure
- You want to understand the dependency landscape of a project

## Features

**Automatic project type detection**
Identifies the project type from indicators like package.json, Cargo.toml, go.mod, or Dockerfile, determining whether it is a web app, API, CLI tool, or containerized service.

**Architecture pattern recognition**
Detects architectural patterns including MVC, layered, feature-based, monorepo, and microservices by analyzing directory structure and file organization.

**Multiple depth levels**
Supports quick overview (file counts and language breakdown), standard analysis (key files and directories), and deep dive (entry points, core modules, and architecture diagram suggestions).

**Dependency landscape mapping**
Reads dependency files to catalog runtime and dev dependencies, identify the package manager, and assess overall complexity.
