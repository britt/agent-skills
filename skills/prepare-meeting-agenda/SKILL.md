---
name: prepare-meeting-agenda
description: "Use when preparing an agenda for sprint planning, a retrospective, standup or sync, or a project check-in - gathers context from recent issues, PRs, and notes, groups topics, assigns owners and time boxes, and outputs a structured agenda"
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

**When NOT to use**: not for taking minutes during or after a meeting, or one-off external meetings with no project activity to mine.

## Workflow

1. **Identify meeting type** - Determine format and focus areas
2. **Gather context** - Requires the `gh` CLI authenticated to the repo. Run `gh issue list --state open --json number,title,labels,updatedAt` and `gh pr list --state all --json number,title,updatedAt`, filtered to the meeting period (e.g. items updated since the last meeting), plus any project notes. If no repo is available, ask the user for topics.
3. **Group by topic** - Organize items logically
4. **Assign owners** - Assign owners from issue/PR assignees when available; otherwise leave [Name] placeholders for the organizer
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

### Project Check-in
- Focus: overall status, risks, upcoming milestones
- Sources: milestone progress, recently merged PRs, open blockers
- Include: status summary, decisions needed, next steps

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
- Carry over unfinished action items from the previous agenda so they are not lost
- If gathered context surfaces more topics than fit the time box, list the overflow under a "Parking Lot" heading rather than dropping it
- Match total topic time to the stated meeting duration; trim topics before trimming the buffer
