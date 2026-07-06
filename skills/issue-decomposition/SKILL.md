---
name: issue-decomposition
description: "Use when the user says 'create issues for...', 'break this into tasks', or 'decompose this feature', or when converting a project description into GitHub issues - produces 5-15 INVEST-quality issues with user stories, acceptance criteria, dependencies, labels, and T-shirt estimates"
---

# Issue Decomposition Skill

Transform high-level project descriptions into well-structured GitHub issues. Each issue includes a user story, acceptance criteria, dependencies, labels, and effort estimates.

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
`[type]`, `[area]`, `[priority]`

## Estimate
[T-shirt size: Small/Medium/Large/XL with rough duration]
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
- **Estimable**: Can be sized with reasonable confidence
- **Small**: Completable in 1-5 days
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

| # | Title | Estimate | Dependencies |
|---|-------|----------|--------------|
| 1 | Setup project structure | Small | None |
| 2 | Implement core feature X | Medium | Blocked by #1 |
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

## Estimation Guidelines

| Size | Typical Duration | Complexity |
|------|------------------|------------|
| Small | 0.5-1 day | Single file, clear implementation |
| Medium | 2-3 days | Multiple files, some unknowns |
| Large | 4-5 days | Multiple components, integration |
| XL | 1+ week | Consider breaking down further |

## Best Practices

1. **Start with the foundation** - Setup and infrastructure issues first
2. **One concern per issue** - Each issue does one thing well
3. **Clear acceptance criteria** - Know when it's done
4. **Explicit dependencies** - Note what blocks what
5. **Realistic estimates** - Include buffer for unknowns
6. **Consistent labels** - Use established taxonomy
7. **Link related issues** - Cross-reference for context

## Example Decomposition

See [example.md](example.md) for a worked decomposition of "Build a user authentication system" into 7 issues.

## After Decomposition

Once issues are created:
- Suggest running `dependency-mapping` skill to visualize relationships
- Suggest running `timeline-planning` skill to create a Gantt chart
- Offer to save the decomposition summary for future reference
