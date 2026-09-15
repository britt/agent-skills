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

1. **Identify meeting type** — determines the format, the focus areas, and which gather command to run in step 3.
2. **Fix the meeting period** — settle on a concrete `SINCE` date before running anything, because every gather command takes it as an argument. In order of preference: the date of the previous saved agenda (step 3), the date the user names, or a sensible default for the cadence (standup: yesterday; sprint planning and retro: the start of the sprint; check-in: the last check-in). State the period in the agenda so readers know what was and wasn't mined.
3. **Read the previous agenda** — see [Carryover](#carryover) below. Do this before gathering so the previous agenda's date can serve as `SINCE`.
4. **Gather context** — run the command for your meeting type from [Gathering Context](#gathering-context). Add any project notes the user points you at. If there is no repo, or `gh` is not authenticated, skip to asking the user for topics directly; do not present an empty agenda as if the period were quiet.
5. **Group by topic** — organize items logically, one agenda topic per theme rather than one per issue.
6. **Assign owners** — see [Owners](#owners) below.
7. **Estimate time** — see [Time Boxing](#time-boxing) below.
8. **Output agenda** — format using the template below, and save it per [Carryover](#carryover) so the next meeting has something to carry over from.

## Gathering Context

Requires the `gh` CLI authenticated to the repo. Substitute your `SINCE` date from step 2 (`YYYY-MM-DD`).

Three things go wrong if you improvise these commands, so do not drop the flags:

- **`--limit` is not optional.** `gh` defaults to 30 items and truncates the rest *silently* — no warning, no count. A repo with 54 PRs hands you 30 and looks complete.
- **`--state` must match the meeting.** `--state open` cannot return completed work, so a retrospective built from it reports nothing finished.
- **The `--json` field list is the whole dataset.** Fields you don't ask for are absent, not empty. Omit `assignees` and step 6 has nothing to assign from; omit `state` and you cannot tell a merged PR from an abandoned one.

Filter the period **server-side** with `--search`, so truncation can't eat the items you wanted:

```bash
# Work that moved during the period — retro, standup, check-in
gh issue list --state all --limit 200 --search "updated:>=$SINCE" \
  --json number,title,state,assignees,labels,milestone,updatedAt,closedAt,url
gh pr list --state all --limit 200 --search "updated:>=$SINCE" \
  --json number,title,state,isDraft,author,assignees,updatedAt,mergedAt,url
```

```bash
# Work that shipped during the period — retro's "what worked"
gh issue list --state closed --limit 200 --search "closed:>=$SINCE" \
  --json number,title,assignees,closedAt,url
```

```bash
# Upcoming work — sprint planning only. NOT period-filtered; see below.
gh issue list --state open --limit 200 \
  --json number,title,assignees,labels,milestone,updatedAt,url
```

**Do not period-filter the sprint planning backlog.** The period filter selects for recent activity, and an untouched backlog item is precisely what sprint planning exists to schedule. Filtering a 6-item backlog by "updated since the last meeting" can leave one item — all the candidates for the sprint get dropped for the crime of not having been discussed yet. Period-filter what *happened*; never period-filter what's *next*.

If the meeting type lists milestones as a source, confirm the repo actually uses them (`gh api repos/{owner}/{repo}/milestones --jq length`). Many don't. When there are none, fall back to labels, then to issue age, and say in the agenda which ordering you used — don't present an unordered backlog as a prioritized one.

## Owners

Assign each topic an owner by walking this chain and stopping at the first hit:

1. The issue's or PR's `assignees` (from the gather command's field list).
2. For a PR, its `author`. For an issue with no assignee, whoever opened it.
3. `[Name]` — a genuine placeholder for the organizer to fill in.

Reaching step 3 for every topic is a signal worth acting on, not a formatting quirk: it usually means the work is unassigned, and a table of identical `[Name]` cells tells the organizer nothing. When more than a couple of topics land on the placeholder, say so under the table in one line ("6 of 6 topics are unassigned — owners needed before the meeting") so it reads as a decision to make rather than a gap in the agenda.

## Time Boxing

1. Reserve the buffer first: 10–15% of the stated duration. A 60-minute meeting budgets 51–54 minutes of topics.
2. Allocate the remainder across topics, important items first.
3. **Add it up and check it.** Put the total in the table and compare it to the budget. The arithmetic is the point of the exercise — an agenda whose time boxes sum to 75 minutes for a 60-minute meeting has already failed, and nobody notices until the meeting is over.
4. If the topics don't fit, trim topics — never the buffer. Everything that doesn't fit goes under **Parking Lot**, with its owner, so it is visibly deferred rather than quietly dropped. The parking lot is also the natural source for the next meeting's agenda.

## Carryover

Carryover only works if the previous agenda is somewhere findable, so this skill states a convention rather than assuming one:

**Save each agenda to `docs/meetings/YYYY-MM-DD-<meeting-type>.md`** (e.g. `docs/meetings/2026-09-01-sprint-planning.md`). If the project already keeps meeting notes somewhere else, use that location instead — the requirement is a dated file per meeting type, not this exact path.

To pull carryover forward:

```bash
LAST=$(ls -1 docs/meetings/*-<meeting-type>.md 2>/dev/null | sort | tail -1)
[ -n "$LAST" ] && grep '^- \[ \]' "$LAST"
```

Every unchecked box becomes a carryover line in the new agenda; checked ones are done and stay behind. The grep is deliberately section-agnostic: it matches unchecked boxes in the previous agenda's **Carryover** section as well as its **Action Items**, so an item that has now been deferred twice keeps surfacing instead of ageing out silently. Deduplicate by text when carrying forward, and if a line has survived three agendas, flag it — it is either not really an action or it needs a different owner. The date embedded in `$LAST` is also the natural `SINCE` for step 2.

This requires the template's **Action Items** section: carryover is generated from the *previous* meeting's action items, so an agenda that records no action items produces nothing to carry over and the section is dead weight forever. If no previous file exists, say "no previous agenda found" under the heading rather than leaving it blank — blank reads as "nothing outstanding", which is a different and possibly false claim.

## Meeting Types

### Sprint Planning
- Focus: upcoming work, priorities, capacity
- Gather: the **upcoming work** command (unfiltered backlog); milestone items if the repo uses milestones
- Include: estimates, assignments, dependencies

### Retrospective
- Focus: what worked, what didn't, improvements
- Gather: the **shipped** command, plus the **moved** commands for context; incident notes and team feedback
- Include: wins to celebrate, problems to address

### Standup/Sync
- Focus: progress, blockers, today's priorities
- Gather: the **moved** commands with `SINCE` = the last standup, plus `git log --since="$SINCE" --oneline`
- Include: quick updates, blockers needing help

### Project Check-in
- Focus: overall status, risks, upcoming milestones
- Gather: the **moved** commands; filter PRs to `state == "MERGED"` for what shipped and `state == "OPEN"` for what's in flight
- Include: status summary, decisions needed, next steps

## Agenda Template

```markdown
## [Meeting Type] - [Date]

**Attendees**: [list or "team"]
**Duration**: [X minutes]
**Period covered**: [SINCE] to [Date]

### Topics

| Topic | Owner | Time |
|-------|-------|------|
| [Item] | [Name] | [5m] |
| **Buffer** | — | **[Xm]** |
| **Total** | | **[Xm of Y-minute meeting]** |

### Discussion Items

- **[Topic 1]**: [brief context] ([#123](link))
- **[Topic 2]**: [brief context]

### Carryover from Last Meeting

*From [docs/meetings/YYYY-MM-DD-<meeting-type>.md], or "no previous agenda found".*

- [ ] [Incomplete action item]

### Parking Lot

*Surfaced by the gather step but out of time box — candidates for next meeting.*

- [Deferred topic] — [Owner]

### Action Items

*Filled in during the meeting. This is what the next agenda carries over.*

- [ ] [Action] — [Owner]

### Notes

[Space for meeting notes]
```

## Best Practices

- Keep agendas focused (5-7 items max)
- Put important items early
- Include links to relevant issues/PRs — request `url` in the gather command so you have them
- Send agenda ahead of meeting when possible
- Save the agenda to its dated file even if the meeting is informal; an unsaved agenda breaks the next meeting's carryover
- State the period covered, so a quiet agenda reads as "nothing happened" rather than "nothing was checked"
