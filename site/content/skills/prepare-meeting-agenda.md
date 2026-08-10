---
title: "Prepare Meeting Agenda"
description: "Generate meeting agendas from recent issues, PRs, and notes for sprint planning, retros, and standups"
---

Generate structured meeting agendas by gathering context from recent project activity including issues, PRs, and notes. This skill supports sprint planning, retrospectives, standups, project check-ins, and any recurring team meeting with time-boxed topics and assigned owners.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install prepare-meeting-agenda@britt
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
- Preparing for sprint planning sessions
- Setting up retrospectives or standups
- Organizing project check-ins or recurring team meetings
- You need a focused agenda built from recent project activity

## Features

**Meeting-type-aware formatting**
Adapts the agenda structure based on meeting type: sprint planning focuses on upcoming work and capacity, retros on wins and improvements, standups on progress and blockers.

**Context-driven topic gathering**
Pulls relevant topics from recent issues, PRs, and notes to ensure the agenda reflects actual project activity rather than guesswork.

**Time allocation and ownership**
Each topic gets an assigned owner and time estimate, with buffer time built in, keeping meetings focused and within schedule.

**Carryover tracking**
Includes incomplete action items from previous meetings so nothing falls through the cracks.
