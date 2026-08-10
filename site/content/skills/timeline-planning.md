---
title: "Timeline Planning"
description: "Generate Mermaid Gantt charts for project timelines with phases, dependencies, and milestones"
---

Generate Mermaid Gantt charts that visualize project timelines, task scheduling, phases, and milestones based on GitHub issues and their estimates. This skill converts T-shirt size estimates to durations, respects blocking dependencies, groups tasks into phases, and highlights the critical path.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install timeline-planning@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported agents

| Coding agent | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- You want to know what the project timeline looks like
- Creating a Gantt chart or project schedule
- After issue decomposition to visualize task scheduling
- During sprint planning to allocate work across time

## Features

**Estimate-to-duration conversion**
Converts T-shirt size estimates (Small, Medium, Large, XL) to day-based durations with adjustments for team velocity and complexity.

**Dependency-aware scheduling**
Orders tasks based on blocking relationships using Mermaid's "after" syntax so dependent tasks automatically start after their prerequisites complete.

**Milestone and critical path support**
Marks key deliverables as milestones and highlights the critical path using Mermaid's crit modifier to show which tasks determine the minimum project duration.

**Parallel workstream visualization**
Supports multiple concurrent workstreams with proper integration points, showing where parallel work converges and how it affects the overall timeline.

**Reusable Gantt patterns**
Ships with a library of ready-made chart templates — linear projects, parallel workstreams, milestone-driven releases, and critical-path layouts — so common timeline shapes don't need to be built from scratch.
