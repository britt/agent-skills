---
name: working-on-an-epic
description: Use when asked to work on, implement, drive, or coordinate a GitHub epic, parent issue, or tracking issue whose work is split into child issues, and the `conductor` CLI is available - the child issues are implemented by separate Conductor sessions, not by you
---

# Working on an Epic

**Announce at start:** "I'm using the working-on-an-epic skill to coordinate this epic through Conductor."

## Overview

You are the **coordinator**, not the implementer. Each child issue is implemented by its own Conductor cloud workspace running the `working-on-an-issue` skill. Your job is to read the epic, map the dependencies, fan the children out, watch them, unblock them, link dependent PRs into GitHub stacks, and report. You never implement a child yourself and you never merge.

**Core principle:** Understand → Map dependencies → Fan out → Watch → Unblock → Verify → Report

**Create todos (TodoWrite, if available) for the pre-flight checklist and each numbered step below.**

## When to Use

- Developer asks to work on, implement, or "get done" an epic, parent issue, or tracking issue
- The issue's work is split into separate child issues (sub-issues, a task list of `#N` references, or issues that say "Part of #epic")
- `conductor auth whoami` succeeds on this machine

## When NOT to Use

- A single, non-epic issue → `working-on-an-issue`
- The epic has no child issues yet → run `issue-decomposition` to create them, then come back to this skill
- `conductor` is missing or not authenticated → stop and tell the developer; do not fall back to implementing the children serially yourself
- Developer explicitly wants the work done in this one session → `working-on-an-issue` per child, in sequence

**"Spawn the rest, but do #N yourself":** decline the hybrid and spawn #N like the others. Your checkout is on the coordinator's branch, a child costs you nothing while slots are free, and a coordinator that implements stops watching. Say why in your reply.

## Pre-flight Checklist

- [ ] Epic URL or number obtained
- [ ] `conductor auth whoami` reports `✓ authenticated`
- [ ] `CONDUCTOR_WORKSPACE_ID` is set (so `workspace create` inherits this project), or you know the `--repo-url` to pass
- [ ] `gh auth status` succeeds
- [ ] `gh stack --version` succeeds (install with `gh extension install github/gh-stack`); dependent PRs are linked into GitHub stacks
- [ ] Base branch known: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, unless the epic thread names a different integration branch
- [ ] Scratch directory created outside the repo: `mkdir -p /tmp/epic-<number>`

## The Process

### 1. Read the Epic and Every Child

`gh issue view <epic> --comments`. Comments supersede the body; the latest instruction wins (for example "reviews happen on each PR, don't merge" is a standing constraint you pass to every child).

Resolve the children from all three sources and union them:

```bash
# GitHub sub-issues
gh api graphql -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){issue(number:$n){subIssues(first:50){nodes{number title state}}}}}' -F o=<owner> -F r=<repo> -F n=<epic>
# Task-list references in the epic body: lines like "- [ ] #41"
gh issue view <epic> --json body -q .body | grep -oE '#[0-9]+' | sort -u
# Issues that point back at the epic
gh issue list --state all --search "\"Part of #<epic>\" OR \"Parent: #<epic>\"" --json number,title,state
```

For every open child: `gh issue view <n> --comments`. Then run the same **sizing check** `working-on-an-issue` uses: can the child be restated as 1–5 testable acceptance criteria? An acceptance criterion that names something the repo lacks (a docs index, a config file) is a *how* problem the child records as an assumption, not a sizing failure. A child that fails the check is **not spawned** — comment on it with what is missing and record it as `skipped` in the ledger. Do not decompose or elicit on the child's behalf; that is a scope change the developer makes.

**Idempotency:** before spawning anything, check for work that already exists:

```bash
gh pr list --state all --search "Fixes #<child> in:body" --json number,url,state,headRefName
gh pr list --state all --limit 200 --json number,url,state,headRefName | jq '.[] | select(.headRefName | startswith("issue-<child>-"))'
conductor --json workspace list --mine --name "-<child>" --limit 100
```

