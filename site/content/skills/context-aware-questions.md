---
title: "Context-Aware Questions"
description: "Identify information gaps in project context and generate actionable questions to surface missing requirements"
---

Analyze project context to surface information gaps and generate prioritized, actionable questions. This skill proactively identifies missing requirements, unclear specifications, and documentation gaps across issues, PRs, and project files, then produces categorized questions with suggested actions.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install context-aware-questions@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Supported coding agents

| Agent | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- You want to know "what am I missing?" or "what questions should I be asking?"
- Reviewing issues or drafts before starting work or submitting
- Analyzing documentation completeness
- During project planning or kickoff to surface unknowns

## Features

**Multiple analysis modes**
Supports project-wide reviews, individual issue reviews, draft reviews before submission, and documentation gap analysis. Issue-based modes fetch data via the `gh` CLI, which must be installed and authenticated.

**Gap detection heuristics**
Automatically detects missing acceptance criteria, vague descriptions, missing labels or assignees, stale issues, bug reports without reproduction steps, and incomplete documentation.

**Prioritized and categorized output**
Questions are organized by category (requirements, technical, documentation, process, consistency, architecture) and priority (high, medium, low) with specific suggested actions.

**Actionable suggestions**
Every identified gap comes with a concrete recommendation, such as adding checkboxes with acceptance criteria or creating missing API documentation.
