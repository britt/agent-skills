---
name: at-risk-detection
description: "Proactively identify at-risk issues and PRs: stale items, blocked work, deadline risks, scope creep, and unassigned high-priority items"
instructions: "When checking project health, finding stale or blocked issues, identifying deadline risks, or detecting scope creep"
tags:
  - risk
  - health
  - stale
  - blocked
  - deadline
  - project-management
allowed-tools: "list_github_issues get_github_issue_with_comments"
---

# At-Risk Detection Skill

Proactively scan GitHub issues and pull requests to identify at-risk items before they become problems.

## When to Use

Activate when:
- Starting a new sprint or planning session
- During standup to identify blockers
- Weekly health checks of the project
- When asked about project health or status
- Before milestone deadlines
- When triaging backlog items

## Available Tools

| Tool | Purpose |
|------|---------|
| `list_github_issues` | Fetch open issues and PRs for analysis |
| `get_github_issue_with_comments` | Deep-dive into specific issues for detailed risk signals |

## Analysis Approach

### Quick Mode (Default)

Fetch the 30 most recent open issues using `list_github_issues`:
- Fast (seconds)
- Good for daily checks
- May miss older stale items

### Comprehensive Mode

Fetch ALL open issues by paginating through `list_github_issues`:
- Thorough analysis
- Slower for large repositories
- Best for milestone reviews

## Risk Types and Detection Heuristics

### Stale Items
**Signal**: No activity for extended period
**Default Threshold**: 14 days for issues, 3 days for PRs awaiting review
**Severity Escalation**:
- Warning: > threshold days since last activity
- Critical: > 2x threshold days since last activity

**How to detect**: Check `updated_at` field on each issue/PR. Calculate days since last update.

### Blocked Work
**Signals**:
- Has labels matching: `blocked`, `waiting`, `on-hold`, `waiting-for-response`
- Body contains: "blocked by #", "waiting on", "depends on", "blocked until"
- PR is in draft status
- PR has merge conflicts (if detectable from comments)

**How to detect**: Check `labels` array for blocking keywords. Search `body` text for blocking phrases.

### Deadline Risks
**Signal**: Milestone deadline approaching or overdue
**Severity Levels**:
- Critical: Overdue or due within 2 days
- Warning: Due within 7 days

**How to detect**: Check if issue has a `milestone` with a `due_on` date. Compare to current date.

### Scope Creep
**Signals**:
- Issues with high comment count (>30 comments)
- PRs with many lines changed (>500 warning, >1000 critical)

**How to detect**: Check `comments` count on issues. For PRs, check `additions + deletions` if available.

### Assignment Issues
**Signal**: High-priority issue without assignee
**Priority Labels**: `priority:high`, `urgent`, `P1`, `P0`, `critical`, `blocker`

**How to detect**: Check if `assignee` is null AND `labels` contain any priority keywords.

## Output Formats

### Project Health Summary

```markdown
## Project Health: [Project Name]

### Summary
- **Total Open Items**: X (Y issues, Z PRs)
- **At-Risk Items**: N
- **Health Score**: X%

### Risk Breakdown
- Critical: X
- Warning: Y
- Info: Z

### Overloaded Assignees (if any)
- @username: N assigned issues
```

### At-Risk Item Report

```markdown
## At-Risk: #[number] - [title]

**Severity**: [Critical | Warning | Info]
**Type**: [Issue | PR]
**URL**: [link]
**Assignee**: @username

### Risk Signals
- [signal type]: [description]

### Suggestions
- [actionable recommendation]
```

## Generating Suggestions

For each risk signal detected, provide actionable suggestions:

| Risk Type | Suggestion |
|-----------|-----------|
| Stale issue | "Comment with status update or close if no longer relevant" |
| Stale PR | "Request review or close if superseded" |
| Blocked | "Resolve blocking dependency or re-prioritize" |
| Deadline approaching | "Break into smaller milestones or adjust deadline" |
| Scope creep | "Split into smaller issues or create a tracking epic" |
| Unassigned high-priority | "Assign an owner immediately" |
| Overloaded assignee | "Redistribute work or adjust priorities" |

## Overloaded Assignee Detection

Track issue counts per assignee:
- Warning: > 7 assigned issues
- Critical: > 10 assigned issues

## Configuration Defaults

| Setting | Default | Description |
|---------|---------|-------------|
| staleDays | 14 | Days before issue is stale |
| prStaleReviewDays | 3 | Days before PR awaiting review is stale |
| deadlineWarningDays | 7 | Days before deadline to warn |
| maxCommentsBeforeScopeWarning | 30 | Comment threshold for scope creep |
| maxAssignedIssuesPerPerson | 10 | Max issues before overload warning |

## Example Workflows

### Morning Health Check

1. Use `list_github_issues` to fetch recent open issues
2. Apply all heuristics to each issue
3. Present health summary with risk breakdown
4. Highlight any critical items requiring immediate attention

### Individual Issue Assessment

1. Use `get_github_issue_with_comments` for the specific issue
2. Apply all heuristic checks
3. Present detailed risk analysis with signals and suggestions

### Pre-Sprint Cleanup

1. Fetch ALL open issues (comprehensive mode)
2. Apply all heuristics
3. Sort by severity (critical first)
4. Present full at-risk report
5. Suggest actions for each at-risk item

## Best Practices

1. **Daily Standups**: Run a quick health check to identify blockers
2. **Sprint Planning**: Use comprehensive mode to review full backlog
3. **Before Releases**: Check all deadline risks
4. **Assign Owners**: Address unassigned high-priority items immediately
5. **Break Down Scope**: Split large PRs (>500 lines) into smaller changes
