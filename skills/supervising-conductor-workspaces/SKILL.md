---
name: supervising-conductor-workspaces
description: Use when asked to dispatch Conductor workspaces for a list of issues and then watch them until their PRs merge - "dispatch workspaces for issues 310-315 and monitor them", "keep the open PRs up to date with main", "tell green PRs to merge", "archive workspaces once their PR merges", "babysit the open PRs". Spins up one Conductor workspace per issue, runs a poller over the repo's open PRs, nudges owning agents when their PR falls behind the base branch, resolves merge conflicts, reruns transient CI failures, tells green PRs to merge, and archives each workspace once its PR lands. Not for implementing a single issue or coordinating the children of one epic. Works for any GitHub repo; uses the conductor and gh CLIs.
metadata:
  version: "1.0.0"
---

# Supervising Conductor Workspaces

**Announce at start:** "I'm using the supervising-conductor-workspaces skill to dispatch and supervise these workspaces."

## Overview

Run a small fleet of Conductor workspaces (one agent per issue) and keep their pull requests healthy until every one has merged. You are the **supervisor**: you do not implement the issues. You dispatch, watch, unblock, and clean up.

**Core principle:** Dispatch → Watch → Unblock → Finish. Every action that touches someone else's branch, merges, or archives needs the user's say-so for *this* fleet.

Needs: `conductor` CLI (authenticated), `gh` CLI (authenticated for the repo), `jq`, and the Monitor tool (or a loop you re-run) to stream watcher events.

## When to Use

- "Dispatch workspaces for issues 310–315 and monitor them"
- "Keep these PRs up to date with main", "babysit the open PRs"
- "Tell the green ones to merge", "archive the workspaces once their PRs merge"
- A list of issues — related or not — each worked by its own Conductor workspace, supervised until merged

## When NOT to Use

- Implementing one issue yourself → `working-on-an-issue` (that is what each dispatched workspace runs)
- Coordinating the child issues of **one epic** (dependency chains, stacked PRs, a report on the epic, never merging) → `working-on-an-epic`
- `conductor` is missing or not authenticated → stop and say so; do not implement the issues serially yourself

## Key Principles

| Principle | Meaning |
| --- | --- |
| Supervise, don't implement | Each issue is implemented by its own workspace. You message owners; you edit a branch only to resolve a conflict you were allowed to resolve |
| Ask once per grant | Each row in the authorization table is a separate permission. One grant never implies another |
| Look before you create | Check for existing PRs and workspaces before dispatching; never start a duplicate implementation |
| React to events, don't poll | The watcher prints one line per new event; you act on lines, not on a sleep loop of your own |
| `BLOCKED` is not failing | It is usually CI still running. Act only on a check that says `fail` |
| GitHub is the source of truth | An agent saying "done" is not a merge; `gh pr view` is |
| Report faithfully | A rerun that passed is "rerun, passed", not "fixed" |

## Authorization — read first

Each action below needs the user's say-so. Don't extend one grant to another.

| Action | Needs |
| --- | --- |
| Create workspaces for named issues | The user named the issues |
| Message an agent to merge the base branch into its PR | Implied by "keep them up to date" |
| Resolve a conflict and push a merge commit to someone's branch | The user said to resolve conflicts |
| Tell an agent to merge a green PR | An explicit instruction ("tell green ones to merge"). Treat as standing for this fleet only if the user said so; otherwise ask once |
| Merge a PR yourself (`gh pr merge`) | Explicit instruction naming that PR or "merge them" |
| Archive a workspace | An explicit instruction ("archive once merged"). Only archive after its PR merged |
| Touch a PR with no owning workspace | Ask. Report it instead of editing it |

If archiving was not granted, run the watcher with `AUTO_ARCHIVE=0`.

## The Process

### 1. Dispatch

1. **Look before you create.** For each issue: `gh issue view N --json state,title,labels,body` and
   `gh pr list --state all --search "N in:title"`. If a PR already implements it, don't start a duplicate —
   dispatch an agent whose message says "PR #X already implements this; review that branch, fix gaps by
   pushing to it, keep it current, report when it is ready to merge". If an earlier PR only diagnosed or
   partly fixed it, say so in the message.
2. **Find the project id**: `conductor project list --json --limit 100 | jq -r '.data[]|select(.gitRemote|test("owner/repo"))|.id'`
   (or read `projectId` from `conductor workspace get <this workspace> --json`).