An existing open or merged PR means the child is done — record it. An existing workspace means adopt it: list its sessions with `conductor --json workspace session <id>` and poll that session instead of creating a duplicate.

### 2. Map Dependencies

From each child's body and comments, collect `Blocked by #N`, `Depends on #N`, `After #N`, and "needs X from #N" phrasing (the same signals `dependency-mapping` reads).

Then turn the graph into **chains**. A chain is one connected component of the dependency graph, ordered by repeatedly taking the lowest-numbered child whose blockers are all already placed. Each chain becomes one GitHub stack, bottom to top, and each child in a chain is spawned only when the child below it is `done`, based on that child's branch. Children with no dependency edges are standalone: spawned immediately against the base branch and never stacked.

- A child with two blockers does not fit a linear stack, so its whole component is linearised into one chain. The cost is that a child with no blocker of its own, which is in the chain only because something above depends on it too, is spawned in sequence instead of in parallel. Accept that cost: it means no child ever rebases onto a sibling and no force-push cascades through a stack. Say which children were serialised this way in the kickoff comment.
- A blocker that is `skipped`, `blocked`, or `failed` never resolves; everything above it in the chain is recorded as `not-started: blocked by #N` and never spawned against the base branch to "work around" it.
- **Concurrency cap: 4 children in flight** unless the developer states a different number. `running` and `asking` children hold a slot; every other phase frees one. The bottom of every chain and every standalone child is ready at once; queued children start in chain order, then issue-number order.
- **Wall-clock budget: 6 hours**, or the developer's stated deadline if they gave one. At the deadline, report whatever state exists; a child still `working` is listed as in progress with its deep link, not cancelled.

### 3. Update Project Status and Announce

Move the epic to an "in progress" status in every GitHub Project it belongs to, using the GraphQL procedure from `working-on-an-issue` step 2. Failures here are recorded as caveats, never blockers.

Post one kickoff comment on the epic listing the plan: chains and standalone children, base branch, concurrency cap, which children were serialised by linearisation, and which children (if any) were skipped and why. The final report (step 10) is a second, new comment. Never edit the epic body.

### 4. Write the Child Prompt

Each child gets its own prompt file, `/tmp/epic-<number>/prompt-<child>.md`. The prompt is a contract; every slot below is REQUIRED:

```
Use the working-on-an-issue skill to implement GitHub issue #<child> in <owner>/<repo>
("<child title>"). It is a child of epic #<epic> ("<epic title>"). Read the epic and its comments first.

Constraints from the epic:
- <every standing instruction from the epic thread, verbatim, e.g. "Reviews happen on each PR. Do NOT merge anything.">
- Branch name: issue-<child>-<short-slug>, based on <base branch>. Push it as soon as it exists.
- PR base: <base branch>. The PR body must contain "Fixes #<child>", "Part of #<epic>", a "## Assumptions"
  section, and a "## Verification" section with the verification log.
- Do not touch work owned by sibling issues: <#N: area or paths derived from its acceptance criteria, ...>.
- No human will answer questions in this session. Do not stop to ask. Resolve ambiguity with the narrowest
  reading that satisfies the issue text and record it under Assumptions. Assumptions resolve how, never
  reduce what. If you must stop, the coordinating session may answer a how-question; it will not make product decisions.
- Genuinely blocked (contradictory requirements, missing credentials): comment on #<child> with exactly
  what you need, then end your turn with the single line: EPIC-CHILD-BLOCKED issue=<child> reason=<one sentence>

When the PR is open, end your turn with the single line (full PR URL, not a number):
EPIC-CHILD-DONE issue=<child> branch=<branch> pr=<https://github.com/owner/repo/pull/N>
```

