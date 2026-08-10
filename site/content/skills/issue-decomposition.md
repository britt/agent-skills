---
title: "Issue Decomposition"
description: "Decompose project descriptions into well-structured GitHub issues with user stories, acceptance criteria, and estimates"
---

Transform high-level project descriptions into well-structured GitHub issues. Each issue includes a user story, acceptance criteria, dependencies, labels, and effort estimates. The skill follows the INVEST principles to ensure issues are independent, negotiable, valuable, estimable, small, and testable.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install issue-decomposition@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
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
- You have a feature or project to break down into tasks
- You need to create structured GitHub issues from a description
- During project planning to generate actionable work items
- Converting requirements into well-formed issues

## Features

**Complete issue templates**
Each generated issue includes a user story, description, acceptance criteria with checkboxes, dependency mapping, labels, and T-shirt size estimates.

**Structured decomposition process**
Walks through understanding scope, identifying major components, generating issues, mapping dependencies, and previewing before creation.

**Label taxonomy and estimation guidelines**
Uses a consistent label system for type, area, and priority, with T-shirt sizing mapped to typical durations from half a day to a full week.

**Preview before creating**
Always shows a summary table of proposed issues with titles, estimates, and dependencies before creating anything in GitHub.

**Worked example included**
Includes a sample decomposition of "Build a user authentication system" into 7 dependency-linked issues, showing exactly what the output looks like.
