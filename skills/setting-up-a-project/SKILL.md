---
name: setting-up-a-project
description: Use when setting up a new project for coding agents, when a repo has no CLAUDE.md or AGENTS.md, or when starting work on an empty codebase - surveys the repo, interviews the user, and authors CLAUDE.md plus an AGENTS.md tuned for Codex CLI, OpenCode, and Cursor, covering project purpose, tech stack, commands, TDD rules, and development practices
---

# Setting up a Project

## Overview

Author the instruction files that define a project's purpose, commands, and development practices before writing code: `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex CLI, OpenCode, and Cursor, plus the rule files both of them lean on.

**Core principle:** A well-configured project prevents rework and ensures consistency. Establishing guardrails upfront helps Claude Code work reliably, produce high-quality code, and avoid doom loops where code is written, broken, and rewritten repeatedly.

**When NOT to use:** an established repo that already has a mature CLAUDE.md - review and refine the existing file instead.

**Track each numbered step below as a todo** (`TodoWrite` in Claude Code, your plan or todo tool elsewhere).

**Commit after each section the user confirms** - one commit per section, throughout every step below.

## The Process

### 1. Survey the Repository

Read what the repo already says about itself before asking anything. Never ask a question the files answer.

```bash
ls -a                       # layout, and whether CLAUDE.md / AGENTS.md / .claude/ exist
cat README.md 2>/dev/null
```

Detect the stack from manifests and lockfiles:

| Evidence | What it tells you |
|----------|-------------------|
| `package.json` + `pnpm-lock.yaml` / `package-lock.json` / `yarn.lock` / `bun.lockb` | Language, package manager, scripts, test and lint tooling |
| `pyproject.toml` / `uv.lock` / `requirements.txt` | Python packaging and tool config |
| `go.mod` | Go module path and version |
| `Cargo.toml` | Rust crate and workspace layout |
| `Makefile` / `Taskfile.yml` / `justfile` | The commands people actually run |
| `.github/workflows/*.yml` | The commands CI actually runs - the most reliable source |
| `Dockerfile` / `fly.toml` / `wrangler.jsonc` / `serverless.yml` | Deployment target |

Then **confirm rather than interrogate**: "This looks like a TypeScript CLI on pnpm with Vitest and ESLint - right?" Ask only about what the repo cannot tell you.

Handle what you find:

- **Empty repo, no manifests** - nothing to survey. Go to step 2 and ask everything.
- **CLAUDE.md or AGENTS.md exists but is thin** - merge into it. Read it first, keep the user's existing wording, add only the missing sections. Never overwrite a file you have not read.
- **CLAUDE.md exists and is mature** - stop and offer to review and refine it instead of running this skill.
- **AGENTS.md is a symlink to CLAUDE.md** - replace it with a real file in step 7. A symlink cannot carry the adaptations the other agents need.

Also ask which agents will work in this repo (Claude Code, Codex CLI, OpenCode, Cursor). Step 7 writes `AGENTS.md` for the latter three; write it by default unless the user says Claude Code is the only agent that will ever touch the project.

### 2. Define the Project Purpose

Ask questions to determine:

1. **What should this project be called?** Get a name and brief description.
2. **What problem does this solve?** Understand the pain point, who experiences it, and why existing solutions are inadequate.
3. **How will it work?** Get a high-level explanation of the approach or mechanism.

Document the answers in CLAUDE.md under a `## Project Overview` section:

```markdown
## Project Overview

**Pantry Pal**: A CLI tool that suggests weeknight dinner recipes from ingredients already in the user's pantry.

### Problem

Home cooks waste food and time deciding what to make. Existing recipe apps assume a shopping trip rather than working with what is already on hand.

### Approach

A local ingredient inventory is matched against a recipe index. The tool ranks recipes by pantry coverage and prints the top matches along with a shopping list for any missing ingredients.
```

### 3. Define the Tech Stack

Ask about each area the survey did not already answer. Suggest defaults based on the language and runtime.

1. **Language and runtime** - What programming language? What version/runtime?
2. **Deployment target** - Where will this run? (CLI, web server, serverless, container, browser, etc.)
3. **Package manager** - How will dependencies be managed?
4. **Testing framework** - What will be used for TDD?
5. **Build tools** - How will the project be built/compiled?
6. **Linting and formatting** - What tools enforce code style?
7. **Key libraries** - Any specific libraries or frameworks required?
8. **Unique concerns** - Any other technical requirements? (database, auth, external APIs)