For a child above the bottom of a chain (step 7), `<base branch>` is the head branch of the child directly below it, and the prompt adds: "Your workspace is based on branch `<below-branch>` (PR `<url>`, not yet merged). It already contains the work from <every issue below in the chain, e.g. #41 and #42>; import it, do not recreate or modify it. Open your PR against `<below-branch>`. The coordinator will link it into a GitHub stack; do not retarget it, rebase it, or write merge-order notes yourself."

### 5. Fan Out

One **workspace** per child — never sessions inside one workspace, because sessions share a checkout and a branch. Name the workspace `<short-slug>-<child-number>`.

```bash
conductor --json workspace create \
  --branch <base branch> \
  --name "<short-slug>-<child>" \
  --session-name "Implement #<child>" \
  --agent claude \
  --message-file /tmp/epic-<number>/prompt-<child>.md \
  > /tmp/epic-<number>/create-<child>.json
ws=$(jq -r '.id' /tmp/epic-<number>/create-<child>.json)
sid=$(conductor --json workspace session "$ws" | jq -r '.data[0].id')
link=$(conductor --json workspace session "$ws" | jq -r '.data[0].deepLink')   # session-level link
printf '%s\t%s\t%s\t%s\t-\t%s\t-\t%s\n' "<child>" "$ws" "$sid" "$link" "running" "base=<base branch>" >> /tmp/epic-<number>/ledger.tsv
```

Omit `--model` and `--effort` unless the developer chose them; the project defaults apply. Pass `--project-id` or `--repo-url` only when `CONDUCTOR_WORKSPACE_ID` is unset. Children get `gh` credentials from the project's workspace setup, not from you; a child without them takes the blocked off-ramp and you report it.

**Ledger columns:** `issue  workspaceId  sessionId  deepLink  lastMessageId  phase  prUrl  notes`, tab-separated, with `-` for an empty cell (bash collapses empty tab-separated fields otherwise). Phases: `running`, `asking`, `stalled`, `done`, `blocked`, `failed`, `skipped`, `not-started`. `notes` holds relayed decisions and merge-order facts, appended with `; `. The ledger is the only record of message cursors and decisions until the final report is posted; keep it current.

Confirm each workspace provisioned: poll `conductor --json workspace status <ws>` every 10 seconds until `.status` is `ready`, for at most 10 minutes. If it never is, retry `workspace create` once, then record `failed`.

### 6. Watch

Poll from **one** background Bash loop, not a stream of individual tool calls. Save it as `/tmp/epic-<number>/poll-epic.sh`. Session status is `working` while the child is busy and `idle` when it has stopped. **Idle means stopped, not done** — classify it from the transcript. The loop exits after the first sweep that changes any phase, so you are woken to act; it may print several lines. Relaunch it after acting.

