---
title: "Project Foundations (Bundle)"
description: "A curated bundle for establishing and repairing project foundations and taking a project from concept to a diagrammed, story-driven plan with supported coding agents"
---

A curated bundle that establishes project foundations, repairs drifted or incomplete setups, and takes a project from concept to a diagrammed, story-driven plan: project setup, setup repair, issue decomposition, user stories, verification plans, and architecture/dependency/Mermaid diagrams.

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
| [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}) | Establishes project foundations by authoring distinct `CLAUDE.md` and `AGENTS.md` files, a `TDD.rules.md` file at the project root populated from interview answers, runnable `Commands` documentation, and, when applicable, a Claude Code failure-pattern file. |
| [Repairing Project Setup]({{< relref "skills/repairing-project-setup.md" >}}) | Audits an existing setup against the current setup specification, repairs only the identified delta while preserving recorded decisions, and re-audits the full setup before reporting. |
| [Issue Decomposition]({{< relref "skills/issue-decomposition.md" >}}) | Decompose projects into well-structured GitHub issues with user stories, acceptance criteria, and estimates. |
| [Writing User Stories]({{< relref "skills/writing-user-stories.md" >}}) | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist. |
| [Writing Verification Plans]({{< relref "skills/writing-verification-plans.md" >}}) | Create verification plans for real-world acceptance testing with concrete scenarios and success criteria. |
| [Architecture Diagramming]({{< relref "skills/architecture-diagramming.md" >}}) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. |
| [Dependency Mapping]({{< relref "skills/dependency-mapping.md" >}}) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths. |
| [Mermaid Diagrams]({{< relref "skills/mermaid-diagrams.md" >}}) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. |

## How to use it

Install the bundle when the full concept-to-plan workflow and setup maintenance belong in one place. The curated bundle delivers the repair capability alongside setup and planning skills. Each skill points back to its canonical definition under `skills/`, keeping bundle content aligned as those definitions evolve.


---

<!-- doc-holiday-watermark -->
<p align="center">
  <a href="https://doc.holiday">
    <img alt="Doc Holiday logo" src="https://doc.holiday/assets/docs-by-doc-holiday.png" width="200">
  </a>
</p>
<p align="center">Docs authored by <a href="https://doc.holiday">Doc Holiday</a></p>
