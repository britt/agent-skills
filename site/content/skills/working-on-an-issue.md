---
title: "Working on an Issue"
description: "Implement GitHub issues with verification"
---

Implement a GitHub issue with a repeatable, verification-driven approach.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install working-on-an-issue@britt
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

- Asked to work on a GitHub issue
- Asked to implement an issue
- Given an issue URL or issue number

To start, provide the issue URL or number.

Before proceeding, confirm the pre-flight checklist:

- Issue URL or number obtained
- Repository cloned and on the correct branch
- `CLAUDE.md` exists (or run `setting-up-a-project` first)
- A developer is available for questions (or an async mode is explicitly agreed)

## Features

**A plan-first approach with explicit approval**
Writes an implementation plan and saves it to `docs/plans/issue-<number>-plan.md`, then waits for approval before making changes.

**Verification is part of the process (twice)**
Creates a verification plan up front (via `writing-verification-plans`), then executes the verification plan again after implementation.

**Rules that reduce scope creep**
Requires clarification when requirements, acceptance criteria, or boundaries are ambiguous, and avoids inventing requirements that are not in the issue.

**Clear stop conditions**
When blocked, stops and asks the developer instead of guessing.
