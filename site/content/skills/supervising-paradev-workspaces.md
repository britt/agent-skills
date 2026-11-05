---
title: "Supervising Paradev Workspaces"
description: "Dispatch a Paradev workspace per issue and supervise their PRs until every one has merged"
---

Run a small fleet of Paradev workspaces, one agent per issue, and keep their pull requests healthy until every one has merged. The supervisor never implements an issue: it dispatches workspaces, watches the open PRs with a bundled poller, unblocks them, and archives each workspace once its PR lands.

## Supported coding agents

| Coding agent | Supported |
|-------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

The skill drives the `paradev` and `gh` CLIs, so it needs to run where both are installed and authenticated. The watcher streams best under Claude Code's Monitor tool; elsewhere, re-run it with `ONCE=1`.

## How to use it

Use this skill when:

- Asked to dispatch workspaces for a list of issues and monitor them
- Asked to keep open PRs up to date with main, or to babysit them until they merge
- Asked to tell green PRs to merge, or to archive workspaces once their PRs merge

To start, name the issues and say which of these the supervisor may do: resolve conflicts, tell green PRs to merge, archive merged workspaces. Each is a separate permission.

A single issue is routed to `working-on-an-issue`, and the child issues of one epic to `working-on-an-epic`, which builds stacked PRs and never merges or archives.

## Features

**Look before you create**
Each issue is checked for an existing PR first. If one already implements it, the dispatched agent is told to finish that branch rather than start a duplicate. Every workspace is named `Issue N` so the watcher can find its owner.

**One line per new event**
`scripts/pr-watcher.sh` polls the repo's open PRs and prints a line only when something new happens: `BEHIND`, `CONFLICT`, `CI_FAILED_OR_BLOCKED`, or `MERGED`. Each (PR, head, base, state) is reported once. When a PR falls behind, the watcher finds the owning workspace's agent terminal and tells it to merge the base branch itself.

**Scoped to the right fleet**
Every `paradev` call carries `--local` or `--host`. Unscoped, an account that has cloud workspaces would list and archive the cloud fleet instead of the one being supervised, so the watcher never leaves the scope to a default.

**Conflicts resolved by intent**
Conflicts are resolved in a separate git worktree, keeping both sides of appended lists, renumbering colliding numbered docs against every other open PR, and never discarding the base's side or force-pushing. The owner is told to pull afterwards.

**Careful archiving**
A workspace is archived only when a PR naming its issue merged after the workspace was created, and no other open PR still names the issue (a stacked series). A PR that merely mentions the issue never counts, and a failed GitHub lookup never archives. Archiving removes the worktree and anything uncommitted in it, so it waits for the merge. `DRY_RUN=1` shows what would happen without messaging or archiving anything.

**Optional subagent**
`agents/paradev-fleet-supervisor.md` is a Claude Code subagent definition that runs the whole loop out of the main conversation. Copy it into `.claude/agents/` to use it.
