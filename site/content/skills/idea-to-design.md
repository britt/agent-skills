---
title: "Idea to Design"
description: "Transform raw idea notes into comprehensive design documents with research and decisions"
---

Transform raw idea notes into comprehensive design documents autonomously. This skill reads an idea note, researches unknowns, writes a full design document, and produces explicit decision logs and research references -- all without asking questions. Unclear areas are handled by stating assumptions and documenting them.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install britt/idea-to-design
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
- You have a rough idea note and want to turn it into a real plan
- You want a design document created from a concept or proposal
- You need to plan an idea end-to-end with research and documented decisions

## Features

**Fully autonomous workflow**
Asks zero questions. Makes reasonable decisions and documents every assumption in a dedicated Decisions.md file with alternatives and reasoning.

**Structured output files**
Produces a Design.md, Decisions.md, and Research.md alongside the original idea note, all organized in an Ideas subfolder.

**Comprehensive design coverage**
The design document answers what it is, who it is for, how it works technically, where it deploys, what the business model is, what the risks are, and what the next steps are.

**Mermaid diagrams included**
Uses Mermaid for all visual elements including architecture diagrams, sequence diagrams, data flows, and state machines -- no ASCII art.
