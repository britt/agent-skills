---
name: issue-decomposition
description: "Decompose project descriptions into well-structured GitHub issues with user stories, acceptance criteria, dependencies, and estimates"
instructions: "When breaking down a project or feature into GitHub issues, decomposing work into tasks, or creating structured issues from a description"
allowed-tools: "create_github_issue list_github_issues search_github_issues add_note"
---

# Issue Decomposition Skill

Transform high-level project descriptions into well-structured GitHub issues. Each issue includes a user story, acceptance criteria, dependencies, labels, and effort estimates.

## When to Use

Activate this skill when:
- User describes a feature or project to break down
- User says "create issues for...", "break this into tasks", "decompose this feature"
- During project planning to generate actionable work items
- When converting requirements into GitHub issues

## Available Tools

| Tool | Purpose |
|------|---------|
| `create_github_issue` | Create individual issues with full details |
| `list_github_issues` | Check existing issues to avoid duplicates |
| `search_github_issues` | Find related issues for dependencies |
| `add_note` | Save decomposition summary to project notes |

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

## Label Taxonomy

### Type Labels
- `feature` - New functionality
- `enhancement` - Improvement to existing feature
- `bug` - Defect fix
- `chore` - Maintenance, dependencies, cleanup
- `docs` - Documentation only
- `test` - Test coverage

### Area Labels
- `frontend` - UI/UX changes
- `backend` - Server/API changes
- `database` - Schema/data changes
- `infrastructure` - DevOps/deployment
- `security` - Security-related

### Priority Labels
- `priority:high` - Critical path, do first
- `priority:medium` - Important, schedule soon
- `priority:low` - Nice to have, backlog

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

**User Request**: "Build a user authentication system"

**Generated Issues**:

1. **Set up auth module structure** (Small)
   - Create directory structure
   - Add base dependencies
   - No blockers

2. **Implement user registration endpoint** (Medium)
   - POST /auth/register
   - Email/password validation
   - Blocked by: #1

3. **Implement login endpoint with JWT** (Medium)
   - POST /auth/login
   - JWT generation
   - Blocked by: #1

4. **Add password reset flow** (Medium)
   - Email token generation
   - Reset endpoint
   - Blocked by: #2

5. **Implement logout and token invalidation** (Small)
   - Token blacklist
   - Blocked by: #3

6. **Add authentication middleware** (Small)
   - Protect routes
   - Blocked by: #3

7. **Write integration tests** (Medium)
   - Test all auth endpoints
   - Blocked by: #2, #3, #4, #5

## After Decomposition

Once issues are created:
- Suggest running `dependency-mapping` skill to visualize relationships
- Suggest running `timeline-planning` skill to create a Gantt chart
- Offer to save the decomposition summary to project notes
