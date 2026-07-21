---
name: setting-up-a-project
description: Use when setting up a new Claude Code project, when a repo has no CLAUDE.md, or when starting work on an empty codebase - interviews the user and authors a CLAUDE.md covering project purpose, tech stack, TDD rules, and development practices
---

# Setting up a Project

## Overview

Help Claude author a CLAUDE.md file that defines a project's purpose, development practices, and tech stack before writing code.

**Core principle:** A well-configured project prevents rework and ensures consistency. Establishing guardrails upfront helps Claude Code work reliably, produce high-quality code, and avoid doom loops where code is written, broken, and rewritten repeatedly.

**When NOT to use:** an established repo that already has a mature CLAUDE.md - review and refine the existing file instead.

## The Process

### Define the Project Purpose

Ask questions to determine:

1. **What should this project be called?** Get a name and brief description.
2. **What problem does this solve?** Understand the pain point, who experiences it, and why existing solutions are inadequate.
3. **How will it work?** Get a high-level explanation of the approach or mechanism.

Then update CLAUDE.md. Document the answers in CLAUDE.md under a `## Project Overview` section.
Here's a template:

```markdown
## Project Overview

**Pantry Pal**: A CLI tool that suggests weeknight dinner recipes from ingredients already in the user's pantry.

### Problem

Home cooks waste food and time deciding what to make. Existing recipe apps assume a shopping trip rather than working with what is already on hand.

### Approach

A local ingredient inventory is matched against a recipe index. The tool ranks recipes by pantry coverage and prints the top matches along with a shopping list for any missing ingredients.
```

## Define the Tech Stack

Ask the user about each of these areas. Suggest sensible defaults based on the language/runtime.

### Questions to Ask

1. **Language and runtime** - What programming language? What version/runtime?
2. **Deployment target** - Where will this run? (CLI, web server, serverless, container, browser, etc.)
3. **Package manager** - How will dependencies be managed?
4. **Testing framework** - What will be used for TDD?
5. **Build tools** - How will the project be built/compiled?
6. **Linting and formatting** - What tools enforce code style?
7. **Key libraries** - Any specific libraries or frameworks required?
8. **Unique concerns** - Any other technical requirements specific to this project? (e.g., database, auth, external APIs)

### Suggested Defaults

When suggesting defaults, base them on the language:

| Language | Package Manager | Testing | Linting | Build |
|----------|-----------------|---------|---------|-------|
| TypeScript/Node.js | pnpm | Vitest | ESLint + Prettier | esbuild or tsc |
| Python | uv | pytest | Ruff | - |
| Go | go modules | go test | golangci-lint | go build |
| Rust | cargo | cargo test | clippy | cargo build |

Adjust suggestions based on deployment target and project needs.

Document the output in CLAUDE.md under a `## Tech Stack` section.
Here's a template:

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

After defining the tech stack:
- confirm with the user
- write the choices to `CLAUDE.md`
- commit the file to git

## Establish Development Practices

### TDD Rules (Mandatory)

TDD is non-negotiable for all projects set up with this skill.
Read the bundled `TDD.rules.md` file (in this skill's directory) and copy it verbatim into `CLAUDE.md`.
If the bundled file is missing, fall back to fetching `https://raw.githubusercontent.com/britt/claude-code-skills/refs/heads/main/rules/TDD.rules.md`.

### Git Practices

Ask the user about their preferred git workflow, then document it in CLAUDE.md:

1. **Branching strategy** - Feature branches, trunk-based, or git worktrees?
2. **Branch naming** - Convention for naming branches (e.g., `feature/`, `fix/`, `chore/`)
3. **Worktrees** - If using worktrees, establish conventions for worktree location and naming

### Commit Early, Commit Often (CRITICAL)

**This rule is non-negotiable.** Read the bundled `git-commit-rules.md` file (in this skill's directory) and copy it verbatim into `CLAUDE.md`.

### GitHub Actions Rules (if the project uses GitHub Actions)

If the project uses, or will use, GitHub Actions for CI/CD, apply this rule whenever authoring or editing workflow files:

**Never use an action pinned to the deprecated Node 20 runtime.** GitHub Actions is moving off Node 20 in favor of Node 24. When adding or updating a `uses:` step, always pick the action's latest major version rather than an older major still pinned to Node 20, and check the action's release notes/changelog if unsure whether it has moved to the Node 24 runtime.

Document this rule in CLAUDE.md under a `## CI/CD Practices` section (only if the project uses GitHub Actions):

```markdown
## CI/CD Practices

- Never use GitHub Actions pinned to the deprecated Node 20 runtime. Always use the latest major version of each action.
```

### Pull Request Rules
YOU MUST follow these rules when creating a pull request. 

- Use a merge commit do not squash commits. 
- If you are working on an issue make sure to note in the PR description that this PR closes the issue number.


### Verification Plan

Use the `writing-verification-plans` skill (if available) to create a verification plan. 
This produces a VERIFICATION_PLAN.md file that should be linked in CLAUDE.md as shown below:

```markdown
## Verification

See @VERIFICATION_PLAN.md for acceptance testing procedures.
```

## After Setting Up

* Write the `CLAUDE.md` file
* Use elements-of-style:writing-clearly-and-concisely skill if available
* Commit the `CLAUDE.md` to git
* Ask if the user would like to start brainstorming requirements or an implementation plan. Use the `superpowers:brainstorming` skill (if available) or the `superpowers:writing-plans` skill (if available) if they say yes.

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **DRY ruthlessly** - Remove any repetition of instructions
- **Incremental validation** - Present `CLAUDE.md` in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense

## Common Mistakes

- Writing the whole CLAUDE.md at once instead of validating section by section with the user
- Asking many questions in a single message and overwhelming the user
- Paraphrasing the TDD rules or commit rules instead of copying them verbatim
- Skipping the git commit after a section is confirmed
