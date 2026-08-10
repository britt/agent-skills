---
title: "Writing Product Specs"
description: "Write comprehensive product specification documents"
---

Write comprehensive product specification documents that clearly explain what you are building, why it matters, and how success will be measured. This makes it easier to align stakeholders around a shared understanding of the work.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install writing-product-specs@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Supported coding agents

| Agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- You're asked to write a product spec, product requirements document, or PRD
- You're designing a new feature and need to document requirements before implementation
- You're planning a project and need to define what will be built and why
- You need to communicate product requirements to stakeholders, engineers, or designers
- A feature request needs to be expanded into a detailed specification with context, requirements, and success criteria
- You need to document the "what" and "why" of a product decision before moving to implementation

## Features

**Guided elicitation**
Asks targeted questions to surface the problem, audience, pain points, proposed solution, success and failure criteria, and explicit non-goals before drafting begins.

**Structured spec template**
Drafts follow a consistent template covering Background (context, audience, problem statements), Hypothesis, Success Criteria, Requirements, Non-requirements, and Tradeoffs and Concerns, so every spec is complete and easy to review.

**Iterative refinement**
Presents the full draft, then revises based on your feedback until you confirm the spec is accurate and complete.

**Ready-to-save output**
Saves the finished spec as a markdown file named `spec-<feature-name>-MM-DD-YYYY.md`, or wherever you'd like it.