Defaults by language:

| Language | Package Manager | Testing | Linting | Build |
|----------|-----------------|---------|---------|-------|
| TypeScript/Node.js | pnpm | Vitest | ESLint + Prettier | esbuild or tsc |
| Python | uv | pytest | Ruff | - |
| Go | go modules | go test | golangci-lint | go build |
| Rust | cargo | cargo test | clippy | cargo build |

Adjust suggestions based on deployment target and project needs. Document the result under `## Tech Stack`:

```markdown
## Tech Stack

- **Language**: [Language and version]
- **Runtime**: [Runtime environment]
- **Package Manager**: [Package manager]
- **Testing**: [Testing framework]
- **Linting**: [Linter and formatter]
- **Build**: [Build tool]
- **Key Libraries**: [List of essential libraries]
```

### 4. Record the Commands

The Commands section is the most-used part of a CLAUDE.md - Claude reads it before every test run, build, and lint. Get exact, runnable strings, copied verbatim from `package.json` scripts, the Makefile, or the CI workflow when those exist.

```markdown
## Commands

| Task | Command |
|------|---------|
| Install | `pnpm install` |
| Test (once) | `pnpm test` |
| Test (watch) | `pnpm test --watch` |
| Coverage | `pnpm test --coverage` |
| Build | `pnpm build` |
| Lint | `pnpm lint` |
| Format | `pnpm format` |
| Typecheck | `pnpm typecheck` |
| Run locally | `pnpm dev` |
```

Omit rows that do not apply. These values fill the placeholders in `TDD.rules.md` (step 5) and the permission allowlist (step 7), so get them right here.

### 5. Establish Development Practices

#### TDD Rules (Mandatory)

TDD is non-negotiable for all projects set up with this skill.

