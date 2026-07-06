---
title: "Writing User Stories"
description: "Write properly formatted user stories for task definition"
---

Write properly formatted user stories that identify the persona, desired action, and expected benefit, complete with Given-When-Then acceptance criteria and an INVEST quality check, so you can turn product ideas into clear, testable work items.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install writing-user-stories@britt
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
- Asked to write user stories
- Defining requirements
- Breaking a feature into stories
- Drafting product or feature issues for GitHub

## Features

**"As a / I want / so that" format**
Every story identifies the persona, the desired action, and the benefit, keeping requirements consistent and easy to scan.

**Given-When-Then acceptance criteria**
Each story gets clear, testable conditions in Given-When-Then format, preventing scope creep and unclear definitions of done.

**INVEST quality checklist**
Before a story is finalized, it's checked against INVEST (Independent, Negotiable, Valuable, Estimable, Small, Testable) to catch stories that are too vague, too large, or hard to test.

**Common pitfalls guidance**
Flags stories that are too technical, too vague, or missing the "why," with before/after examples to guide corrections.
