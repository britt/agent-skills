---
title: "Consolidate Notes Summary"
description: "Search project notes by topic, synthesize findings into a consolidated summary with cross-references"
---

Search project notes by topic or tag and produce a consolidated summary that synthesizes information across multiple sources. Instead of simply listing what each note says, this skill combines related points into coherent insights with cross-references and gap analysis.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install consolidate-notes-summary@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
```

## Compatibility

## Supported agents

| Agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Gathering scattered knowledge on a topic across multiple notes
- Preparing a summary from multiple note sources
- Reviewing what has been documented about a subject
- Identifying gaps in project documentation

## Features

**Synthesis over aggregation**
Combines related points into coherent insights rather than copy-pasting from each note sequentially, finding patterns and themes across sources.

**Cross-references and attribution**
References source notes for key points with titles or IDs for traceability, preserving original authors when known.

**Timeline and gap detection**
Includes a chronological timeline of events and decisions, and identifies missing information, outdated content, and topics needing more documentation.

**Conflict resolution**
Flags contradictions between notes and highlights stale information from older sources that may need revisiting.
