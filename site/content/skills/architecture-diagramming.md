---
title: "Architecture Diagramming"
description: "Generate Mermaid architecture diagrams showing system components, layers, and data flows"
---

Create clear, GitHub-compatible Mermaid architecture diagrams that visualize system components, layers, boundaries, and data flows. Whether you need a system overview, layered architecture, request flow, or microservices diagram, this skill produces well-structured Mermaid syntax that renders correctly on GitHub.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install architecture-diagramming@britt
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
- You need an architecture diagram for your system
- You want to visualize how components interact
- During project planning to communicate system design
- Explaining layered architecture, request flows, or microservices layouts

## Features

**Multiple diagram patterns**
Supports system overviews, layered architectures, request flows, and microservices diagrams with subgraphs for clear boundaries.

**GitHub-safe Mermaid syntax**
Follows strict syntax rules to avoid rendering errors, including never using parentheses inside labels and always ensuring matching brackets.

**Structured analysis process**
Walks through identifying components, determining layers, mapping relationships, applying boundaries, and generating a clean diagram.

**Consistent naming and arrow conventions**
Uses clear abbreviations for node names and meaningful arrow types to distinguish standard, async, and critical-path relationships.