```bash
#!/bin/bash
# poll-epic.sh <epic-number>  — exits after a sweep that changed any phase, or when no child is running
L=/tmp/epic-$1/ledger.tsv
changed=0
while [ $changed = 0 ] && grep -q $'\trunning\t' "$L"; do
  while IFS=$'\t' read -r n ws sid link last phase pr notes; do
    [ "$phase" = running ] || continue
    [ "$last" = - ] && last=
    status=$(conductor --json session status "$sid" | jq -r .status) || status=error
    [ "$status" = working ] && continue
    # page the transcript since the cursor; a page holds at most 100 events
    : > /tmp/epic-$1/msgs-$n.jsonl; cur=$last
    while :; do
      conductor --json session message "$sid" ${cur:+--after "$cur"} --limit 100 > /tmp/epic-$1/page-$n.json
      jq -c '.data[]' /tmp/epic-$1/page-$n.json >> /tmp/epic-$1/msgs-$n.jsonl
      cur=$(jq -r '.data[-1].id // empty' /tmp/epic-$1/page-$n.json)
      [ "$(jq -r .hasMore /tmp/epic-$1/page-$n.json)" = true ] && [ -n "$cur" ] || break
    done
    newest=$(jq -rs '.[-1].id // empty' /tmp/epic-$1/msgs-$n.jsonl)
    # idle with nothing new since the cursor (e.g. just after a relay): still running. Any other status with nothing new: stalled.
    [ -z "$newest" ] && [ "$status" = idle ] && continue
    # assistant text only: tool results could quote a sentinel line without meaning it
    text=$(jq -rs '[.[] | select(.type=="agent" and .content.rawPayload.type=="assistant")
                   | .content.rawPayload.message.content[]? | .text? // empty] | join("\n")' /tmp/epic-$1/msgs-$n.jsonl)
    if   [ -z "$text" ];                                      then phase=stalled
    elif grep -q "^EPIC-CHILD-DONE issue=$n "    <<<"$text"; then phase=done; pr=$(grep -oE '^EPIC-CHILD-DONE.* pr=\S+' <<<"$text" | tail -1 | sed 's/.* pr=//')
    elif grep -q "^EPIC-CHILD-BLOCKED issue=$n " <<<"$text"; then phase=blocked
    else phase=asking; fi
    echo "$(date -u +%FT%TZ) #$n status=$status -> $phase ${pr:--}"
    awk -F'\t' -v OFS='\t' -v n="$n" -v m="${newest:-${last:--}}" -v p="$phase" -v u="${pr:--}" \
      '$1==n{$5=m;$6=p;$7=u}1' "$L" > "$L.tmp" && mv "$L.tmp" "$L"
    changed=1
  done < "$L"
  if [ $changed = 0 ]; then sleep 60; fi
done
```

Run it with `run_in_background`; act on every line it prints; relaunch. The `--after <messageId>` cursor keeps each fetch incremental. Do not use `conductor sql` for transcripts; the message endpoint is the supported path.

Cross-check a `done` report before trusting it: `gh pr view <url> --json state,baseRefName,headRefName` must show an open PR. Take the real branch name from `headRefName`, not from the prompt. A `done` with no findable PR becomes `asking`; message the child: "No open PR found for your branch. Push the branch, open the PR, and end with the EPIC-CHILD-DONE line again."

### 7. Grow Each Chain and Link the Stack

When a chain member's phase becomes `done` (verified, step 6) and `git ls-remote --heads origin <headRefName>` shows its branch, link first (below), then spawn the next child in that chain (step 4 and 5) with `--branch <headRefName>`. If the branch is not on origin, message the child: "Your branch is not on origin. Push it and end with the EPIC-CHILD-DONE line again," and set it back to `running`. The next child's PR targets that branch because waiting for a human to merge the layer below would outlive this session. If `gh pr view` shows the layer below already `MERGED`, base the next child on the base branch instead; merged layers are left out of `gh stack link`, and if every layer below has merged the child is standalone. A layer that merges *after* the child above was spawned is fine: GitHub retargets the child's PR to the base branch on its own.

Each child opens its PR against the right base itself, so `gh stack link` only has to record the chain. Link as soon as the second PR in a chain is verified `done`, **PR URLs only** (branch-name arguments make `gh stack link` push branches from your checkout, which does not have them):

```bash
# second PR of a chain: create the stack, bottom to top
gh stack link <bottom PR URL> <next PR URL>
# every later PR: grow the stack by number
gh stack link <stack-number> <next PR URL>
```

Pass `--base <integration branch>` when the epic named one other than the repository default. Take the stack number from the command output; if it is not printed, it is shown in the stack panel of either PR on GitHub. Append `stack=<number>` to the `notes` of every PR in the chain. If the link command fails, record the error in `notes`, keep spawning, and retry the link during step 9 with the same URLs. Never put two chains, or a standalone PR, into one stack: a stack merges atomically and in order, so stacking unrelated work makes one blocked review hold all of them.

### 8. Unblock

A child in `asking` stopped without a sentinel line. Read the assistant text at the end of `msgs-<n>.jsonl` and decide:

