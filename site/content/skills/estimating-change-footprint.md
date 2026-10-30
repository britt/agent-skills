---
title: "Estimating Change Footprint"
description: "Estimate the lines an issue will change and the files an agent must read, to predict its coding-agent token spend"
---

Give every issue a change footprint: the expected size of its merged diff and the expected number of files a coding agent must read to make it, each in its own bucket. Token spend tracks what the agent changes and what it has to hold in context, not how hard the work feels, so footprint is the estimate to trust when the question is what the work will cost. Epics are the sum of their children.

## Supported coding agents

| Coding agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

The skill reads the repo's source to enumerate the change and records the result with the `gh` CLI, so it needs to run where the code is checked out and `gh` is authenticated.

## How to use it

Use this skill when:
- You are writing or refining a GitHub issue that needs a cost estimate
- You are asked to estimate, size, budget, or forecast agent spend on an issue, an epic, or a backlog
- You need to decide whether an item is an issue or an epic
- An issue's PR has merged and its actual footprint should be recorded beside the estimate

It does not estimate time. Story points from Estimating Work Items can sit alongside a footprint on the same issue.

## Features

**Two dimensions, never multiplied**
Diff size (lines added plus deleted: XS, S, M, L, XL) and read scope (distinct files read: R1 to R4) are recorded side by side, exactly one bucket each. Anything over 10,000 lines is an epic.

**Estimated from the code, not the title**
An estimability gate requires naming the files the change will touch. The agent then lists every file it expects to create or modify with a rough line count, and counts the callers, tests, types, and docs it must read, using `grep -rl` rather than guessing. An item that can't be pinned to files gets questions back or becomes a spike.

**Expected tokens from a calibration table**
A default fit from 77 closed issues (`tokens ≈ 0.083M × lines^0.755 × files^0.207`, band ±1.65×) turns the buckets into an expected-tokens figure. A repo-local `docs/estimation/footprint-calibration.md` overrides it, and the skill includes the query to rebuild it from Miranda data.

**Recorded where tools can read it**
`diff-<bucket>` and `reads-<bucket>` labels, a `## Footprint` section whose first two lines are machine-readable, and a GitHub Project number field for expected tokens when the repo has one. Epics carry the sum of their children in the section and the field.

**Estimate and actual in the same units**
When the PR merges, an `Actual:` line records the merged diff size, files read, and measured tokens beside the estimate. That is what recalibration is built from.

**Every estimate says where it came from**
The Footprint section ends with an `Estimated by:` line naming the model, the harness, and the skill version, in the same format as Estimating Work Items.

**Splitting patterns and anti-patterns**
Footprint-oriented splitting patterns for oversized items, such as isolating the change to a widely imported module so only one child carries the wide read, and a table of anti-patterns such as estimating from the title or converting footprint to hours.
