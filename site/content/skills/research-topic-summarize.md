---
title: "Research Topic and Summarize"
description: "Research topics via web search, synthesize detailed summaries with sources and screenshots"
---

Conduct thorough web research on a topic, synthesize findings into a detailed summary, and capture screenshots of key visuals. This skill produces research reports with background context, key findings, comparisons, source citations, and actionable recommendations.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install research-topic-summarize@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Evaluating a technology, library, or tool
- Learning about a new concept or pattern
- Comparing options (X vs Y) to make a decision
- Gathering background information for a technical or business decision

Skip it for questions answerable directly from local docs or code, and prefer a dedicated deep-research capability (if available) for deep, multi-source fact-checked reports.

## Features

**Structured research output**
Produces reports with summary, background, key findings, comparisons, visual references, sources, analysis of strengths and weaknesses, and an actionable recommendation.

**Source quality emphasis**
Prefers official documentation over blog posts, notes publication dates, flags outdated information, and cites sources for all claims with a minimum of three to five quality sources.

**Screenshot capture**
Captures screenshots of architecture diagrams, comparison tables, pricing matrices, UI examples, and code samples when visual context adds value.

**Decision-ready analysis**
Provides enough detail to make decisions without re-reading original sources, including specific numbers, versions, dates, and notes on conflicting information.
