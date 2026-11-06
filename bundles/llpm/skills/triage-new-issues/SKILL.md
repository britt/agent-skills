---
name: triage-new-issues
description: "Use when processing new or untriaged GitHub issues - assesses urgency from keyword and label signals, assigns P0-P3 priority, suggests labels and assignees, and flags issues needing escalation or clarification"
---

# Triage New Issues Skill

Review new or untriaged GitHub issues, assess priority based on urgency signals, suggest labels, and recommend owners.

## When to Use

Activate when:
- Processing new incoming issues
- Reviewing untriaged backlog
- Assessing issue priority
- Assigning issues to owners

## Fetching and Applying Triage

Use the `gh` CLI (must be installed and authenticated):

```bash
# Find untriaged issues
gh issue list --search 'no:label' --json number,title,body,labels

# Apply labels after triage
gh issue edit <n> --add-label <label>
```

## Priority Signals

### Critical (P0)
**Keywords**: "down", "outage", "security", "vulnerability", "production", "urgent", "ASAP", "breach"
**Labels**: `critical`, `security`, `production`
**Action**: Immediate attention required

### High (P1)
**Keywords**: "blocking", "regression", "broken", "can't use", "data loss", "crash"
**Labels**: `blocker`, `regression`, `priority/high`
**Action**: Address this sprint

### Medium (P2)
**Keywords**: "bug", "incorrect", "should", "expected", "wrong"
**Labels**: `bug`, `priority/medium`
**Action**: Schedule for upcoming sprint

### Low (P3)
**Keywords**: "nice to have", "minor", "cosmetic", "enhancement", "workaround exists"
**Labels**: `enhancement`, `low-priority`
**Action**: Add to backlog

## Triage Guidelines

### Assessment Process

1. Read title and full description
2. Scan for urgency keywords and labels
3. Check for existing labels that signal priority
4. Assess impact (how many users affected)
5. Look for workarounds mentioned
6. Check if duplicate of existing issue
7. Determine ownership: check CODEOWNERS, recent `git log` on affected paths, or past assignees of similar issues — omit the assignee suggestion if none found

### When to Escalate

- Security vulnerabilities → Flag immediately
- Production outages → Notify on-call
- Data integrity issues → High priority regardless of other signals

### When to Ask Questions

- Unclear reproduction steps
- Missing environment details
- Ambiguous severity ("it's broken" but unclear impact)
- No indication of urgency or timeline

### Red Flags

- Issues with no response from author (>7 days)
- Duplicate of closed/wontfix issue
- Feature request disguised as bug
- Missing required information from template

## Output Structure (per issue)

```markdown
## Triage: #[number] — [title]

### Priority Assessment

**Urgency**: [Critical | High | Medium | Low]
**Impact**: [Wide | Moderate | Limited]
**Recommended Priority**: P[0-3]

| Signal | Indicator |
|--------|-----------|
| [Keyword/label found] | [What it suggests] |

### Classification

**Type**: [Bug | Feature | Question | Task]
**Area**: [Component or area affected]
**Suggested Labels**: `priority/high`, `bug`, `area/auth`
**Suggested Assignee**: @username — based on CODEOWNERS, git history, or similar past issues (omit if no owner found)

### Assessment

[Summary of the issue and reasoning for priority assignment]

### Clarifying Questions (if needed)

- [ ] [Question to understand severity]

### Recommendation

[Immediate action | Next sprint | Backlog | Needs info | Duplicate of #X]
```