- **How-question** (file location, naming, which pattern, whether to proceed without approval, PR base, which existing signal to use for a concept like "new user"): answer from the epic thread, the child issue, sibling transcripts, and repo conventions:
  ```bash
  conductor message create --session <sid> --message "<answer>. Record this under Assumptions in the plan and PR body. Do not ask again; keep going and end with the EPIC-CHILD-DONE line."
  ```
  Set the phase back to `running` and append `relayed: <question> → <answer>` to `notes`.
- **What-question** (product behaviour or scope the issues do not settle): do not invent an answer. Tell the child to implement only what the issue text states, list the open question in the PR body under "Open questions for reviewer", and finish. If it truly cannot proceed, tell it to take the blocked off-ramp.
- **`stalled`** (stopped with no assistant text, or an error status): retry once with `conductor session create --workspace <ws> --agent claude --message-file <same prompt>`, replace `sessionId` and reset the cursor to `-`; a second stall is `failed`.

Every relay is a decision made on the developer's behalf — it goes in `notes` and in the report. Never `session cancel` a child for asking; cancel only a session still `working` past the wall-clock budget with no pushed commits, and say so.

### 9. Verify

For each `done` PR:

```bash
gh pr view <url> --json number,url,state,isDraft,baseRefName,headRefName,body,mergeable,statusCheckRollup
gh pr diff <url> --name-only | sort > /tmp/epic-<number>/files-<child>.txt
```

Checks: open, not draft, expected base, body contains `Fixes #<child>` (a `Refs #<child>` means the child is **incomplete** — report it that way), `## Assumptions`, and `## Verification`. Read CI status once; do not wait on it.

