---
title: "Working on an Epic"
description: "Coordinate an epic through parallel agent workspaces, one per child issue"
---

Drive a GitHub epic from one coordinating session without implementing any of it yourself: the coordinator reads the epic, maps the dependencies between child issues, spawns a separate agent workspace per child running `working-on-an-issue`, watches them to completion, and reports back on the epic with every PR, workspace link, and required merge order.

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

The skill names no workspace tool. It needs the `gh` CLI with the `gh stack` extension, and some way to give each child its own git worktree, branch, and agent — a workspace manager if the machine has one, or plain `git worktree` plus a background agent process if it does not.

## How to use it

Use this skill when:

- Asked to work on, implement, or drive an epic, parent issue, or tracking issue
- The work is split into child issues (GitHub sub-issues, a task list of `#N` references, or issues marked "Part of #epic")
- Each child can be given its own isolated workspace

To start, provide the epic URL or number.

Before proceeding, the agent confirms the pre-flight checklist:

- Epic URL or number obtained
- A workspace runner bound and probed, and `gh` logged in with the `gh stack` extension present
- Whether the runner can deliver messages to a running child, which decides whether questions are answered mid-flight or reported at the end

An epic with no child issues is routed to `issue-decomposition` first. A single non-epic issue is routed to `working-on-an-issue`. If no runner can be bound, the agent stops and says so rather than implementing the children serially itself.

## Features

**Tool specifics confined to one step**
The skill opens by binding seven shell functions — create a workspace, find its agent, read its branch, check whether it is busy, read its transcript, send it a message, link to it — to whatever workspace manager this machine has, with a plain `git worktree` fallback. Every later step calls those functions, so the process reads identically whichever tool is underneath, and a raw tool command outside the binding step is a bug.

**One workspace per child, never agents sharing a checkout**
Every child issue gets its own workspace, branch, and agent, with an opening prompt that tells it to use `working-on-an-issue`. Two agents inside one workspace would share a branch and clobber each other, so the skill forbids that topology. Branch names are read back after creation, since runners commonly namespace them under a project prefix.

**Dependency waves and GitHub stacked PRs**
`Blocked by` and `Depends on` signals in the child issues form chains. Standalone children start immediately, up to a concurrency cap of four. Each chain is built bottom-up: the next child starts only when the one below it has a verified PR and its branch is on origin, and it is created from that branch so the epic does not stall waiting for a human to merge. The coordinator links each chain with `gh stack link` into one GitHub stack that the reviewer can land atomically with `gh stack merge`. Standalone PRs are never stacked, a child with two blockers has its whole component linearised into one chain, and no child ever rebases onto a sibling. Linearity is verified with `git rev-list` and `git rev-parse`, not the PR page.

**Stopped is not done**
Children end with a machine-readable `EPIC-CHILD-DONE` or `EPIC-CHILD-BLOCKED` line. A background poll loop normalises every runner's state vocabulary down to busy, stopped, or gone; when a child stops, the transcript tail is classified rather than assumed complete, and every `done` is cross-checked with `gh pr view`.

**Answer how, escalate what**
When a child stops with a question, the coordinator answers "how" questions from the epic thread and repo conventions and logs the decision. Product or scope questions are never invented; the child is told to implement only what the issue states and list the open question in the PR. Where the runner cannot message a running child, questions are recorded and reported rather than guessed at — and never resolved by the coordinator doing the work itself.

**Never merges, reports honestly**
The PR is each child's approval gate, exactly as in `working-on-an-issue`. The final comment on the epic lists every child's PR, base branch, CI state, workspace link, and stack number with the one-line `gh stack merge` instruction per chain, and names any child that was skipped, blocked, asking, or failed instead of summarising it away. Child workspaces are left alive for reviewers.
