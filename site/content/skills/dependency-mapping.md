---
title: "Dependency Mapping"
description: "Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths"
---

Generate Mermaid flowcharts that visualize GitHub issue dependencies, blocking relationships, and critical paths through your project. This skill parses issue descriptions and labels for dependency keywords, builds a relationship map, and produces clear diagrams with phases and critical path highlighting.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install dependency-mapping@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Coding agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- You want to see which issues block others
- Mapping issue dependencies or visualizing blocking chains
- During sprint planning to identify the critical path
- After issue decomposition to visualize relationships

## Features

**Automatic dependency detection**
Parses issue bodies and labels for dependency keywords like "blocked by," "depends on," "after," and "prerequisite" to build the relationship map.

**Critical path highlighting**
Identifies the longest chain of dependencies and highlights it with thick arrows and color styling to show what determines minimum project duration.

**Phased subgraph organization**
Groups issues into logical phases using Mermaid subgraphs for clear visual separation of foundation, feature, and integration work.

**Multiple graph layouts**
Supports linear dependencies (left-to-right), parallel work (top-to-bottom), and complex multi-branch layouts with consistent issue node naming conventions.

Requires the `gh` CLI (or an equivalent GitHub MCP server) to gather issue data.
