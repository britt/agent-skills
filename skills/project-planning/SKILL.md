---
name: project-planning
description: "Use when the user says 'build a project plan', 'help me plan X', 'break down this project', or 'scope out this feature' - orchestrates issue-decomposition, architecture-diagramming, dependency-mapping, and timeline-planning to produce GitHub issues, diagrams, and a saved plan document"
---

# Project Planning Skill

Orchestrate a comprehensive project planning workflow that generates GitHub issues, architecture diagrams, dependency graphs, and timeline charts from a natural language project description.

**Announce at start:** "I'm using the project-planning skill to turn this description into issues, diagrams, and a plan document."

## When to Use

Activate this skill when user says:
- "Let's build a project plan for..."
- "Help me plan [project name]"
- "Create a project plan"
- "Break down this project"
- "Help me scope out..."
- "Plan the implementation of..."

## Sub-Skills

This skill coordinates four specialized sub-skills:

| Skill | Purpose | Step |
|-------|---------|------|
| issue-decomposition | Break down into GitHub issues | 3 |
| architecture-diagramming | Generate architecture diagrams | 4 |
| dependency-mapping | Map issue dependencies | 5 |
| timeline-planning | Create Gantt charts | 6 |

### Getting the sub-skills

No single bundle ships this skill together with all four. Check what you have before you start:

| Install path | What it provides |
|---|---|
| `llpm` bundle | This skill plus issue-decomposition, dependency-mapping, timeline-planning. **Does not include architecture-diagramming** — install it standalone or skip to the inline fallback for Step 4. |
| `agent-skills` bundle | Everything. |
| Standalone plugins | All five are individually installable: `project-planning`, `issue-decomposition`, `architecture-diagramming`, `dependency-mapping`, `timeline-planning`. |

The `project-foundations` bundle does **not** contain this skill or timeline-planning. It covers the earlier, adjacent ground — project setup, user stories, verification plans, and the diagramming skills — so the two bundles complement each other rather than overlap: `project-foundations` sets a repo up, this skill plans the work inside it.

### Inline fallback

A sub-skill is unavailable when invoking it does not load it (it isn't in the session's skill list). Don't ask the user to install it mid-run. Perform that step inline instead, following the summary in the corresponding step below, and tell the user which steps ran inline so they can judge the output. Steps 4, 5 and 6 each degrade independently — losing one does not stop the others.

## Planning Workflow

### Step 1: Understand the Project

Read the user's description first and only ask about what it left open. Ask everything still
missing in a single batch, not one question at a time.

1. **Project Overview**
   - What is this project/feature?
   - Who are the primary users?
   - What problem does it solve?

2. **Technical Context**
   - What technologies will be used?
   - Are there existing patterns to follow?
   - What external integrations are needed?

3. **Constraints**
   - Any technical requirements or limitations?
   - Dependencies on other work?
   - A target start date or deadline?

These answers are the scoping input for every later step. `issue-decomposition` opens with its own version of these questions — answer them from what you already have here and do not re-ask the user.

### Step 2: Analyze Existing Codebase

If working in an existing project, use the `project-analysis` skill to map structure, architecture pattern, key files, and dependencies. If it is unavailable, inline that step: read the directory layout, the build/dependency manifests, and a representative module to learn the conventions the plan should follow.

Skip this step for a greenfield project and say so.

### Step 3: Decompose into Issues

Use the issue-decomposition skill to generate 5-15 well-structured issues with:
- User stories
- Acceptance criteria
- Dependencies
- Estimates
- Labels

**Give each proposed issue a plan-local id — `P1`, `P2`, `P3`...** Real issue numbers do not exist until Step 8, and `#1` style placeholders are indistinguishable from real references. Express every dependency between proposals with these ids ("blocked by P1"). Keep the decomposition in the conversation; nothing is written to GitHub yet.

`issue-decomposition` ends with its own preview-and-confirm gate. Skip it — this skill confirms once, at Step 7, over the whole plan.

### Step 4: Generate Architecture Diagram

Use the architecture-diagramming skill to create a Mermaid diagram showing:
- Major components
- Data flow
- External integrations
- Boundaries and layers

Inline fallback: a `flowchart TD` with one node per major component, subgraphs for layers, and arrows for data flow. No parentheses inside node labels.

### Step 5: Map Dependencies

Use the dependency-mapping skill to generate a dependency graph showing:
- Blocking relationships
- Parallel opportunities
- Critical path

**Input:** the Step 3 decomposition held in the conversation, keyed by plan-local id. `dependency-mapping` opens by fetching issues with `gh issue list` — that path is for graphing issues already on GitHub. Here the issues do not exist yet, so pass it the proposed set explicitly and let it skip its own gathering step. Use `gh issue list` only when planning around work already filed, and then fold those real issues into the same graph alongside the proposals.

