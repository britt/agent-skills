---
name: consolidate-notes-summary
description: "Search project notes by topic, synthesize findings into a consolidated summary with cross-references"
instructions: "When consolidating notes on a topic, synthesizing findings across multiple notes, or creating a summary from scattered project notes"
tags:
  - notes
  - consolidate
  - summary
  - synthesis
  - knowledge
---

# Consolidate Notes Summary Skill

Search project notes by topic or tag and produce a consolidated summary that synthesizes information across multiple sources.

## When to Use

Activate when:
- Gathering scattered knowledge on a topic
- Preparing a summary from multiple note sources
- Reviewing what's been documented about a subject
- Identifying gaps in documentation

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
