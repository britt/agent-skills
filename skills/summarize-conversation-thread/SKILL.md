---
name: summarize-conversation-thread
description: "Use when catching up on a long GitHub issue or PR discussion thread, or asked to summarize a thread, extract key decisions, or list action items - produces a structured summary with TL;DR, decisions, action items, open questions, and next steps"
---

# Summarize Conversation Thread Skill

Read long GitHub issue or PR threads and produce concise summaries highlighting what matters.

## When to Use

Activate when:
- Catching up on a lengthy discussion
- Preparing to contribute to an existing thread
- Extracting decisions from a closed issue
- Identifying action items from a discussion

**When NOT to use:** Skip for short threads (fewer than ~5 comments) — just read them directly.

## Getting the Thread

First, obtain the full thread content:

- **Issues**: `gh issue view <number> --comments` (requires the `gh` CLI, authenticated)
- **PRs**: `gh pr view <number> --comments`
- **No gh CLI or no repo access**: Ask the user to paste the thread content

## Output Structure

```markdown
## Summary: [Issue/PR Title]

**Status**: [Open/Closed] | **Comments**: [X] | **Last Activity**: [date]

### TL;DR

[2-3 sentence summary of the core discussion]

### Key Decisions

- **[Decision]**: [context and who decided]

### Action Items

- [ ] [Action] — @[owner]

### Open Questions

- [Unresolved question needing input]

### Next Steps

[What should happen next]
```

## Guidelines

### What to Include

- Decisions made and who made them
- Action items with clear owners
- Unresolved questions or blockers
- Changes in direction or scope
- Links to key comments

### What to Skip

- Redundant "+1" or "me too" comments
- Off-topic tangents
- Superseded proposals
- Resolved sub-discussions

### Handling Edge Cases

- **Stale threads** (>30 days inactive): Note this and flag if decisions may be outdated
- **Heated discussions**: Present all perspectives neutrally
- **No resolution**: Clearly state "No decision reached" and summarize options discussed
- **Long threads** (50+ comments): Break into phases if discussion evolved significantly

## Example

```markdown
## Summary: Add dark mode support (#142)

**Status**: Open | **Comments**: 23 | **Last Activity**: 2 days ago

### TL;DR

Team agreed to implement dark mode using CSS variables. Debate on whether to auto-detect system preference or default to light mode resolved in favor of auto-detect.

### Key Decisions

- **Use CSS variables**: Easier to maintain than separate stylesheets — @sarah
- **Auto-detect system preference**: Better UX, users can override — @mike

### Action Items

- [ ] Create color token system — @sarah
- [ ] Add toggle to settings page — @alex

### Next Steps

Sarah to submit initial PR with color variables by Friday.
```
