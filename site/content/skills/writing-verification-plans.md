---
title: "Writing Verification Plans"
description: "Create real-world acceptance testing procedures"
---

Create verification plans for real-world acceptance testing. Verification uses actual systems, never mocks.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install writing-verification-plans@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- A project lacks a VERIFICATION_PLAN.md
- Finishing up after setting up a new project
- You're asked how to prove a feature works end-to-end

## Features

**Concrete scenarios and success criteria**
Defines scenarios with concrete success criteria for real-world verification.

**Step-by-step execution instructions**
Provides instructions for Claude to execute and validate each scenario.

**Automatic post-task verification**
Runs verification automatically after completing tasks when configured to do so.

**Detailed verification logs**
Produces detailed verification logs documenting what was tested and what passed or failed.