1. Confirm the coverage thresholds with the user. Defaults: 90% lines, functions, and statements; 85% branches. Record whatever they choose.
2. Ask how test files are named and located in this stack (for example `src/example.ts` → `src/__tests__/example.test.ts`, or Go's `example_test.go` beside the source).
3. Copy the bundled `TDD.rules.md` (in this skill's directory) to the **project root** as `TDD.rules.md`. Do not paste it into CLAUDE.md - it is over 200 lines, and CLAUDE.md loads into every session.
4. Replace every `{{PLACEHOLDER}}` in the copy:

   | Placeholder | Value |
   |-------------|-------|
   | `{{TEST_COMMAND}}` | Test (once), from step 4 |
   | `{{TEST_WATCH_COMMAND}}` | Test (watch), from step 4 |
   | `{{COVERAGE_COMMAND}}` | Coverage, from step 4 |
   | `{{BUILD_COMMAND}}` | Build, from step 4 |
   | `{{LINT_COMMAND}}` | Lint, from step 4 |
   | `{{COVERAGE_THRESHOLD}}` | Lines/functions/statements threshold |
   | `{{BRANCH_COVERAGE_THRESHOLD}}` | Branch threshold |
   | `{{TEST_FILE_CONVENTION}}` | The naming and location rule, with two or three concrete examples |

5. Reference it from CLAUDE.md under `## Development Practices`:

```markdown
### Test-Driven Development

TDD is mandatory. **Read `TDD.rules.md` before writing any code.**

@TDD.rules.md
```

The `@` line is a Claude Code auto-import. The sentence above it is what makes the rules reachable in every other agent, which read the file as plain text - never rely on `@` alone.

If the bundled file is missing, fall back to fetching `https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/rules/TDD.rules.md`.

**Verify no placeholder survives:** `grep -n '{{' TDD.rules.md` must return nothing.

#### Commit Rules (CRITICAL)

**This rule is non-negotiable.** Read the bundled `git-commit-rules.md` file (in this skill's directory) and copy it verbatim into `CLAUDE.md`, and into `AGENTS.md` in step 7. It is short, and it is the single home for commit discipline - `TDD.rules.md` points here rather than restating it.

#### Git and Pull Request Workflow

Ask about each, and offer the default:

1. **Branching strategy** - Feature branches, trunk-based, or git worktrees?
2. **Branch naming** - Convention for naming branches (e.g., `feature/`, `fix/`, `chore/`)
3. **Worktrees** - If using worktrees, establish conventions for worktree location and naming
4. **Merge style** - Default: merge commits, never squash. Confirm before recording.
5. **Issue references** - Default: when working an issue, the PR description must note that the PR closes that issue number. Confirm before recording.

Document the answers under `## Development Practices`.

#### GitHub Actions Rules (if the project uses GitHub Actions)

If the project uses, or will use, GitHub Actions for CI/CD, apply this rule whenever authoring or editing workflow files:

**Never use an action pinned to the deprecated Node 20 runtime.** GitHub Actions is moving off Node 20 in favor of Node 24. When adding or updating a `uses:` step, always pick the action's latest major version rather than an older major still pinned to Node 20, and check the action's release notes/changelog if unsure whether it has moved to the Node 24 runtime.

Document this rule in CLAUDE.md under a `## CI/CD Practices` section (only if the project uses GitHub Actions):

```markdown
## CI/CD Practices

- Never use GitHub Actions pinned to the deprecated Node 20 runtime. Always use the latest major version of each action.
```

### 6. Document the Working Environment

Three short sections that save an agent from guessing:

```markdown
## Repository Layout

- `src/` - application code
- `src/__tests__/` - tests, mirroring `src/`
- `scripts/` - build and release tooling

## Environment

Copy `.env.example` to `.env` and fill in the values. Never commit `.env` or any
credential. Required variables: `DATABASE_URL`, `API_KEY`.

## Boundaries

Do not edit by hand:
- `dist/`, `*.generated.ts` - generated output; change the generator instead
- `pnpm-lock.yaml` - update via the package manager
```

Ask what is generated, vendored, or otherwise off-limits, and what secrets the project needs. Omit any section that has no content - an empty heading is worse than none.

### 7. Write the Files Each Agent Reads

#### AGENTS.md (Codex CLI, OpenCode, Cursor)

Claude Code reads `CLAUDE.md`. Codex CLI, OpenCode, and Cursor read `AGENTS.md`. Write both.

**Do not symlink them together.** They describe the same project but they are not the same document: `CLAUDE.md` leans on auto-imports and Claude Code's tool names, and neither survives the trip to another agent.

How `AGENTS.md` differs:

| Concern | CLAUDE.md | AGENTS.md |
|---------|-----------|-----------|
| Deep rule sets | `@TDD.rules.md` auto-import | A **Required Reading** list instructing the agent to open the files itself - nothing auto-loads |
| Non-negotiables | Carried by the imported rule files | Condensed inline at the top, so the critical rules are present even if the agent never opens another file |
| Todo tracking | `TodoWrite` by name | "your plan or todo tool" |
| Permissions | Points at `.claude/settings.json` | An inline rule: run the Commands table freely, ask before anything else |
| Shape | Terse; imports carry the weight | Flatter and self-contained |

Template:

```markdown
# <Project Name> - Agent Instructions

Read this file before making any change. It applies to every agent working in this repo.

## Required Reading

These files are not loaded automatically. Open them yourself before writing code:

- `TDD.rules.md` - test-driven development rules. Mandatory, no exceptions.
- `VERIFICATION_PLAN.md` - how to prove a change actually works.

## Non-Negotiables

1. No production code without a failing test first. Full rules in `TDD.rules.md`.
2. Commit after every RED-GREEN-REFACTOR cycle. Never leave 30 minutes of work uncommitted.
3. A task is not done until tests pass, the build succeeds, and the linter is clean.
4. Run the commands in the Commands table freely. Ask first before anything that
   installs software, writes outside the repo, or reaches the network.
5. Track multi-step work in your plan or todo tool as you go.

## Project Overview
## Tech Stack
## Commands
## Repository Layout
## Environment
## Development Practices
## CI/CD Practices
## Boundaries

## Maintaining This File

`CLAUDE.md` and `AGENTS.md` describe the same project. When a project fact changes -
a command, the stack, the layout, a boundary - update both in the same commit.
```

The sections from `## Project Overview` down carry the same content as `CLAUDE.md`, written out in full rather than referenced. Write `## Development Practices` inline here: the git and PR workflow from step 5, plus the commit rules, with no `@` references anywhere in the file.

If a tool does not pick `AGENTS.md` up, check that tool's current documentation for its instruction-file path rather than guessing at one.

#### .claude/settings.json (Claude Code, optional)

Offer to create `.claude/settings.json` with an allowlist for the commands from step 4, so routine work does not trigger a prompt on every run. Offer, do not impose - ask before writing.

```json
{
  "permissions": {
    "allow": [
      "Bash(pnpm test:*)",
      "Bash(pnpm lint:*)",
      "Bash(pnpm build:*)"
    ]
  }
}
```

Only list read-only or build/test commands. Never allowlist anything destructive or anything that publishes.

This file is Claude Code-specific. The other three agents configure permissions their own way and their schemas move - do not invent a `codex`, `opencode`, or `cursor` config file. `AGENTS.md` rule 4 above covers them in prose instead.

### 8. Write the Verification Plan

Use the `writing-verification-plans` skill to create a verification plan. If it is unavailable, write `VERIFICATION_PLAN.md` covering the acceptance scenarios that prove the project works against real systems, with success criteria and a pass/fail log.

Link it from CLAUDE.md:

```markdown
## Verification

Acceptance testing procedures: read `VERIFICATION_PLAN.md`.

@VERIFICATION_PLAN.md
```

In `AGENTS.md` it is already covered by the Required Reading list - no `@` line there.

### 9. Verify, Then Finish

Documentation that does not run is worse than none. Before the final commit:

1. **Run every command in the Commands section.** Fix any that fail or do not exist.
2. **Check for unfilled placeholders:** `grep -n '{{' CLAUDE.md AGENTS.md TDD.rules.md` must return nothing.
3. **Check `AGENTS.md` carries no Claude Code-isms:** `grep -n '@\|TodoWrite\|\.claude/' AGENTS.md` should return nothing but ordinary prose. An `@TDD.rules.md` line that leaked in is dead text in Codex CLI, OpenCode, and Cursor.
4. **Check the two files agree** on commands, stack, layout, and boundaries. They are separate documents, so nothing enforces this but you.
5. **Confirm `AGENTS.md` is a real file, not a symlink:** `test -L AGENTS.md && echo "symlink - replace it"`.
6. **Re-read both files end to end** for contradictions between sections.
7. Use the `elements-of-style:writing-clearly-and-concisely` skill if available.
8. Commit.
9. Ask if the user would like to start brainstorming requirements or an implementation plan. Use the `superpowers:brainstorming` skill (if available) or the `superpowers:writing-plans` skill (if available) if they say yes.

## The Finished Files

Sections in this order. Omit any that do not apply.

```markdown
CLAUDE.md                 (Claude Code)
# <Project Name>

## Project Overview       (problem, approach)
## Tech Stack
## Commands
## Repository Layout
## Environment
## Development Practices  (TDD → read + @TDD.rules.md, commit rules, git/PR workflow)
## CI/CD Practices        (only if GitHub Actions)
## Boundaries
## Verification           (read + @VERIFICATION_PLAN.md)
```

```markdown
AGENTS.md                 (Codex CLI, OpenCode, Cursor)
# <Project Name> - Agent Instructions

## Required Reading       (TDD.rules.md, VERIFICATION_PLAN.md - no @ imports)
## Non-Negotiables        (condensed inline; nothing auto-loads here)
## Project Overview       ┐
## Tech Stack             │
## Commands               │ same content as CLAUDE.md,
## Repository Layout      │ written out in full
## Environment            │
## Development Practices  │ (inline, not referenced)
## CI/CD Practices        │
## Boundaries             ┘
## Maintaining This File  (change one, change both, same commit)
```

Alongside them: `TDD.rules.md`, `VERIFICATION_PLAN.md`, and optionally `.claude/settings.json`.

## Key Principles

- **Survey before asking** - the repo answers most tech stack questions itself
- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **DRY ruthlessly** - Long rule sets live in their own file and get referenced, not pasted
- **Assume nothing auto-loads** - outside Claude Code, a file is read only if the instructions say to read it
- **Incremental validation** - Present each file in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense

## Common Mistakes

- Interviewing the user about a stack the lockfile and CI workflow already describe
- Overwriting an existing CLAUDE.md or AGENTS.md instead of merging into it
- Symlinking `AGENTS.md` to `CLAUDE.md` - it ships Claude Code's `@` imports and tool names to agents that understand neither
- Leaving an `@` reference in `AGENTS.md`, where it is dead text
- Writing `AGENT.md` instead of `AGENTS.md` - no agent reads the singular
- Letting the two files drift after a command or boundary changes
- Leaving `{{TEST_COMMAND}}` and friends unreplaced in the project's `TDD.rules.md`
- Pasting the full TDD rules into either file instead of pointing at `TDD.rules.md`
- Documenting commands without running them once to confirm they work
- Writing a whole file at once instead of validating section by section with the user
- Asking many questions in a single message and overwhelming the user
- Paraphrasing the TDD rules or commit rules instead of copying them verbatim
