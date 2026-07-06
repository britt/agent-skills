---
name: consolidate-notes-summary
description: "Use when knowledge on a topic is scattered across multiple project notes and someone asks to consolidate, synthesize, or summarize what has been documented - searches notes by topic and produces a single summary with key points, timeline, cross-references, and documentation gaps"
---

# Consolidate Notes Summary Skill

Search project notes by topic or tag and produce a consolidated summary that synthesizes information across multiple sources.

Notes location: check for a `notes/` or `docs/notes/` directory, a vault path noted in CLAUDE.md, or ask the user; search with Grep across that directory.

## When to Use

Activate when:
- Gathering scattered knowledge on a topic
- Preparing a summary from multiple note sources
- Reviewing what's been documented about a subject
- Identifying gaps in documentation

**When NOT to use**: single-note summarization (just read it), or consolidating code documentation rather than notes.

## Workflow

1. Locate the notes directory (see notes location above); confirm with the user if ambiguous.
2. Search by topic or tag with Grep across the directory, including synonyms, abbreviations, and related terms (e.g. "auth" as well as "authentication", tag forms like `#auth`). Case-insensitive matching catches more hits.
3. Read the matching notes, capturing dates, authors, and key claims from each.
4. Synthesize the findings per the Synthesis vs. Aggregation guidelines below — combine, don't concatenate.
5. Emit the output template, filling every section and flagging anything you could not determine.

If the search returns nothing, widen terms once before reporting back; if it still finds nothing, say so plainly and list the terms tried rather than fabricating a summary.

## Output Structure

```markdown
## Consolidated: [Topic]

**Sources**: [X notes reviewed] | **Date Range**: [earliest] to [latest]

### Summary

[Synthesized overview combining insights from all related notes]

### Key Points

- [Point 1] — from [note reference]
- [Point 2] — from [note reference]
- [Point 3] — from [note reference]

### Timeline

| Date | Event/Decision |
|------|----------------|
| [Date] | [What happened] |

### Cross-References

- **[Note 1 title]**: [how it relates to the topic]
- **[Note 2 title]**: [how it relates]

### Gaps

- [Information that's missing]
- [Topics that need more documentation]
- [Outdated content that needs refresh]
```

## Guidelines

### Synthesis vs. Aggregation

- **Do synthesize**: Combine related points into coherent insights
- **Don't just list**: Avoid copy-pasting from each note sequentially
- **Find patterns**: Identify themes across notes
- **Resolve conflicts**: Note when sources disagree

### Attribution

- Reference source notes for key points
- Include note titles or IDs for traceability
- Preserve original authors when known

### Quality Checks

- Flag stale information (notes > 6 months old)
- Note contradictions between notes
- Identify outdated decisions that may need revisiting
- Highlight frequently referenced topics

### Handling Large Sets

- Group notes by subtopic if > 10 notes
- Prioritize recent notes over old ones
- Summarize in layers (overview → details)
