---
title: "Triage New Issues"
description: "Review new GitHub issues, assess priority and urgency, suggest labels, and recommend assignees"
---

Review new or untriaged GitHub issues, assess priority based on urgency signals, suggest labels, and recommend owners. This skill scans issue titles, descriptions, and labels for priority keywords to classify issues from P0 (critical) to P3 (low), then provides a structured triage report with recommendations.

### Installation

Add the marketplace and install this skill:

```bash
 /plugin marketplace add britt/agent-skills
/plugin install triage-new-issues@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```


## Supported coding agents

| Agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Processing new incoming issues
- Reviewing an untriaged backlog
- Assessing issue priority and urgency
- Assigning issues to the right owners

## Features

**Keyword-based priority detection**
Scans for urgency signals like "outage," "security," "blocking," "regression," "crash," and "workaround exists" to determine priority from P0 critical to P3 low.

**Structured triage output**
Produces a report per issue with urgency, impact, recommended priority, classification (type and area), suggested labels, suggested assignee, and an assessment summary.

**Escalation and red flag detection**
Flags security vulnerabilities, production outages, and data integrity issues for immediate escalation, and identifies red flags like stale issues with no author response.

**Clarifying question generation**
When issues lack reproduction steps, environment details, or clear severity, generates specific questions to gather the missing information before final triage.
