---
title: "Mermaid Diagrams"
description: "Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub"
---

Create clear, maintainable Mermaid diagrams directly in Markdown that render correctly on GitHub, GitLab, and documentation tools. This skill covers flowcharts, sequence diagrams, class diagrams, state diagrams, entity relationship diagrams, Gantt charts, and git graphs with proper syntax that avoids common rendering pitfalls.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install mermaid-diagrams@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
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
- Creating flowcharts, sequence diagrams, or class diagrams
- Visualizing API flows or decision trees
- Building entity relationship diagrams or state machines
- Adding any visual diagram to Markdown documentation
- A Mermaid diagram fails to render on GitHub and needs its syntax fixed

## Features

**Seven diagram types supported**
Covers flowcharts, sequence diagrams, class diagrams, state diagrams, entity relationship diagrams, Gantt charts, and git graphs with syntax examples for each.

**GitHub-safe syntax enforcement**
Strictly avoids parentheses inside labels and ensures matching brackets on all node shapes, preventing the most common Mermaid rendering errors.

**Common pattern library**
Includes ready-to-use patterns for API flows and decision flows that can be adapted to your specific needs. For system architecture diagrams (components, layers, data flows), use the `architecture-diagramming` skill instead.

**Complete syntax reference**
Provides a reference for node shapes, arrow types, and styling options so you can customize diagrams without consulting external documentation.
