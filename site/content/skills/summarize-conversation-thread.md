---
title: "Summarize Conversation Thread"
description: "Summarize GitHub issue and PR threads into key decisions, action items, and next steps"
---

Read long GitHub issue or PR threads and produce concise summaries highlighting what matters. This skill extracts key decisions, action items with owners, open questions, and next steps from lengthy discussions so you can catch up quickly or prepare to contribute.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install summarize-conversation-thread@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Platform | Supported |
|----------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- Catching up on a lengthy issue or PR discussion
- Preparing to contribute to an existing thread
- Extracting decisions from a closed issue
- Identifying action items and owners from a conversation

## Features

**Structured summary output**
Produces a TL;DR, key decisions with who made them, action items with owners, open questions, and concrete next steps in a consistent format.

**Signal over noise**
Skips redundant "+1" comments, off-topic tangents, superseded proposals, and resolved sub-discussions to focus on what actually matters.

**Edge case handling**
Flags stale threads where decisions may be outdated, presents heated discussions neutrally, clearly states when no decision was reached, and breaks long threads into phases.

**Decision attribution**
Links each key decision to who made it and provides context, making it easy to follow up or understand the reasoning behind choices.
