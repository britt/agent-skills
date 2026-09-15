---
title: "Working on an Epic"
description: "Coordinate an epic through parallel Conductor workspaces, one per child issue"
---

Drive a GitHub epic from one Conductor session without implementing any of it yourself: the coordinator reads the epic, maps the dependencies between child issues, spawns a separate Conductor cloud workspace per child running `working-on-an-issue`, watches them to completion, and reports back on the epic with every PR, deep link, and required merge order.

### Installation

Add the marketplace and install this skill:

```bash
/plugin marketplace add britt/agent-skills
/plugin install working-on-an-epic@britt
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

The skill drives the `conductor` CLI, so it needs to run where that CLI is installed and authenticated: a Conductor cloud workspace, or a local session with a Conductor API token.

## How to use it

Use this skill when:

- Asked to work on, implement, or drive an epic, parent issue, or tracking issue
- The work is split into child issues (GitHub sub-issues, a task list of `#N` references, or issues marked "Part of #epic")
- `conductor auth whoami` succeeds on the machine

To start, provide the epic URL or number.

Before proceeding, the agent confirms the pre-flight checklist:

- Epic URL or number obtained
- `conductor` CLI authenticated and `gh` logged in
- Running inside a Conductor workspace (or a `--repo-url` to pass)

An epic with no child issues is routed to `issue-decomposition` first. A single non-epic issue is routed to `working-on-an-issue`. If `conductor` is unavailable the agent stops and says so rather than implementing the children serially itself.

## Features

**One workspace per child, never sessions sharing a checkout**
Every child issue gets its own Conductor workspace, branch, and session, created with `conductor workspace create` and an opening message that tells it to use `working-on-an-issue`. Sessions inside one workspace would share a branch and clobber each other, so the skill forbids that topology.

**Dependency waves and stacked PRs**
`Blocked by` and `Depends on` signals in the child issues build waves. Independent children start immediately, up to a concurrency cap of four. A dependent child starts only when its blocker's PR is open and its branch is on origin, and it is created from that branch with a PR stacked on it, so the epic does not stall waiting for a human to merge.

**Stopped is not done**
Children end with a machine-readable `EPIC-CHILD-DONE` or `EPIC-CHILD-BLOCKED` line. A background poll loop watches `conductor session status`; when a session leaves `working`, the transcript tail is classified rather than assumed complete, and every `done` is cross-checked with `gh pr view`.

**Answer how, escalate what**
When a child stops with a question, the coordinator answers "how" questions from the epic thread and repo conventions and logs the decision. Product or scope questions are never invented; the child is told to implement only what the issue states and list the open question in the PR.

**Never merges, reports honestly**
The PR is each child's approval gate, exactly as in `working-on-an-issue`. The final comment on the epic lists every child's PR, base branch, CI state, Conductor deep link, and required merge order, and names any child that was skipped, blocked, or failed instead of summarising it away. Child workspaces are left alive for reviewers.
