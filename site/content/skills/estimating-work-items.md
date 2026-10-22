---
title: "Estimating Work Items"
description: "Size GitHub issues with story points on a powers-of-two scale and total epics from their children, recorded as a label, an Estimate section, and a project field"
---

Give every issue one story-point estimate on a powers-of-two scale: 1, 2, 4, or 8. The agent estimates alone while it writes or refines the item, comparing it against reference stories rather than guessing at hours. Anything bigger than 8 is an epic: it is decomposed into children of 8 or less, and its points are simply the sum of theirs, with no upper limit.

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
Exactly one value from 1, 2, 4, or 8 for an issue. No ranges, half points, or off-scale numbers, and 8 is the ceiling for a single issue.

**Estimability gate**
Items that describe a goal with no observable outcome get a question back to the author or a time-boxed spike, never a number with a disclaimer.

**Score, then triangulate**
Effort, complexity, and uncertainty are scored before any number is chosen, then the item is compared against one smaller and one larger reference story.

**Bundled reference stories**
Ships with reference stories for every bucket, and prefers a repo-local `docs/estimation/reference-stories.md` when the team has one.

**Epics are the sum of their children**
An epic is never estimated directly. It gets the `epic` label and is handed to Issue Decomposition, its children must each be 8 or less, and its points are the exact sum of theirs: 15, 48, or 300, with no rounding and no size limit.

**Recorded where tools can read it**
A `points-<n>` label on issues, an `## Estimate` section whose first line is machine-readable, and a GitHub Project number field when the repo has one. Epics carry their sum in the section and the field, not in a label. Timeline Planning reads these to build Gantt charts.

**Every estimate says where it came from**
The Estimate section ends with an `Estimated by:` line that names the model that made the estimate, the harness it ran in (with its version and any outer orchestrator, such as Claude Code via Conductor), and the version of this skill it followed, so estimates can be compared across models and skill revisions. An estimate a person gives is recorded as `human`.

**Splitting patterns and anti-patterns**
Includes the Humanizing Work story-splitting patterns for oversized items and a table of estimation anti-patterns such as points-as-hours and re-estimating finished work.
