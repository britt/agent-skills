---
title: "Working on an Issue"
description: "Hands-off implementation of GitHub issues, reviewed at the PR"
---

Implement a GitHub issue end to end through this hands-off sequence: Understand → Update project status → Recon → Plan verification → Plan implementation → Implement → Verify → PR. No mid-flow approval gates interrupt the sequence; the pull request is the single review point for the completed work, assumptions, and verification results.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install working-on-an-issue@britt
```

Or install all skills at once:

```bash
/plugin install agent-skills@britt
```

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:

- Asked to work on or implement a GitHub issue
- Given an issue URL or issue number

To start, provide the issue URL or number.

Before proceeding, the agent confirms the pre-flight checklist:

- Issue URL or number obtained
- Repository cloned and a work branch created (`issue-<number>-<short-slug>`)
- `CLAUDE.md` exists (or run `setting-up-a-project` first)

Not every issue qualifies. Epic-sized issues that bundle independent changes are routed to `issue-decomposition` first, and issues too vague to restate as testable acceptance criteria are routed to `requirement-elicitation` instead of being implemented on guesswork.

## Features

**Updates linked GitHub Projects automatically**
Before recon starts, the agent checks the issue's membership in every linked GitHub Project (v2) through the GraphQL API. For each linked project, it uses the most plausible in-progress-style status when one exists, so every project board reflects that work has begun. Missing project membership, unavailable membership data, missing project scope, an unmatched status option, or another update failure becomes a non-blocking caveat, and the agent continues.

**Hands-off by default — the PR is the approval gate**
There are no approval checkpoints during the work. Plans are saved to `docs/plans/issue-<number>-plan.md` and implementation proceeds immediately; the developer reviews the finished work on the pull request, where every assumption and verification result is recorded.

**Scoped reconnaissance with a hard budget**
Exploration exists to locate the change, not to understand the codebase. The agent starts from identifiers the issue names, expands at most one hop, and stops as soon as it knows which files change, which pattern to follow, and which tests cover the area. If about ten targeted searches don't produce that list, the issue is treated as underspecified and sent back rather than explored harder.

**Verification-first planning**
The verification plan (via `writing-verification-plans`) is written before the implementation plan, because acceptance criteria define done. After implementation the plan is executed and the results are logged; a PR is never opened with failing verification, and failures are root-caused with systematic debugging rather than patched over.

**Assumptions documented, scope protected**
Ambiguity is resolved with the narrowest interpretation and recorded in the plan and PR — but assumptions may only resolve *how*, never shrink *what* the issue asks for. `Fixes #<number>` is used only when every named request is addressed; anything split out or deferred is flagged with `Refs #<number>` instead.

**Clear stop conditions**
When genuinely blocked — missing credentials, contradictory requirements — the agent comments on the issue and stops instead of guessing through it.
