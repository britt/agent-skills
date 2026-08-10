---
title: "Markdown Formatting"
description: "Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes"
---

Apply consistent Markdown formatting to all outputs, structuring content for readability and professionalism. This skill ensures that PR descriptions, issue bodies, documentation, and notes all follow the same formatting conventions with proper headings, lists, code blocks, and emphasis.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install markdown-formatting@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
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
- Writing PR descriptions or issue bodies
- Producing documentation and guides
- Creating notes and summaries
- Producing structured artifacts that will be saved or published, such as reports, READMEs, or changelogs

Not for conversational chat replies — normal responses don't need templates or strict formatting rules.

## Features

**Lead-with-the-point structure**
Every document starts with a TL;DR or summary, followed by details. Headings, lists, and whitespace are used to aid scanning.

**Context-aware templates**
Provides ready-made templates for PR descriptions (with summary, changes, and test plan) and issue bodies (with problem, steps to reproduce, expected, and actual), plus a filled-in example PR description showing the rules applied.

**Consistent formatting rules**
Enforces dash-style unordered lists, numbered ordered lists, language-identified code blocks, proper heading hierarchy, and descriptive link text.

**Anti-pattern detection**
Identifies common mistakes like walls of text, mixed list markers, code blocks without language identifiers, and headings used as emphasis.
