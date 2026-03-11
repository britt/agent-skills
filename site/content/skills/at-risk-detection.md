---
title: "At-Risk Detection"
description: "Proactively identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items"
---

Proactively scan GitHub issues and pull requests to identify at-risk items before they become problems. This skill detects stale items, blocked work, deadline risks, scope creep, and unassigned high-priority issues, then provides actionable suggestions for each.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install britt/at-risk-detection
```

Or install all skills at once:

```bash
/plugin install britt/claude-code-skills
```

## Compatibility

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Claude.ai | ✓ |

## How to use it

Use this skill when:
- Starting a new sprint or running a weekly health check
- During standup to identify blockers
- Checking project health or status before milestone deadlines
- Triaging backlog items or doing pre-sprint cleanup

## Features

**Multi-signal risk detection**
Detects five risk types: stale items, blocked work, deadline risks, scope creep, and assignment issues using configurable heuristics and thresholds.

**Health score and summary reports**
Produces a project health summary with total open items, at-risk counts, health score percentage, and risk breakdown by severity.

**Actionable suggestions**
For each risk signal detected, provides specific recommendations such as commenting with status updates, resolving blocking dependencies, or redistributing overloaded assignees.

**Quick and comprehensive modes**
Quick mode scans the 30 most recent open issues for daily checks; comprehensive mode paginates through all open issues for thorough milestone reviews.
