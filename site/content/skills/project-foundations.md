---
title: "Project Foundations (Bundle)"
description: "A curated bundle for taking a new project from concept to a diagrammed, story-driven plan with supported coding agents"
---

A curated bundle for taking a new project from concept to a diagrammed, story-driven plan: project setup, issue decomposition, user stories, verification plans, and architecture/dependency/Mermaid diagrams.

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## Included Skills

| Skill | Description |
|-------|-------------|
| [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}) | Authors a CLAUDE.md file that defines your project's purpose, tech stack, and development practices before any code is written. |
| [Issue Decomposition]({{< relref "skills/issue-decomposition.md" >}}) | Decompose projects into well-structured GitHub issues with user stories, acceptance criteria, and estimates. |
| [Writing User Stories]({{< relref "skills/writing-user-stories.md" >}}) | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist. |
| [Writing Verification Plans]({{< relref "skills/writing-verification-plans.md" >}}) | Create verification plans for real-world acceptance testing with concrete scenarios and success criteria. |
| [Architecture Diagramming]({{< relref "skills/architecture-diagramming.md" >}}) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. |
| [Dependency Mapping]({{< relref "skills/dependency-mapping.md" >}}) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths. |
| [Mermaid Diagrams]({{< relref "skills/mermaid-diagrams.md" >}}) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. |

## How to use it

Install the bundle when the full concept-to-plan workflow belongs in one place rather than as separate skills. Each skill in the bundle points back to its canonical definition under `skills/`, so bundle and standalone installs stay in sync.
