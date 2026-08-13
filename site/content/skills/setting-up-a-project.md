---
title: "Setting Up a Project"
description: "Author CLAUDE.md and AGENTS.md with project purpose, tech stack, and development practices"
---

Author the instruction files that define your project's purpose, tech stack, and development practices before any code is written — CLAUDE.md for Claude Code and a separately tuned AGENTS.md for Codex CLI, OpenCode, and Cursor. It surveys the repository first, then interviews you one question at a time to fill the gaps and establish development conventions before scaffolding code.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install setting-up-a-project@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Coding agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Setting up a new project
- No CLAUDE.md exists in the project
- Starting work on an empty codebase

## Features

**Repository survey before the interview**
Reads manifests, lockfiles, and CI workflows to detect your stack, then asks you to confirm instead of interrogating you about things the repo already answers. Merges into a thin existing CLAUDE.md rather than overwriting it.

**Guided interview for project definition**
Asks one question at a time to define the project's purpose and align on what you are building, rather than dumping questions all at once.

**Tech stack with sensible defaults**
Establishes the tech stack with sensible defaults so you have a clear starting point.

**A commands section that actually runs**
Records the exact install, test, coverage, build, lint, and run commands, then runs each one before committing so the documentation cannot drift from reality on day one.

**Development practices and git workflow**
Installs test-driven development rules as a project-root `TDD.rules.md` with your commands and coverage thresholds filled in, referenced from CLAUDE.md so it stays short. Copies commit rules verbatim, and settles branching, merge style, and issue references with you rather than dictating them.

**A CLAUDE.md and an AGENTS.md that are actually different**
Writes both, rather than symlinking one to the other. CLAUDE.md uses Claude Code's `@` imports and tool names; AGENTS.md replaces them with an explicit required-reading list and a condensed inline set of non-negotiables, because nothing auto-loads in Codex CLI, OpenCode, or Cursor.

**Agent harness configuration**
Offers a `.claude/settings.json` permission allowlist built from your project's own commands, and covers the other agents with an in-prose rule instead of inventing config for tools whose schemas move.

**Verification plan integration**
Creates a verification plan by invoking the Writing Verification Plans skill.