Inline fallback: a `flowchart LR` with one node per plan-local id and an arrow from each blocker to what it blocks; the longest chain is the critical path.

### Step 6: Create Timeline

Use the timeline-planning skill to create a Gantt chart with:
- Phases and milestones
- Task durations
- Dependencies

**Input:** the same Step 3 decomposition and the Step 5 graph — again, not `gh issue list`. Supply the estimates and blocking relationships directly. Use the start date from Step 1 if the user gave one, otherwise today.

Inline fallback: a `gantt` block with one section per phase and Small/Medium/Large/XL mapped to 1d/3d/5d/10d, ordering blocked tasks `after` their blockers.

### Step 7: Preview and Confirm

This is the workflow's only confirmation gate. Before creating anything:

```markdown
## Project Plan Preview

### Issues to Create (X total)
| Plan id | Title | Estimate | Labels | Dependencies |
|---------|-------|----------|--------|--------------|
| P1 | Setup | Small | chore | None |
| P2 | Core feature | Medium | feature | Blocked by P1 |
...

### Architecture
[Mermaid diagram]

### Dependencies
[Mermaid diagram]

### Timeline
[Mermaid Gantt]

### Labels
Existing: [labels already in the repo]
To create: [labels this plan needs that the repo does not have]

---
Create these issues and save the plan? (y/n)
```

State plainly that answering yes files real issues.

### Step 8: Create and Save

On confirmation:

1. **Reconcile labels first.** Run `gh label list` and compare against the labels in the preview. `gh issue create` fails on a label the repo does not have, and it has no `--dry-run`, so an unreconciled batch aborts partway with some issues already filed. Create the missing labels with `gh label create`, or drop them from the plan — whichever the user chose at Step 7.
2. **Create the issues** in dependency order (blockers first) with `gh issue create --title ... --body ... --label ...`, using the gh CLI or an available GitHub MCP tool. Record the real issue number returned for each plan-local id. If neither tool is available, output the issue bodies for manual creation and stop before step 3 below.
3. **Rewrite the plan-local ids.** Substitute the real numbers for `P1`, `P2`... throughout the dependency graph, the Gantt chart, and the issue table, and add the cross-references between issue bodies (`gh issue edit <n> --body-file ...`) now that the numbers are known. No `P<n>` may survive into the saved document.
4. **Save the planning document** to `docs/plans/<project-slug>-plan.md` in the format below.

**If creation fails partway:** stop the batch. Report which plan-local ids became real issues and which did not, then either fix the cause and create only the remainder, or delete nothing and let the user decide. Never re-run the whole batch — that duplicates the issues already filed.

## Planning Document Format

Save to `docs/plans/<project-slug>-plan.md`:

```markdown
# Project Plan: [Project Name]

**Generated:** [Date]
**Status:** Draft
**Owner:** @[GitHub login, from `gh api user --jq .login` or the user]

## Overview
[2-3 sentence summary of the project]

## Goals
- [Goal 1]
- [Goal 2]
- [Goal 3]

## System Architecture

[Mermaid flowchart from architecture-diagramming skill]

## Issue Dependency Graph

[Mermaid flowchart from dependency-mapping skill, with real issue numbers]

## Timeline

[Mermaid Gantt from timeline-planning skill, with real issue numbers]

## Risks & Assumptions
- [Risk or assumption 1]
- [Risk or assumption 2]

## Issues Created
| Issue | Title | Status | Estimate |
|-------|-------|--------|----------|
| #201 | [Title] | Open | Small |
| #202 | [Title] | Open | Medium |
...
```

Note which steps ran inline rather than through their sub-skill under Risks & Assumptions.

## Best Practices

1. **Start with understanding** - Don't jump to decomposition
2. **Ask once** - Reuse the Step 1 answers; never re-ask what the description already said
3. **Preview before creating** - One gate, over the whole plan
4. **Keep issues focused** - One concern per issue
5. **Plan-local ids until creation** - Real numbers only exist after Step 8
6. **Link everything** - Cross-reference issues, diagrams, notes
7. **Save outputs** - Store plan documents in the repo for future reference
8. **Iterate if needed** - User can adjust before finalizing

## After Planning

Suggest next steps:
- Assign issues to team members
- Set up project board with columns
- Schedule kickoff meeting
- Review plan with stakeholders

Related skills:
- `project-analysis` - Map an existing codebase before planning into it
- `working-on-an-issue` - Implement one of the issues this plan created
- `stakeholder-tracking` - Track stakeholder goals
- `requirement-elicitation` - Deeper requirements discovery
