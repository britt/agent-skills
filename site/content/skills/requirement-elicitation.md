---
title: "Requirement Elicitation"
description: "Adaptive conversational wizard for eliciting project requirements across functional, nonfunctional, and edge-case dimensions"
---

Guide users through a comprehensive requirement elicitation process using an adaptive conversational wizard. This skill captures functional, nonfunctional, and edge-case requirements through a structured but natural conversation, with domain-specific questions for web apps, APIs, CLIs, mobile, data pipelines, and more.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install britt/requirement-elicitation
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
- Starting a new project and need to define what to build
- Gathering functional and nonfunctional requirements
- You want a guided conversation to surface all project needs
- Preparing a requirements document before planning or development

## Features

**Conversational question flow**
Asks one question at a time in a natural, conversational style with context explaining why each question matters, rather than dumping all questions at once.

**Domain-specific question sets**
Adapts questions based on project type including web apps, APIs, full-stack, CLI tools, mobile apps, data pipelines, libraries, infrastructure, and AI/ML applications.

**Five structured sections**
Covers project overview, functional requirements, nonfunctional requirements, constraints, and edge cases and risks, with section summaries and the ability to revisit any section.

**Requirements document generation**
Compiles all captured requirements into a structured document with numbered requirements, open questions, and clear categorization ready for planning.
