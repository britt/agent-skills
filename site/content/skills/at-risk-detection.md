---
title: "At-Risk Detection"
description: "Proactively identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items"
---

Proactively scan GitHub issues and pull requests to identify at-risk items before they become problems. This skill detects stale items, blocked work, deadline risks, scope creep, and unassigned high-priority issues, then provides actionable suggestions for each.

### Installation

Add the marketplace and install this skill:

```bash
 /plugin marketplace add britt/agent-skills
/plugin install at-risk-detection@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Supported coding agents

| Agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

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
Quick mode scans the 30 most recent open issues for daily checks; comprehensive mode paginates through all open issues for thorough milestone reviews. Because quick mode sorts by recency, it can miss the stalest items — the report calls this out, and comprehensive mode should be used to find them.

**Common-mistake guardrails**
Avoids known false positives: draft PRs aren't flagged as stale-awaiting-review, and issues intentionally parked with an `on-hold` label are reported separately from genuinely forgotten stale work.
