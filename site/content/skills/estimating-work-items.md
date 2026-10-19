---
title: "Estimating Work Items"
description: "Size GitHub issues and epics with story points on a powers-of-two scale, recorded as a label, an Estimate section, and a project field"
---

Give every issue or epic one story-point estimate on a powers-of-two scale: 1, 2, 4, and 8 for issues, 16 and 32 for epics. The agent estimates alone while it writes or refines the item, comparing it against reference stories rather than guessing at hours. An item that lands at 16 or 32 is an epic and is decomposed into children of 8 or less before anything is implemented.

## Supported coding agents

| Coding agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- You are writing or refining a GitHub issue that needs a size
- You are asked to estimate, size, or point an issue, an epic, or a backlog
- You need to decide whether an item is an issue or an epic
- An item's scope changed and its estimate needs a second look

## Features

**One number, one scale**
Exactly one value from 1, 2, 4, 8, 16, or 32. No ranges, half points, or off-scale numbers, and 8 is the ceiling for a single issue.

**Estimability gate**
Items that describe a goal with no observable outcome get a question back to the author or a time-boxed spike, never a number with a disclaimer.

**Score, then triangulate**
Effort, complexity, and uncertainty are scored before any number is chosen, then the item is compared against one smaller and one larger reference story.

**Bundled reference stories**
Ships with reference stories for every bucket, and prefers a repo-local `docs/estimation/reference-stories.md` when the team has one.

**Epics are decomposed, not implemented**
A 16 or 32 gets the `epic` label and is handed to Issue Decomposition. Children must each be 8 or less, and the epic's points are re-checked against their sum.

**Recorded in three places**
A `points-<n>` label, an `## Estimate` section whose first line is machine-readable, and a GitHub Project number field when the repo has one. Timeline Planning reads these to build Gantt charts.

**Splitting patterns and anti-patterns**
Includes the Humanizing Work story-splitting patterns for oversized items and a table of estimation anti-patterns such as points-as-hours and re-estimating finished work.
