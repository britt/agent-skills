---
name: markdown-formatting
description: "Format AI outputs into consistent, readable Markdown for PRs, issues, docs, and notes"
instructions: "When formatting output as polished Markdown for pull requests, issues, documentation, or notes"
tags:
  - formatting
  - markdown
  - documentation
  - pr-description
  - issues
---

# Markdown Formatting Skill

Apply consistent Markdown formatting to all outputs. Structure content for readability and professionalism.

## When to Use

Activate when producing:
- PR descriptions and issue bodies
- Documentation and guides
- Notes and summaries
- Any structured text output

## Core Principles

1. **Lead with the point** - TL;DR or summary first, details after
2. **Use structure** - Headings, lists, and whitespace aid scanning
3. **Be consistent** - Same patterns across all outputs
4. **Respect context** - PRs need checklists, docs need examples

## Formatting Rules

### Document Structure

```
# Title (standalone documents only)

Brief summary or TL;DR (1-2 sentences)

## Section Heading

Content organized by topic...
```

### Headings

- Use `##` for main sections (reserve `#` for document title)
- Use `###` sparingly for subsections
- Never skip levels (no `##` to `####`)

### Lists

- Use `-` for unordered lists (not `*`)
- Use `1.` for ordered/sequential steps
- Nest with 2-space indent
- Keep list items parallel in structure

### Code

- Inline: backticks for `commands`, `filenames`, `variables`
- Blocks: triple backticks with language identifier
- Always specify language: ```typescript, ```bash, ```json

### Emphasis

- **Bold** for key terms, warnings, important points
- *Italics* sparingly for emphasis or introducing terms
- Never combine bold and italics

### Links

- Descriptive text: `[installation guide](url)` not `[click here](url)`
- Reference issues/PRs with `#123` format

## Templates

### PR Description

```markdown
## Summary

[One-line description of the change]

## Changes

- [Change 1]
- [Change 2]

## Test Plan

- [ ] [Test case 1]
- [ ] [Test case 2]
```

### Issue Body

```markdown
## Problem

[What is wrong or missing]

## Steps to Reproduce

1. [Step 1]
2. [Step 2]

## Expected

[What should happen]

## Actual

[What actually happens]
```

## Anti-patterns

- Walls of text without structure
- Inconsistent list markers (`*`, `-`, `+` mixed)
- Code blocks without language identifiers
- Headings used as emphasis
- Trailing whitespace or excessive blank lines
