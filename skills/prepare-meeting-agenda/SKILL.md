---
name: prepare-meeting-agenda
description: "Generate meeting agendas from recent issues, PRs, and notes for sprint planning, retros, and standups"
instructions: "When preparing a meeting agenda, planning a sprint review, organizing a retro, or setting up a standup"
tags:
  - meeting
  - agenda
  - planning
  - sprint
  - retro
  - standup
---

# Prepare Meeting Agenda Skill

Generate structured meeting agendas by gathering context from recent project activity.

## When to Use

Activate when preparing for:
- Sprint planning sessions
- Retrospectives
- Standups or syncs
- Project check-ins
- Any recurring team meeting

## Workflow

1. **Identify meeting type** - Determine format and focus areas
2. **Gather context** - Search recent issues, PRs, and notes
3. **Group by topic** - Organize items logically
4. **Assign owners** - Note who should speak to each item
5. **Estimate time** - Allocate realistic durations
6. **Output agenda** - Format using template below

## Meeting Types

### Sprint Planning
- Focus: upcoming work, priorities, capacity
- Sources: backlog issues, milestone items
- Include: estimates, assignments, dependencies

### Retrospective
- Focus: what worked, what didn't, improvements
- Sources: completed issues, incident notes, team feedback
- Include: wins to celebrate, problems to address

### Standup/Sync
- Focus: progress, blockers, today's priorities
- Sources: in-progress issues, recent commits
- Include: quick updates, blockers needing help

## Agenda Template

```markdown
## [Meeting Type] - [Date]

**Attendees**: [list or "team"]
**Duration**: [X minutes]

### Topics

| Topic | Owner | Time |
|-------|-------|------|
| [Item] | [Name] | [5m] |

### Discussion Items

- **[Topic 1]**: [brief context]
- **[Topic 2]**: [brief context]

### Carryover from Last Meeting

- [ ] [Incomplete action item]

### Notes

[Space for meeting notes]
```

## Best Practices

- Keep agendas focused (5-7 items max)
- Allocate buffer time (10-15% of meeting)
- Put important items early
- Include links to relevant issues/PRs
- Send agenda ahead of meeting when possible
