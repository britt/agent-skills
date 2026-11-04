---
title: "Project Foundations (Bundle)"
description: "A curated bundle for taking a project from concept to merged work with supported coding agents"
---

A curated bundle for taking a project from concept to merged work: project setup and analysis, issue decomposition, story-point and change-footprint estimates, user stories, verification plans, architecture/dependency/Mermaid diagrams, and Conductor-driven work on issues and epics.

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
| [Architecture Diagramming]({{< relref "skills/architecture-diagramming.md" >}}) | Generate Mermaid architecture diagrams showing system components, layers, and data flows. |
| [Dependency Mapping]({{< relref "skills/dependency-mapping.md" >}}) | Generate Mermaid dependency graphs showing issue relationships, blocking chains, and critical paths. |
| [Estimating Change Footprint]({{< relref "skills/estimating-change-footprint.md" >}}) | Estimate the lines an issue will change and the files an agent must read, to predict its token spend. |
| [Estimating Work Items]({{< relref "skills/estimating-work-items.md" >}}) | Size issues and epics with story points on a powers-of-two scale, recorded as a label, an Estimate section, and a project field. |
| [Issue Decomposition]({{< relref "skills/issue-decomposition.md" >}}) | Decompose projects into well-structured GitHub issues with user stories, acceptance criteria, and estimates. |
| [Mermaid Diagrams]({{< relref "skills/mermaid-diagrams.md" >}}) | Guide for creating syntactically correct Mermaid diagrams that render properly on GitHub. |
| [Project Analysis]({{< relref "skills/project-analysis.md" >}}) | Analyze project codebase structure, architecture, key files, and dependencies. |
| [Repairing Project Setup]({{< relref "skills/repairing-project-setup.md" >}}) | Audit a repo's agent setup against what Setting Up a Project would generate today and repair only the gaps, preserving existing content. |
| [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}) | Authors a CLAUDE.md file that defines your project's purpose, tech stack, and development practices before any code is written. |
| [Supervising Conductor Workspaces]({{< relref "skills/supervising-conductor-workspaces.md" >}}) | Dispatch a Conductor workspace per issue and supervise their PRs until every one has merged. |
| [Working on an Epic]({{< relref "skills/working-on-an-epic.md" >}}) | Coordinate an epic through parallel Conductor workspaces, one per child issue. |
| [Working on an Issue]({{< relref "skills/working-on-an-issue.md" >}}) | Hands-off implementation of GitHub issues, reviewed at the PR. |
| [Writing User Stories]({{< relref "skills/writing-user-stories.md" >}}) | Write properly formatted user stories with Given-When-Then acceptance criteria and an INVEST quality checklist. |
| [Writing Verification Plans]({{< relref "skills/writing-verification-plans.md" >}}) | Create verification plans for real-world acceptance testing with concrete scenarios and success criteria. |

## How to use it

Install the bundle when the full concept-to-plan workflow belongs in one place rather than as separate skills. Each skill in the bundle points back to its canonical definition under `skills/`, so bundle and standalone installs stay in sync.
