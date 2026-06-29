---
title: "Setting Up a Project"
description: "Author CLAUDE.md with project purpose, tech stack, and development practices"
---

Author a CLAUDE.md file that defines your project's purpose, tech stack, and development practices before any code is written. It uses brainstorming to clarify goals, choose a tech stack, and establish development conventions before scaffolding code.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install setting-up-a-project@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Compatibility

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Claude.ai | |

## How to use it

Use this skill when:
- Setting up a new project
- No CLAUDE.md exists in the project
- Starting work on an empty codebase

## Features

**Brainstorming-driven project definition**
Uses a brainstorming workflow to define the project's purpose and align on what you are building.

**Tech stack with sensible defaults**
Establishes the tech stack with sensible defaults so you have a clear starting point.

**Development practices and git workflow**
Copies test-driven development rules and git practices (including "commit early, commit often") into CLAUDE.md.

**Verification plan integration**
Creates a verification plan by invoking the Writing Verification Plans skill.
