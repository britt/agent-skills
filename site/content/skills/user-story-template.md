---
title: "User Story Template"
description: "Guide writing well-formed user stories with acceptance criteria following best practices"
---

Create well-formed user stories that follow product management best practices. This skill provides a structured template with user story statements, Given-When-Then acceptance criteria, and quality checks based on the INVEST principles (Independent, Negotiable, Valuable, Estimable, Small, Testable).

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install user-story-template@britt
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
- Creating new features or requirements
- Writing GitHub issues for product work
- Planning sprints or releases
- Documenting user needs with clear acceptance criteria

## Features

**Standard user story format**
Every story follows "As a [user], I want [action], so that [benefit]" with clear guidance on avoiding common pitfalls like missing the "why" or being too vague.

**Given-When-Then acceptance criteria**
Structures testable conditions using the Given-When-Then format so the team knows exactly what "done" looks like and QA has clear verification steps.

**INVEST quality checklist**
Includes a pre-finalization checklist verifying the story is Independent, Negotiable, Valuable, Estimable, Small, and Testable before it goes to the team.

**Common pitfall examples**
Shows concrete before-and-after examples of stories that are too technical, too vague, or missing acceptance criteria, making it easy to spot and fix problems.
