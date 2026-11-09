---
name: research-topic-summarize
description: "Use when asked to research a technology, library, or concept via web search, compare options (X vs Y), or gather background for a decision - synthesizes findings into a cited summary with comparison tables, screenshots of key visuals, and a recommendation"
---

# Research Topic and Summarize Skill

Conduct thorough web research on a topic, synthesize findings into a detailed summary, and capture screenshots of key visuals.

## Prerequisites

- **Web search/fetch access** is required for the core research loop.
- **Screenshots require a browser automation tool** (e.g. Playwright MCP). If none is available, do not fake images — link to the visual's source URL and describe it in text instead of embedding an image.

## When to Use

Activate when:
- Evaluating a technology, library, or tool
- Learning about a new concept or pattern
- Comparing options (X vs Y)
- Gathering background for a decision

**When NOT to use:** For deep, multi-source fact-checked reports, prefer a dedicated deep-research capability if one is available. Skip entirely for questions answerable from local docs or code — read those directly.

## Output Structure

```markdown
## Research: [Topic]

### Summary

[Paragraph overview - what it is, why it matters, current state]

### Background

[Context, history, or foundational concepts needed to understand the topic]

### Key Findings

#### [Finding 1 Title]

[Detailed explanation with specifics, numbers, examples]

#### [Finding 2 Title]

[Detailed explanation with evidence from sources]

### Comparisons

| Aspect | Option A | Option B |
|--------|----------|----------|
| [Criteria] | [Detail] | [Detail] |

### Visual References

- ![Description](research-assets/screenshot-1.png) — [what this shows]
- ![Description](research-assets/screenshot-2.png) — [what this shows]

### Sources

1. [Title](url) — [what this source contributed]
2. [Title](url) — [what this source contributed]

### Analysis

- **Strengths**: [detailed pros]
- **Weaknesses**: [detailed cons]
- **Gaps**: [what the research didn't answer]

### Recommendation

[Actionable conclusion with reasoning]
```

## Research Guidelines

### Depth of Coverage

- Provide enough detail to make decisions without re-reading sources
- Include specific numbers, versions, dates when relevant
- Explain concepts, don't just name them
- Note conflicting information across sources

### Source Quality

- Prefer official documentation over blog posts
- Note publication dates (flag outdated info)
- Cite sources for all claims
- Include 3-5 quality sources minimum

### Screenshots

Capture screenshots when sources include:
- Architecture or flow diagrams
- Comparison tables
- Pricing or feature matrices
- UI examples (if evaluating tools)
- Code examples that benefit from visual context

### Screenshot Best Practices

- Save screenshots to a `research-assets/` directory alongside the summary file
- Reference images in the summary with relative paths into that directory, e.g. `![Comparison](research-assets/redis-vs-memcached-comparison.png)`
- Use descriptive filenames: `redis-vs-memcached-comparison.png`
- Always include alt text descriptions
- Capture only relevant portions, not full pages
- Note the source URL in the description
