---
title: "SGAI Goal Authoring"
description: "Compose GOAL.md files for SGAI workspaces through interactive conversation"
---

Compose GOAL.md files for SGAI workspaces through interactive conversation. This skill detects your tech stack, selects the right developer and reviewer agents, and interviews you to build a complete goal file with an agent flow graph, model preferences, a completion gate, and outcome-based success criteria.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/claude-code-skills
/plugin install sgai-goal@britt
```

Or install all skills at once:

```bash
/plugin install claude-code-skills@britt
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

- Starting a new feature, project, or bug fix in a repository that uses SGAI
- Asked to "create a goal" or "set up SGAI"
- Describing work to be done in an SGAI-managed repo

The skill first checks for an `.sgai/` directory (or other SGAI configuration) and stops to confirm with you if it can't find one.

## Features

**Automatic tech stack detection**
Scans the repository for `go.mod`, `package.json`, `wrangler.toml`, `vercel.json`, and other indicators to choose the right developer and reviewer agent pairing — Go, React, HTMX, shell/CLI, Cloudflare Workers, Vercel, and Agent SDK stacks are all recognized, and multiple stacks combine into a single flow.

**Model preference memory**
Reads saved model preferences from `.sgai/preferences.json`, or asks once and saves the answer for future goals.

**Outcome-based success criteria**
Turns a plain description of the work into checklist-style success criteria that describe outcomes ("users can sign in with OAuth providers") rather than implementation steps.

**Agent flow graph composition**
Builds the `developer -> reviewer -> stpa-analyst` flow graph for the detected stack, always terminating in `stpa-analyst` for safety analysis except in pure documentation flows.

**Completion gate detection**
Infers a `completionGateScript` from the project's test tooling (`go test ./...`, `npm test`, `make test`) so SGAI knows how to verify the goal is done.

**Safe overwrite handling**
If a `GOAL.md` already exists, it is renamed to a timestamped backup before the new one is written — no work is lost.
