---
title: "Build FAQ from Issues"
description: "Extract common questions from closed GitHub issues and generate an FAQ document with answers"
---

Extract common questions from closed GitHub issues and generate a structured FAQ document with answers and source links. This skill turns your resolved support history into reusable documentation that reduces repeat questions.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install britt/build-faq-from-issues
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
- Creating or updating a project FAQ
- Documenting common support questions to reduce repeat issues
- Onboarding new users or contributors
- Building support documentation from past issues

## Features

**Intelligent question selection**
Focuses on closed and resolved issues, prioritizing those labeled with question, help, support, or faq while skipping one-off bugs and feature requests.

**Categorized FAQ output**
Organizes questions into logical categories like General, Setup and Installation, Troubleshooting, and Configuration, with the most common questions first.

**Standalone answers with source links**
Writes clear, self-contained answers that do not require reading the original issue, with references back to the source issues for context.

**Deduplication of similar questions**
Combines multiple issues asking the same thing into a single FAQ entry, referencing all related issues and using the clearest answer.
