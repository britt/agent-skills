---
title: "Working on an Epic"
description: "Coordinate an epic through parallel agent workspaces, one per child issue"
---

Drive a GitHub epic from one coordinating session without implementing any of it yourself: the coordinator reads the epic, maps the dependencies between child issues, spawns a separate agent workspace per child running `working-on-an-issue`, watches them to completion, and reports back on the epic with every PR, deep link, and required merge order.

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

The skill drives the `paradev` CLI and the `gh stack` extension, so it needs to run where both are installed and authenticated — inside a Paradev workspace, or in a local session signed in to Paradev.

## How to use it

Use this skill when:

- Asked to work on, implement, or drive an epic, parent issue, or tracking issue
- The work is split into child issues (GitHub sub-issues, a task list of `#N` references, or issues marked "Part of #epic")
- `paradev auth whoami` succeeds on the machine

To start, provide the epic URL or number.

Before proceeding, the agent confirms the pre-flight checklist:

- Epic URL or number obtained
- `paradev` CLI authenticated and `gh` logged in
- Running inside a Paradev workspace (`SUPERSET_WORKSPACE_ID` set), or a known project id to create children under

An epic with no child issues is routed to `issue-decomposition` first. A single non-epic issue is routed to `working-on-an-issue`. If `paradev` is unavailable the agent stops and says so rather than implementing the children serially itself.

## Features

**One workspace per child, never sessions sharing a checkout**
Every child issue gets its own workspace, branch, and session, created with `paradev workspaces create` and an opening prompt that tells it to use `working-on-an-issue`. Sessions inside one workspace would share a branch and clobber each other, so the skill forbids that topology.

**Dependency waves and GitHub stacked PRs**
`Blocked by` and `Depends on` signals in the child issues form chains. Standalone children start immediately, up to a concurrency cap of four. Each chain is built bottom-up: the next child starts only when the one below it has a verified PR and its branch is on origin, and it is created from that branch so the epic does not stall waiting for a human to merge. The coordinator links each chain with `gh stack link` into one GitHub stack that the reviewer can land atomically with `gh stack merge`. Standalone PRs are never stacked, a child with two blockers has its whole component linearised into one chain, and no child ever rebases onto a sibling.

**Stopped is not done**
Children end with a machine-readable `EPIC-CHILD-DONE` or `EPIC-CHILD-BLOCKED` line. A background poll loop watches each agent's state with `paradev agents explain`; when a session leaves `working`, the transcript tail is classified rather than assumed complete, and every `done` is cross-checked with `gh pr view`.

**Answer how, escalate what**
When a child stops with a question, the coordinator answers "how" questions from the epic thread and repo conventions and logs the decision. Product or scope questions are never invented; the child is told to implement only what the issue states and list the open question in the PR.

**Never merges, reports honestly**
The PR is each child's approval gate, exactly as in `working-on-an-issue`. The final comment on the epic lists every child's PR, base branch, CI state, Paradev deep link, and stack number with the one-line `gh stack merge` instruction per chain, and names any child that was skipped, blocked, or failed instead of summarising it away. Child workspaces are left alive for reviewers.
