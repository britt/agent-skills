---
title: "Project Foundations (Bundle)"
description: "A curated bundle for taking a new project from concept to a diagrammed, story-driven plan across Claude Code, Codex CLI, OpenCode, and Cursor"
---

A curated bundle for taking a new project from concept to a diagrammed, story-driven plan: project setup, issue decomposition, user stories, verification plans, and architecture/dependency/Mermaid diagrams.

### Installation

Add the bundle through the marketplace flow for Claude Code, Codex CLI, or Cursor, or discover it from the shared `.agents/skills/` path in Codex CLI, OpenCode, and Cursor:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install project-foundations@britt

# Codex CLI uses the same bundle name with its plugin marketplace flow.
codex plugin marketplace add britt/claude-code-skills
codex plugin install project-foundations@britt
```

## Compatibility

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Claude.ai | |

## Included Skills

| Skill | Description |
|-------|-------------|
| [Setting Up a Project](./setting-up-a-project/) | Authors a CLAUDE.md file that defines your project's purpose, tech stack, and development practices before any code is written. |
| [Issue Decomposition](./issue-decomposition/) | Decompose projects into well-structured GitHub issues with user stories, acceptance criteria, and estimates. |
| [Writing User Stories](./writing-user-stories/) | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist. |
| [Writing Verification Plans](./writing-verification-plans/) | Create verification plans for real-world acceptance testing with concrete scenarios and success criteria. |
| [Architecture Diagramming](./architecture-diagramming/) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. |
| [Dependency Mapping](./dependency-mapping/) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths. |
| [Mermaid Diagrams](./mermaid-diagrams/) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. |

## How to use it

Install the bundle when you want the full concept-to-plan workflow in one step rather than installing each skill individually. Each skill in the bundle is single-sourced back to its canonical definition under `skills/`, so bundle and standalone installs always stay in sync.