3. **Create one workspace per issue**, named exactly `Issue N` (the watcher finds owners by that name):

   ```bash
   conductor workspace create --project-id "$P" --name "Issue $N" --session-name "Issue $N" \
     --agent claude --model opus-5-5-1m --effort high --message "Work on issue $N." --json
   ```

   Returns `workspaceId` and `sessionId` at the top level (not under `.data`). Match the model, effort and
   opening message other workspaces in the repo already use — read one with
   `conductor session message <sessionId> --json --limit 1`. `conductor model` lists valid models/efforts.
4. **Add only context the agent can't derive**: compliance rules from the repo's CLAUDE.md that the issue
   touches (PHI, new infrastructure, manual deploy steps), or the existing-PR note from step 1.
5. **Check it took.** `conductor workspace list --repo <name> --limit 100 --json` (default page size is 5!).
   If Conductor renamed one to `Issue N-v1` because an archived workspace holds the name, rename it back:
   `conductor workspace rename <id> --name "Issue N"`. A create can fail with a transient error; re-run only
   the failed one after confirming it doesn't exist.

### 2. Watch

Start the bundled poller, `scripts/pr-watcher.sh` in this skill's directory, under Monitor. It prints one line per *new* event and dedupes per (PR, head sha, base sha, state):

```bash
Monitor: ${CLAUDE_SKILL_DIR}/scripts/pr-watcher.sh      # REPO=owner/name WS_PREFIX="Issue " INTERVAL=300
```

`${CLAUDE_SKILL_DIR}` is Claude Code's path to this skill; in other agents, use the path of the directory holding this SKILL.md.

Run it from a checkout of the repo (so `gh repo view` resolves). Monitor expires after 30 minutes: **re-arm it on each expiry notice** until the fleet is done, and **stop it** (TaskStop) when it is. Don't poll or sleep yourself; events arrive on their own.

| Env | Effect |
| --- | --- |
| `REPO`, `BASE` | Repository (`owner/name`) and base branch; default to the current repo and its default branch |
| `WS_PREFIX` | Workspace name prefix that maps to an issue number (default `Issue `) |
| `INTERVAL` | Seconds between passes (default 300) |
| `ONCE=1` | One pass, then exit. Exits non-zero if GitHub can't be read |
| `DRY_RUN=1` | Never message or archive; print what would happen. Keeps its own dedupe state, so a later real run still reports everything |
| `AUTO_ARCHIVE=0` | Never archive |
| `STATE` | Directory for dedupe markers (default `$TMPDIR/pr-watcher-<repo>`) |

A pass that can't read the base branch or the open PRs is skipped with a note on stderr; it never archives on a failed lookup.

#### Event playbook