Then intersect the changed-file lists pairwise (`comm -12`), skipping pairs that are both in the same chain, since those already build on each other. Two PRs that touch the same file are a dependency the issues did not declare, so treat them as a chain: pick the landing order (a chain member before a standalone PR; otherwise the smaller change goes second; a standalone joining a chain rebases onto the chain's top) and message the second PR's session — "Rebase your branch onto `origin/<first headRefName>` with `--force-with-lease`, retarget the PR base to that branch with `gh pr edit --base`, then end with the EPIC-CHILD-DONE line again" — set its phase back to `running` so the loop catches the second sentinel, then link the pair with `gh stack link` as in step 7. The child does the rebase, not you: it has the context to resolve conflicts in code you never read. This is the only rebase the skill ever asks for.

Finally confirm every chain with verified commands: for each PR above the bottom, `gh pr view <url> --json baseRefName` must equal the `headRefName` of the PR below it, or the base branch if the PR below is `MERGED`; and every `gh stack link` must have exited 0. Any other mismatch goes back to the PR's session with a retarget message.

### 10. Report

Post one new comment on the epic containing, per child: issue, PR link, base branch, CI state, Conductor deep link, stack number (or "standalone"), and the `notes` (assumptions, relayed decisions, open questions, blocked reasons). For each stack, give the one-line landing instruction: `gh stack merge <stack-number>` merges the whole chain atomically and in order. Standalone PRs merge individually in any order. Then reply to the developer with the same table.

- Deep links, not raw ids — they are clickable.
- Leave child workspaces and sessions alive. Reviewers send follow-ups to the session that wrote the PR; archive only when the developer asks.
- Do not tick the epic's task list by hand; `Fixes #<child>` closes each child on merge.
- If any child is `blocked`, `failed`, `skipped`, `stalled`, or `not-started`, the epic is not done. Say so plainly.

## Absolute Rules

- **Coordinate, never implement**: a child issue is always done by a child session, even the "quick" one
- **One workspace per child**: never sessions sharing a checkout
- **Never merge**: the PR is the approval gate for each child, exactly as in `working-on-an-issue`; a standing "don't merge" instruction on the epic outranks any urgency in the request. `gh stack merge` is for the reviewer, never for you
- **One stack per dependency chain**: independent PRs stay standalone
- **Stopped is not done**: only the `EPIC-CHILD-DONE` line plus a verified PR counts
- **Answer how, escalate what**: relayed decisions are logged; product decisions are not invented
- **Report honestly**: skipped, blocked, stalled, and failed children are listed, not summarised away

## Quick Reference: Verified CLI Facts

| Need | Command | Shape |
|------|---------|-------|
| Am I in Conductor? | `echo $CONDUCTOR_WORKSPACE_ID`, `conductor auth whoami` | id; `✓ authenticated` |
| Spawn a child | `conductor --json workspace create --branch … --name … --agent claude --message-file …` | workspace record with `id` |
| Session id of a workspace | `conductor --json workspace session <ws>` | `{"data":[{"id","deepLink","name","model"}]}` |
| Provisioned? | `conductor --json workspace status <ws>` | `{"workspaceId","status":"ready",…}` |
| Busy or stopped? | `conductor --json session status <sid>` | `{"sessionId","status":"working"\|"idle",…}` |
| New transcript since cursor | `conductor --json session message <sid> --after <id> --limit 100` | `{"data":[…],"hasMore"}`, oldest first, 100 max per page |
| Assistant text in a transcript | `.data[] \| select(.type=="agent" and .content.rawPayload.type=="assistant") \| .content.rawPayload.message.content[].text` | other `rawPayload.type` values: `system`, `user` (tool results), `result` (turn ended), `command_lifecycle`, `rate_limit_event` |
| Talk to a child | `conductor message create --session <sid> --message "…"` | message record |
| Children issues | GraphQL `issue(number){subIssues{nodes{number}}}` | resolves on GitHub today |
| Stack existing PRs | `gh stack link <PR URL> <PR URL> …` (bottom to top) or `gh stack link <stack-number> <PR URL>` | creates or grows the stack on GitHub; no local tracking needed |
| Confirm a chain | `gh pr view <url> --json baseRefName,headRefName` per layer | each base equals the head below it |
| Land a stack (reviewer, not you) | `gh stack merge <stack-number>` | atomic, in order, all or nothing |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Treating `idle` as finished | `idle` is the normal stopped state; only the sentinel line plus `gh pr view` is done, everything else is `asking` or `stalled` |
| Reading one page of the transcript | Pages cap at 100 events; page on `hasMore` or the sentinel is missed |
| Starting a chain member from the base branch because the layer below is "basically done" | Wait for its verified `done` and its branch on origin, then base on that branch |
| Running a linearised sibling in parallel and rebasing it later | Spawn along the chain; a rebase across sessions force-pushes through every layer above it |
| Stacking independent PRs "to keep things together" | One stack per dependency chain; a stack merges atomically, so unrelated work would block each other |
| Passing branch names to `gh stack link` | PR URLs only; branch arguments are pushed from your checkout, which lacks them |
| Rebasing a child's branch yourself to fix a stack | Message the child's session; it has the context to resolve conflicts |
| Running `gh stack checkout` in the coordinator's workspace | It switches your checkout and creates local tracking you do not need; confirm chains with `gh pr view` |
| Reading transcripts with `conductor sql` | Use `session message --after`; the SQL endpoint is optional and rate-limited |
| Polling with dozens of separate tool calls, or a loop that never returns | One background loop that exits on the first phase change |
| Merging because the developer said "get it landed" | Landed means reviewable PRs; a standing "don't merge" comment on the epic outranks urgency |
| Implementing "just the small one" yourself | Spawn it; the coordinator that implements stops coordinating |
| Archiving child workspaces at the end | Leave them for reviewers; archiving is the developer's call |
| Spawning children as sessions in your own workspace | They would share your branch and checkout; use `workspace create` |
| Keeping the ledger only in your head | `/tmp/epic-<n>/ledger.tsv` survives context compaction; your memory does not |
