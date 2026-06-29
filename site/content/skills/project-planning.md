---
title: "Project Planning"
description: "Orchestrate comprehensive project planning with issues, architecture diagrams, dependency maps, and timelines"
---

Orchestrate a comprehensive project planning workflow that generates GitHub issues, architecture diagrams, dependency graphs, and timeline charts from a natural language project description. This skill coordinates four sub-skills (issue decomposition, architecture diagramming, dependency mapping, and timeline planning) into a single end-to-end planning process.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install project-planning@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Compatibility

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Claude.ai | ✓ |

## How to use it

Use this skill when:
- Planning a new project end-to-end
- You want to go from a project description to issues, diagrams, and timelines
- Scoping out implementation work for a feature or system
- You need a complete planning document with architecture, dependencies, and schedule

## Features

**End-to-end planning orchestration**
Coordinates issue decomposition, architecture diagramming, dependency mapping, and timeline planning into a single workflow from description to saved plan.

**Discovery-first approach**
Starts by asking clarifying questions about project goals, technical context, and constraints, and analyzes the existing codebase before generating any artifacts.

**Preview before creation**
Shows a complete preview of all proposed issues, architecture diagram, dependency graph, and Gantt chart for review before creating anything in GitHub.

**Persistent planning documents**
Saves a comprehensive planning document with overview, goals, architecture, dependency graph, timeline, risks, and issue listing to the project for future reference.
