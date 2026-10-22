---
name: issue-decomposition
description: "Use when the user says 'create issues for...', 'break this into tasks', or 'decompose this feature', or when converting a project description into GitHub issues - produces 5-15 INVEST-quality issues with user stories, acceptance criteria, dependencies, labels, and powers-of-two point estimates"
---

# Issue Decomposition Skill

Transform high-level project descriptions into well-structured GitHub issues. Each issue includes a user story, acceptance criteria, dependencies, labels, and a story-point estimate on the powers-of-two scale from the `estimating-work-items` skill.

## When to Use

Activate this skill when:
- User describes a feature or project to break down
- User says "create issues for...", "break this into tasks", "decompose this feature"
- During project planning to generate actionable work items
- When converting requirements into GitHub issues

**When NOT to use:** not for single bug reports or tasks already small enough to be one issue; not for dependency visualization (use the `dependency-mapping` skill).

## Issue Template

Each generated issue follows this structure:

```markdown
# [Concise, Action-Oriented Title]

## User Story
As a [persona/role], I want [goal/action] so that [benefit/value].

## Description
[2-4 sentences explaining the context and what needs to be done]

## Acceptance Criteria
- [ ] Criterion 1: Specific, testable requirement
- [ ] Criterion 2: Another measurable outcome
- [ ] Criterion 3: Edge case or validation requirement

## Dependencies
- Blocked by: #[number] - [brief reason]
- Blocks: #[number] - [what depends on this]

## Labels
`[type]`, `[area]`, `[priority]`, `points-[n]`

## Estimate
**[n] points**

Compared with: [smaller reference] ([n]) and [larger reference] ([n]) - [why it is closer to one than the other].
Main unknown: [the one thing most likely to make this bigger], or "none".
Estimated by: [model] in [harness], estimating-work-items [version]
```

## Decomposition Process

### Step 1: Understand the Scope
Ask clarifying questions if needed:
- What is the core goal of this project/feature?
- Who are the primary users?
- Are there any technical constraints or preferences?
- What's the target timeline?

### Step 2: Identify Major Components
Break the project into 3-7 major areas:
- Foundation/Setup tasks
- Core functionality
- Supporting features
- Integration points
- Testing/Validation

### Step 3: Generate Issues
For each component, create issues that are:
- **Independent**: Minimal dependencies on other issues
- **Negotiable**: Clear what, flexible how
- **Valuable**: Delivers user or technical value
- **Estimable**: Passes the estimability gate in `estimating-work-items` (you can say what done looks like)
- **Small**: 8 points or less on the powers-of-two scale; anything bigger is an epic with its own children
- **Testable**: Has clear acceptance criteria

### Step 4: Map Dependencies
Identify blocking relationships:
- Sequential dependencies (A must finish before B)
- Parallel opportunities (can be done simultaneously)
- Critical path (longest chain of dependent issues)

### Step 5: Preview Before Creating
Always show the user a summary before creating issues:

```markdown
## Proposed Issues (N total)

| # | Title | Points | Dependencies |
|---|-------|--------|--------------|
| 1 | Setup project structure | 2 | None |
| 2 | Implement core feature X | 4 | Blocked by #1 |
...

Proceed with creation? (y/n)
```

### Step 6: Create the Issues
On approval, create each issue with `gh issue create --title ... --body ... --label ...` (requires the gh CLI authenticated for the repo). If gh is unavailable, output the issue bodies for manual creation.

## Label Taxonomy

Check existing repo labels first (`gh label list`) and prefer them over this default taxonomy.

- **Type**: `feature`, `enhancement`, `bug`, `chore`, `docs`, `test`
- **Area**: `frontend`, `backend`, `database`, `infrastructure`, `security`
- **Priority**: `priority:high`, `priority:medium`, `priority:low`
- **Estimate**: `points-1`, `points-2`, `points-4`, `points-8` (issues); `epic` with no `points-*` label (epics, whose points are the sum of their children)

## Estimation Guidelines

Size every issue with the `estimating-work-items` skill: score effort, complexity, and uncertainty, triangulate against reference stories, and pick one bucket on the powers-of-two scale.

| Points | Kind | Rule |
|--------|------|------|
| 1, 2, 4, 8 | issue | 8 is the ceiling for a single issue |
| Sum of children, no limit | epic | Anything bigger than 8. Never created as a plain issue. Label it `epic` and decompose it into children of 8 or less; a child bigger than 8 is decomposed again |

An epic is not estimated directly. After decomposing it, add up the children: the exact sum, unrounded and uncapped, is the epic's points. Points are relative size, not days; `timeline-planning` owns the conversion to durations.

## Best Practices

1. **Start with the foundation** - Setup and infrastructure issues first
2. **One concern per issue** - Each issue does one thing well
3. **Clear acceptance criteria** - Know when it's done
4. **Explicit dependencies** - Note what blocks what
5. **Honest estimates** - Name the main unknown in the Estimate section instead of padding the number
6. **Consistent labels** - Use established taxonomy
7. **Link related issues** - Cross-reference for context

## Example Decomposition

See [example.md](example.md) for a worked decomposition of "Build a user authentication system" (an epic) into 7 issues totalling 18 points.

## After Decomposition

Once issues are created:
- Suggest running `dependency-mapping` skill to visualize relationships
- Suggest running `timeline-planning` skill to create a Gantt chart
- Offer to save the decomposition summary for future reference
