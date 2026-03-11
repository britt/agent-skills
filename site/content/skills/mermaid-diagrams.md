---
title: "Mermaid Diagrams"
description: "Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub"
---

Create clear, maintainable Mermaid diagrams directly in Markdown that render correctly on GitHub, GitLab, and documentation tools. This skill covers flowcharts, sequence diagrams, class diagrams, state diagrams, entity relationship diagrams, Gantt charts, and git graphs with proper syntax that avoids common rendering pitfalls.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install britt/mermaid-diagrams
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
- Creating flowcharts, sequence diagrams, or class diagrams
- Visualizing API flows, decision trees, or system architecture
- Building entity relationship diagrams or state machines
- Adding any visual diagram to Markdown documentation

## Features

**Seven diagram types supported**
Covers flowcharts, sequence diagrams, class diagrams, state diagrams, entity relationship diagrams, Gantt charts, and git graphs with syntax examples for each.

**GitHub-safe syntax enforcement**
Strictly avoids parentheses inside labels and ensures matching brackets on all node shapes, preventing the most common Mermaid rendering errors.

**Common pattern library**
Includes ready-to-use patterns for API flows, decision flows, and system architecture diagrams that can be adapted to your specific needs.

**Complete syntax reference**
Provides a reference for node shapes, arrow types, and styling options so you can customize diagrams without consulting external documentation.