| Event | What to do |
| --- | --- |
| `BEHIND … messaged workspace` | Nothing. The owner was told to merge the base branch. A later `BLOCKED` event on that PR means it pushed |
| `BEHIND … no owning workspace` | Report it. Merge the base in yourself only if the user asked to keep that PR current |
| `CONFLICT` | See [Resolving conflicts](#3-resolve-conflicts) below |
| `CI_FAILED_OR_BLOCKED` | `BLOCKED` is **usually just CI still running** after a push. Check `gh pr checks N`; act only on `fail` |
| `MERGED … archived` | Nothing. Mention it in your next status line |

Because other PRs landing makes the rest fall behind, expect a ripple: after each merge, every remaining PR goes BEHIND → agent merges base → BLOCKED (CI) → CLEAN. That is normal. Don't intervene unless a PR is stuck for two passes.

#### Failing checks

- Read why: `gh run view <run> --log-failed`. If the run is still in progress the log isn't available — wait.
- **Format/lint failure** on the agent's own files: message the owner to run the formatter, push, re-check.
- **Transient infrastructure** (font/package fetch failed, runner crash, a test that fails in a file the PR
  never touched): `gh run rerun <run> --failed`, and say you did. If it fails the same way twice, treat it as real.
- **Real test/build failure**: message the owner with the failing check and file; don't fix it yourself.

#### Green PRs

`gh pr view N --json mergeStateStatus` is `CLEAN` and every check in `gh pr checks N` is `pass`/`skipping`
→ (when authorized) message the owner:

> PR #N is green. The workspace owner's instruction is to merge green PRs: `gh pr merge N --squash --delete-branch`
> (match how recent PRs landed). If refused because the branch is behind, merge the base in, re-run
> tests/lint/build, push, wait for CI, then merge. Reply with the merge commit.

For a **stack** (`1/3`, `2/3`, `3/3`) tell the owner to merge in order and update each remaining PR from the
base (or retarget it) before merging it. Stacked PRs show no checks until their base is main.

Sleeping/idle workspaces wake when sent a message.

### 3. Resolve Conflicts

Only with the user's permission to resolve conflicts; otherwise report the conflict to the owner and the user.

1. **Is the owner already on it?** `conductor session status <sessionId>`. If it is `working`, send a short
   message naming the conflicting files and wait one pass; agents usually fix their own. Two agents racing a
   push is worse than a one-pass delay. If it is `idle`/sleeping, or still conflicting after the next push, resolve it yourself.
2. **Use a separate worktree** so nothing of yours or the owner's is disturbed:
   `git fetch origin && git worktree add -B wt-N ../prN origin/<branch> && cd ../prN && git merge origin/<base>`.
   Install deps if needed (`bun install --ignore-scripts`, `npm ci`, …).
3. **Preview first when unsure**: `git merge-tree --write-tree --name-only origin/<branch> origin/<base>` lists
   conflicting files without touching anything.
4. **Resolve by intent, not by side.** The common shapes:
   - *Both sides appended to the same list/file end* (stories, exports, tests, docs): keep both. Reconstruct
     rather than hand-edit markers — the conflict hunk often ends mid-block and the shared tail closes both.
   - *Numbered docs collide* (`VERIFICATION_PLAN.md` scenarios, ADR numbers, migrations): the base keeps its
     number; renumber the PR's to the next free one, **checking every other open PR's head** for the numbers
     they claimed (`git show origin/<branch>:FILE | grep -oE '^### Scenario [0-9]+' | tail`), and fix references
     elsewhere (`git grep`).
   - *Same function edited by both*: keep the base's behaviour and re-apply the PR's change on top of it.
   - Never discard the base's side to make a conflict go away.
5. **Verify**: no markers left (`grep -rn '^<<<<<<<\|^>>>>>>>'`), then run the affected package's tests, type-check,
   formatter check and build as the repo's CLAUDE.md requires. Distinguish failures the merge caused from ones that
   already exist on the base (stash/compare, or check CI on the base).
6. **Commit and push to the PR branch** (`git push origin HEAD:<branch>`) with a message saying what was kept
   and what was renumbered. **Tell the owner to `git pull`** so it doesn't push over you.
7. Remove the worktree when done. Never force-push.

### 4. Finish

The fleet is done when every dispatched workspace is archived (or the user says otherwise). Then:

- stop the watcher;
- report what merged, anything left open and **why** (ownerless PR, needs a human decision, needs live infra);
- flag anything the PRs need from a human that CI can't give: live verification scenarios, new env vars,
  secrets, IAM, infrastructure, vendor/compliance sign-off.

## Running as a Subagent

`agents/conductor-fleet-supervisor.md` in this skill's directory is a Claude Code subagent definition that loads this skill and follows it, so a long supervision run stays out of the main conversation. Copy it to `.claude/agents/` (project) or `~/.claude/agents/` (user) to install it, then brief it with the repo, the issue numbers, and which permissions from the authorization table it has.

## Gotchas Learned the Hard Way

- `conductor workspace list` shows **5 rows by default** — always `--limit 100`, or you'll think workspaces vanished.
- Workspaces go `sleeping` when idle; that is not archived. Don't filter on `state == "ready"`.
- `pkill -f pr-watcher` can kill your own shell. Stop with TaskStop, or `kill` a known pid.
- Don't edit the watcher script while it runs; stop, edit, re-arm.
- A merged PR that merely *mentions* `#N` (a diagnosis, a doc) must not archive workspace N: the watcher only counts
  PRs whose branch or title names the issue (`issue-N`, `(#N)`), merged **after** the workspace was created, and not
  while another open PR still names the issue.
- `BLOCKED` ≠ failing. Required reviews also show as `BLOCKED`; `gh pr view N --json reviewDecision` tells you.
- CI that has not run yet shows "no checks reported" for a fresh push or a stacked PR — wait.
- Messages to other agents are plain text; `@file` attaches nothing. Put the instruction in the message.
- Agents who finish a PR may reply "done"; the source of truth is `gh pr view`, not the reply.
- Report outcomes faithfully: a rerun that passed is "rerun, passed", not "fixed".

## Testing the Watcher

`tests/pr-watcher.test.sh` runs the watcher against stubbed `gh` and `conductor` binaries and checks event output, dedupe, the archive guards, and `DRY_RUN`. Run it after any change to `scripts/pr-watcher.sh`; it needs only `bash` and `jq`.
