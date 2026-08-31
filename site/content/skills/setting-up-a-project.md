---
title: "Setting Up a Project"
description: "Set up coding-agent instructions with project purpose, tech stack, runnable commands, development practices, separate CLAUDE.md and AGENTS.md files, and root rule files"
---

Set up the project context that coding agents need before any code is written: its purpose, tech stack, runnable commands, development practices, environment, layout, and boundaries. The skill surveys the repository, interviews one question at a time to fill the gaps, and writes separate `CLAUDE.md` and `AGENTS.md` files plus root `TDD.rules.md` and `CLAUDE-specific-fuckups.md` files for the agents to use.

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
- The project has no `CLAUDE.md` or `AGENTS.md`
- Starting work on an empty codebase
- An existing instruction file is thin and needs additional project context

When an established project already has a mature `CLAUDE.md`, review and refine that file instead of rerunning setup.

## Features

**Repository survey before the interview**
Reads manifests, lockfiles, and CI workflows to identify the stack and existing commands before asking questions. Confirms what the repository already shows, merges into thin instruction files, and preserves existing wording instead of overwriting unread files.

**Guided interview for project definition**
Asks one question at a time to define the project's purpose, problem, approach, environment, boundaries, and development conventions. Multiple choice questions keep the interview focused when possible.

**Tech stack and project context**
Confirms the language, runtime, deployment target, package manager, testing, build, linting, formatting, libraries, and other technical concerns that the survey cannot establish. Records the repository layout, environment requirements, generated or vendored content, and editing boundaries when they apply.

**A commands section that actually runs**
Records exact install, test, coverage, build, lint, format, typecheck, and local run commands when they apply. Runs every command in the `Commands` section before the final commit and fixes commands that fail or do not exist.

**Project-root TDD rules**
Copies `TDD.rules.md` to the project root, fills every placeholder with the interview results, and records the selected coverage thresholds and test-file convention. `CLAUDE.md` references the file instead of duplicating its rules, and the setup checks that no placeholder remains.

**Development practices and git workflow**
Copies `git-commit-rules.md` verbatim into both instruction files. Records branching, branch naming, worktree, merge, and issue-reference conventions through the interview rather than imposing project-specific choices.

**A CLAUDE.md and an AGENTS.md that are actually different**
Writes a real, separate `AGENTS.md` for Codex CLI, OpenCode, and Cursor instead of symlinking it to `CLAUDE.md`. `CLAUDE.md` uses Claude Code `@` imports and tool names; `AGENTS.md` uses an explicit required-reading list and condensed inline rules because those agents do not auto-load the referenced files. `AGENTS.md` contains no `@` imports and does not reference `CLAUDE-specific-fuckups.md`.

**Claude-specific failure patterns**
Copies `CLAUDE-specific-fuckups.md` verbatim to the project root and references it from `CLAUDE.md` under Development Practices with `@CLAUDE-specific-fuckups.md`. The file tells Claude Code to check current GitHub Actions releases and supported runtimes instead of relying on recalled versions; it never appears in `AGENTS.md`. If the bundled file is unavailable, the setup fetches it from the raw GitHub source.

**Optional Claude Code permissions**
Optionally offers `.claude/settings.json` with an allowlist for the project's read-only and build or test commands. The other agents use an inline rule in `AGENTS.md` instead of invented configuration files.

**Verification plan integration**
Creates `VERIFICATION_PLAN.md` by invoking the Writing Verification Plans skill, or writes the plan when that skill is unavailable. Links the plan from `CLAUDE.md` with an `@` import and lists it as required reading in `AGENTS.md`.
