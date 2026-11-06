---
name: working-on-an-epic
description: Use when asked to work on, implement, drive, or coordinate a GitHub epic, parent issue, or tracking issue whose work is split into child issues, and separate agent workspaces are available to implement them - you coordinate, the children implement
---

# Working on an Epic

**Announce at start:** "I'm using the working-on-an-epic skill to coordinate this epic across child workspaces."

## Overview

You are the **coordinator**, not the implementer. Each child issue is implemented by its own isolated workspace running the `working-on-an-issue` skill. Your job is to read the epic, map the dependencies, fan the children out, watch them, unblock them, link dependent PRs into GitHub stacks, keep those stacks linear, and report. You never implement a child yourself and you never merge.

**Core principle:** Understand → Map dependencies → Fan out → Watch → Unblock → Verify → Report

**This skill names no workspace tool.** Everything tool-specific is confined to seven shell functions you bind once, in step 0, to whatever workspace manager this machine has. Every later step calls those functions and nothing else.

**The stack model, stated once.** GitHub merges a stack only when "the stack has a linear history" ([Merging stacked pull requests](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/merging-stacked-pull-requests)): every layer is exactly **one squashed commit whose parent is the current head of the layer below**. A stack stops being linear "after changes were pushed to a lower branch or after the trunk moved ahead", and the fix is a cascading rebase, bottom-up, pushed with `--force-with-lease`. A layer must therefore **never** merge its base branch or the trunk into itself ("Update branch", `git merge origin/main`, `git merge <below>`): each such merge commit makes the stack unmergeable as a stack, and undoing it later means rewriting every layer above. Rebases are normal and expected here; merges are the mistake.

**Create todos (TodoWrite, if available) for the pre-flight checklist and each numbered step below.**

## When to Use

- Developer asks to work on, implement, or "get done" an epic, parent issue, or tracking issue
- The issue's work is split into separate child issues (sub-issues, a task list of `#N` references, or issues that say "Part of #epic")
- This machine can give each child its own workspace — a separate git worktree with its own branch and its own agent (step 0 decides)

## When NOT to Use

- A single, non-epic issue → `working-on-an-issue`
- The epic has no child issues yet → run `issue-decomposition` to create them, then come back to this skill
- A child is bigger than 8 points or carries the `epic` label → it is an epic itself; decompose it with `issue-decomposition` before spawning anything for it
- Step 0 cannot bind a runner — no workspace manager and no usable git-worktree fallback → stop and tell the developer; do not fall back to implementing the children serially yourself
- Developer explicitly wants the work done in this one session → `working-on-an-issue` per child, in sequence
- A list of issues that aren't one epic's children, or supervising open PRs until they merge (keeping them current with the base branch, telling green PRs to merge, archiving workspaces) → the `supervising-*-workspaces` skill for your runner. This skill never merges or archives

**"Spawn the rest, but do #N yourself":** decline the hybrid and spawn #N like the others. Your checkout is on the coordinator's branch, a child costs you nothing while slots are free, and a coordinator that implements stops watching. Say why in your reply.

## Step 0: Bind the Workspace Runner

The skill needs seven capabilities. Bind each to a real command, write them as shell functions in `/tmp/epic-<number>/runner.sh`, and source that file in every later step and script.

| Function | Must do | Must return on stdout |
|----------|---------|-----------------------|
| `ws_create <name> <branch> <base> <promptfile>` | Create an isolated workspace — its own git worktree and checkout — on `<branch>` based on `<base>`, and start a coding agent in it whose opening prompt is the contents of `<promptfile>` | the workspace handle, alone, nothing else |
| `ws_agent <ws>` | Identify the agent to talk to inside that workspace | the agent handle (terminal/session id); empty if there is none |
| `ws_branch <ws>` | Report the branch the workspace **actually** got | the branch name; empty until it has provisioned |
| `ws_state <ws> <agent>` | Report whether that agent is busy or stopped | exactly one of `working`, `stopped`, `gone` |
| `ws_transcript <ws> <agent>` | Emit the agent's **own transcript** — its messages, not a screen scrape of the visible pane | the transcript |
| `ws_send <ws> <agent> <text>` | Deliver `<text>` to the running agent as a new user turn | nothing |
| `ws_link <ws>` | Give the developer something clickable or openable | a URL, or the absolute worktree path |

**Binding rules:**

- **Normalise the state vocabulary inside `ws_state`.** Runners use their own words — `starting`, `running`, `idle`, `blocked`, `exited`, `dead`. Map every "still going" word to `working`, every "stopped but alive" word to `stopped`, and "process/agent is gone" to `gone`. A runner's `blocked` almost always means *waiting for input*, which is `stopped`, not `working` — and it is unrelated to GitHub's `BLOCKED` merge state.
- **Scope the runner explicitly.** If your runner can target more than one fleet (this machine vs. a cloud), pass its scoping flag inside every function body. Unscoped, children get created in one place and listed in another.
- **Probe before you trust.** Run each function once against a throwaway workspace, or against an existing one, and check the shape of what comes back. A wrapper script or a quiet CLI can swallow output; treat silence as "unknown", never as success.
- **Record the binding.** Put the runner's name and the seven resolved commands at the top of `/tmp/epic-<number>/runner.sh` as comments, so a compacted context can re-read them.

**Fallback binding (no workspace manager).** Plain git plus a background agent process is enough for six of the seven:

```bash
# /tmp/epic-<number>/runner.sh  — git-worktree fallback
R=$(git rev-parse --show-toplevel); W=/tmp/epic-wt
ws_create() { # name branch base promptfile
  local p="$W/$1"; git -C "$R" worktree add -b "$2" "$p" "origin/$3" >&2 || return 1
  ( cd "$p" && <agent-command> --prompt "$(cat "$4")" >"$p/.agent.log" 2>&1 & echo $! >"$p/.agent.pid" )
  echo "$p"; }
ws_agent()      { cat "$1/.agent.pid" 2>/dev/null; }
ws_branch()     { git -C "$1" rev-parse --abbrev-ref HEAD 2>/dev/null; }
ws_state()      { [ -d "$1" ] || { echo gone; return; }
                  kill -0 "$2" 2>/dev/null && echo working || echo stopped; }
ws_transcript() { cat "$1/.agent.log" 2>/dev/null; }
ws_send()       { return 97; }   # not supported by this runner
ws_link()       { echo "$1"; }
```

`ws_send` is the one that does not generalise: a detached agent has no inbox. **If `ws_send` is unavailable, say so in the kickoff comment, and treat step 8 as report-only** — a child that stops with a question is recorded `asking` with its question in `notes` and surfaced in the final report for the developer to answer, never silently abandoned and never worked around by implementing the child yourself.

## Pre-flight Checklist

- [ ] Epic URL or number obtained
- [ ] Scratch directory created outside the repo: `mkdir -p /tmp/epic-<number>`
- [ ] Runner bound and probed (step 0); `/tmp/epic-<number>/runner.sh` exists and sources cleanly
- [ ] `ws_send` availability known, and noted if missing
- [ ] `gh auth status` succeeds
- [ ] `gh stack --version` succeeds (install with `gh extension install github/gh-stack`), and `gh stack link --help` and `gh stack rebase --help` both print usage — some builds hide these from the top-level help while still shipping them. A `gh` wrapper, which some workspace managers install, can swallow the extension's output, so treat silence as "unknown" and verify stack state through the API (step 7)
- [ ] Base branch known: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, unless the epic thread names a different integration branch

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
```

Also ask the runner whether a workspace for this child already exists (its own list/search command, or the presence of `issue-<child>-*` in `git worktree list` and `git branch -a`). An existing open or merged PR means the child is done — record it. An existing workspace means **adopt** it: get its agent with `ws_agent` and poll that instead of creating a duplicate.

### 2. Map Dependencies

From each child's body and comments, collect `Blocked by #N`, `Depends on #N`, `After #N`, and "needs X from #N" phrasing (the same signals `dependency-mapping` reads).

Then turn the graph into **chains**. A chain is one connected component of the dependency graph, ordered by repeatedly taking the lowest-numbered child whose blockers are all already placed. Each chain becomes one GitHub stack, bottom to top, and each child in a chain is spawned only when the child below it is `done`, based on that child's branch. Children with no dependency edges are standalone: spawned immediately against the base branch and never stacked.

- A child with two blockers does not fit a linear stack, so its whole component is linearised into one chain. The cost is that a child with no blocker of its own, which is in the chain only because something above depends on it too, is spawned in sequence instead of in parallel. Accept that cost: it means no child ever has to be rebased onto a *sibling*, and the only cascades are the ordinary bottom-up ones in step 7. Say which children were serialised this way in the kickoff comment.
- Every layer above the bottom is rebuilt on top of the layer below whenever that layer moves (review fixes, a trunk rebase). Budget for it: a chain of N layers costs up to N-1 short rebase rounds each time the bottom changes, so keep chains short and land them promptly.
- A blocker that is `skipped`, `blocked`, or `failed` never resolves; everything above it in the chain is recorded as `not-started: blocked by #N` and never spawned against the base branch to "work around" it.
- **Concurrency cap: 4 children in flight** unless the developer states a different number. `running` and `asking` children hold a slot; every other phase frees one. The bottom of every chain and every standalone child is ready at once; queued children start in chain order, then issue-number order.
- **Wall-clock budget: 6 hours**, or the developer's stated deadline if they gave one. At the deadline, report whatever state exists; a child still `working` is listed as in progress with its link, not cancelled.

### 3. Update Project Status and Announce

Move the epic to an "in progress" status in every GitHub Project it belongs to, using the GraphQL procedure from `working-on-an-issue` step 2. Failures here are recorded as caveats, never blockers.

Post one kickoff comment on the epic listing the plan: chains and standalone children, base branch, concurrency cap, which children were serialised by linearisation, which children (if any) were skipped and why, and — if `ws_send` is unavailable — that questions from children will be reported rather than answered mid-flight. The final report (step 10) is a second, new comment. Never edit the epic body.

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
- History contract (the PR is part of a GitHub stack, which only merges when its history is linear):
  before opening the PR, and again after every round of review fixes, squash your branch to EXACTLY ONE
  commit whose parent is the current head of origin/<base branch> (`git fetch origin && git rebase
  origin/<base branch>` then `git reset --soft origin/<base branch> && git commit`), and push with
  `--force-with-lease`. NEVER merge <base branch> or the trunk into your branch — no "Update branch",
  no `git merge origin/main`. If <base branch> moves while you work, rebase onto its new head; do not
  merge it. The commit message is the PR title plus a body summarising the change.
- Do not touch work owned by sibling issues: <#N: area or paths derived from its acceptance criteria, ...>.
- No human will answer questions in this session. Do not stop to ask. Resolve ambiguity with the narrowest
  reading that satisfies the issue text and record it under Assumptions. Assumptions resolve how, never
  reduce what. If you must stop, the coordinating session may answer a how-question; it will not make product decisions.
- Genuinely blocked (contradictory requirements, missing credentials): comment on #<child> with exactly
  what you need, then end your turn with the single line: EPIC-CHILD-BLOCKED issue=<child> reason=<one sentence>

When the PR is open, end your turn with the single line (full PR URL, not a number):
EPIC-CHILD-DONE issue=<child> branch=<branch> pr=<https://github.com/owner/repo/pull/N>
```

For a child above the bottom of a chain (step 7), `<base branch>` is the head branch of the child directly below it, and the prompt adds: "Your workspace is based on branch `<below-branch>` (PR `<url>`, not yet merged). It already contains the work from <every issue below in the chain, e.g. #41 and #42>; import it, do not recreate or modify it. Open your PR against `<below-branch>`. The coordinator will link it into a GitHub stack; do not retarget it or write merge-order notes yourself. When the coordinator tells you `<below-branch>` has moved, rebase your single commit onto its new head (`git rebase --onto origin/<below-branch> <old base sha>`), resolve any conflict in your own code, keep it one commit, and push with `--force-with-lease`."

If `ws_send` is unavailable, drop the last sentence and the "the coordinating session may answer a how-question" clause: with no inbox, the child must be fully self-sufficient, and a chain layer that needs a cascade is respawned in step 8 rather than messaged.

### 5. Fan Out

One **workspace** per child — never two agents inside one workspace, because they would share a checkout and a branch. Name the workspace `<short-slug>-<child-number>`.

```bash
. /tmp/epic-<number>/runner.sh
ws=$(ws_create "<short-slug>-<child>" "issue-<child>-<short-slug>" "<base branch>" \
     /tmp/epic-<number>/prompt-<child>.md)
term=$(ws_agent "$ws")
link=$(ws_link "$ws")
printf '%s\t%s\t%s\t%s\t-\t%s\t-\t%s\n' "<child>" "$ws" "$term" "$link" "running" "base=<base branch>" \
  >> /tmp/epic-<number>/ledger.tsv
```

Children get `gh` credentials from the workspace's own setup, not from you; a child without them takes the blocked off-ramp and you report it.

**Ledger columns:** `issue  workspace  agent  link  lastSeen  phase  prUrl  notes`, tab-separated, with `-` for an empty cell (bash collapses empty tab-separated fields otherwise). `lastSeen` is a checksum of the transcript as of the last sweep, which is how the loop tells "nothing new" from "new output" without a server-side cursor. Phases: `running`, `asking`, `stalled`, `done`, `blocked`, `failed`, `skipped`, `not-started`. `notes` holds relayed decisions and merge-order facts, appended with `; `. The ledger is the only record of transcript checksums and decisions until the final report is posted; keep it current.

**Confirm each workspace provisioned, and read its branch back:** `ws_branch "$ws"` must be non-empty and is the branch you use from here on. Runners commonly namespace new branches under a project prefix, so the branch you asked for is not necessarily the branch you got — every prompt, stack link and rebase instruction downstream uses the real name. If the workspace never provisions, retry `ws_create` once, then record `failed`.

### 6. Watch

Poll from **one** background Bash loop, not a stream of individual tool calls. Save it as `/tmp/epic-<number>/poll-epic.sh`. **Stopped is not done** — `ws_state` says only whether the agent is busy; what it stopped *for* comes from the transcript. The loop exits after the first sweep that changes any phase, so you are woken to act; it may print several lines. Relaunch it after acting.

```bash
#!/bin/bash
# poll-epic.sh <epic-number>  — exits after a sweep that changed any phase, or when no child is running
. /tmp/epic-$1/runner.sh
L=/tmp/epic-$1/ledger.tsv
changed=0
while [ $changed = 0 ] && grep -q $'\trunning\t' "$L"; do
  while IFS=$'\t' read -r n ws term link seen phase pr notes; do
    [ "$phase" = running ] || continue
    state=$(ws_state "$ws" "$term") || state=gone
    [ "$state" = working ] && continue
    # No server-side cursor: read the whole transcript and checksum it to tell new output from none.
    ws_transcript "$ws" "$term" > /tmp/epic-$1/transcript-$n.txt 2>/dev/null
    now=$(shasum /tmp/epic-$1/transcript-$n.txt | cut -d" " -f1)
    # stopped with nothing new since the last sweep (e.g. just after a relay): still running
    [ "$now" = "$seen" ] && [ "$state" != gone ] && continue
    text=$(tail -200 /tmp/epic-$1/transcript-$n.txt)
    if   [ ! -s /tmp/epic-$1/transcript-$n.txt ];           then phase=stalled
    elif grep -q "EPIC-CHILD-DONE issue=$n "    <<<"$text"; then phase=done
         pr=$(grep -oE "EPIC-CHILD-DONE issue=$n [^\"]*pr=[^ \"]+" <<<"$text" | tail -1 | sed "s/.*pr=//")
    elif grep -q "EPIC-CHILD-BLOCKED issue=$n " <<<"$text"; then phase=blocked
    elif [ "$state" = gone ];                               then phase=stalled
    else phase=asking; fi
    echo "$(date -u +%FT%TZ) #$n state=$state -> $phase ${pr:--}"
    awk -F'\t' -v OFS='\t' -v n="$n" -v m="$now" -v p="$phase" -v u="${pr:--}" \
      '$1==n{$5=m;$6=p;$7=u}1' "$L" > "$L.tmp" && mv "$L.tmp" "$L"
    changed=1
  done < "$L"
  if [ $changed = 0 ]; then sleep 60; fi
done
```

Run it with `run_in_background`; act on every line it prints; relaunch.

Assume `ws_transcript` has **no cursor**: each sweep re-reads it whole and compares checksums, and `tail -200` is the classification window rather than the entire history. The sentinel match is therefore weaker than a cursor-paged one — a tool result that quotes `EPIC-CHILD-DONE` would match — which is exactly why **every `done` is cross-checked against `gh pr view` below** before it is believed. (If your runner does offer a blocking wait or an `--after` cursor, use it; the loop above is the portable floor, not a ceiling.)

Cross-check a `done` report before trusting it: `gh pr view <url> --json state,baseRefName,headRefName` must show an open PR. Take the real branch name from `headRefName`, not from the prompt. A `done` with no findable PR becomes `asking` — this is also the guard against a sentinel the agent merely quoted; message the child: "No open PR found for your branch. Push the branch, open the PR, and end with the EPIC-CHILD-DONE line again."

### 7. Grow Each Chain and Link the Stack

When a chain member's phase becomes `done` (verified, step 6) and `git ls-remote --heads origin <headRefName>` shows its branch, link first (below), then spawn the next child in that chain (step 4 and 5) with `<headRefName>` as the `ws_create` base — the layer below is what the new workspace *starts from*; the branch argument is still the child's own new branch. If the branch is not on origin, message the child: "Your branch is not on origin. Push it and end with the EPIC-CHILD-DONE line again," and set it back to `running`. The next child's PR targets that branch because waiting for a human to merge the layer below would outlive this session. If `gh pr view` shows the layer below already `MERGED`, base the next child on the base branch instead; merged layers are left out of `gh stack link`, and if every layer below has merged the child is standalone. A layer that merges *after* the child above was spawned is fine: GitHub retargets the child's PR to the base branch on its own.

Each child opens its PR against the right base itself, so `gh stack link` only has to record the chain. Link as soon as the second PR in a chain is verified `done`, **PR URLs only** (branch-name arguments make `gh stack link` push branches from your checkout, which does not have them):

```bash
# second PR of a chain: create the stack, bottom to top
gh stack link <bottom PR URL> <next PR URL>
# every later PR: grow the stack by number
gh stack link <stack-number> <next PR URL>
```

Pass `--base <integration branch>` when the epic named one other than the repository default. Do not trust the command's output, or its silence, to tell you what GitHub recorded; read it back:

```bash
gh api graphql -f query='{ repository(owner:"<owner>",name:"<repo>"){ pullRequest(number:<bottom PR>){ stack { number baseRefName size entries(first:20){ nodes { position pullRequest { number headRefName baseRefName } } } } } } }'
```

`stack.number` is the stack number; `entries` must list every PR of the chain in order. (`added_to_stack` also appears on each PR's issue timeline.) Append `stack=<number>` to the `notes` of every PR in the chain. If the link command fails or the stack is missing a PR, record it in `notes`, keep spawning, and retry the link during step 9 with the same URLs. Never put two chains, or a standalone PR, into one stack: a stack merges atomically and in order, so stacking unrelated work makes one blocked review hold all of them.

**Keep the stack linear.** Whenever a layer's head moves — review fixes, a rebase onto a moved trunk — every layer above it is now non-linear and must be rebuilt, bottom-up, one at a time:

1. Record the moved layer's old and new head SHAs.
2. `ws_send` the child directly above it: "`<below-branch>` moved from `<old sha>` to `<new sha>`. Rebase your single commit onto it: `git fetch origin && git rebase --onto origin/<below-branch> <old sha>`, resolve conflicts in your own code only, keep it one commit, push with `--force-with-lease`, then end with the EPIC-CHILD-DONE line again." Set its phase to `running`.
3. When it reports done, verify (step 9), then repeat for the next layer up, with this layer's old and new SHAs.

Only the bottom layer ever rebases onto the trunk, and only when the trunk has moved in a way GitHub reports as non-linear or a ruleset requires an up-to-date branch; it does so the same way (rebase, one commit, lease), and then the cascade above runs. If every child in a chain is idle and the layers are single commits, the coordinator may run the cascade itself with `gh stack rebase` followed by `gh stack push` from a checkout that has the branches; a conflict stops it and lists files — do not resolve those yourself, hand them to the layer's child. Where `ws_send` is unavailable, the coordinator-side `gh stack rebase` path and a respawn with a cascade-specific prompt are the only two options; pick the first when the layers are clean, and report the chain as needing a human when neither works.

### 8. Unblock

A child in `asking` stopped without a sentinel line. Read the assistant text at the end of `/tmp/epic-<number>/transcript-<n>.txt` and decide:

- **How-question** (file location, naming, which pattern, whether to proceed without approval, PR base, which existing signal to use for a concept like "new user"): answer from the epic thread, the child issue, sibling transcripts, and repo conventions:
  ```bash
  ws_send "$ws" "$term" "<answer>. Record this under Assumptions in the plan and PR body. Do not ask again; keep going and end with the EPIC-CHILD-DONE line."
  ```
  Set the phase back to `running` and append `relayed: <question> → <answer>` to `notes`.
- **What-question** (product behaviour or scope the issues do not settle): do not invent an answer. Tell the child to implement only what the issue text states, list the open question in the PR body under "Open questions for reviewer", and finish. If it truly cannot proceed, tell it to take the blocked off-ramp.
- **`stalled`** (an empty transcript, an agent that is `gone`, or a runner error): retry once by re-running `ws_create`'s agent step against the same workspace — or, if the runner has no way to restart an agent in place, `ws_create` a fresh workspace on the **same existing branch**. Replace `agent` in the ledger and reset `lastSeen` to `-`; a second stall is `failed`. The worktree and branch survive, so the new agent picks up where the old one left off.
- **No `ws_send`:** record the question verbatim in `notes`, leave the phase at `asking`, and carry it into the final report as an open question for the developer. Do not implement the child yourself and do not guess a product decision to keep it moving.

Every relay is a decision made on the developer's behalf — it goes in `notes` and in the report. Never shut down a child for asking; shut one down only when it is still `working` past the wall-clock budget with no pushed commits, and say so.

**Review fixes go into the layer's single commit.** When findings are relayed to a child, its instruction ends with the history contract from step 4: squash the fixes into the one commit, rebase onto the current head of the layer below, push with `--force-with-lease`, then the sentinel. A layer that moves this way triggers the cascade in step 7 for everything above it, so relay review findings to lower layers first and let each cascade finish before relaying to the next layer up.

### 9. Verify

For each `done` PR:

```bash
gh pr view <url> --json number,url,state,isDraft,baseRefName,headRefName,body,mergeable,statusCheckRollup
gh pr diff <url> --name-only | sort > /tmp/epic-<number>/files-<child>.txt
```

Checks: open, not draft, expected base, body contains `Fixes #<child>` (a `Refs #<child>` means the child is **incomplete** — report it that way), `## Assumptions`, and `## Verification`. Read CI status once; do not wait on it.

Then intersect the changed-file lists pairwise (`comm -12`), skipping pairs that are both in the same chain, since those already build on each other. Two PRs that touch the same file are a dependency the issues did not declare, so treat them as a chain: pick the landing order (a chain member before a standalone PR; otherwise the smaller change goes second; a standalone joining a chain rebases onto the chain's top) and `ws_send` the second PR's agent — "Rebase your single commit onto `origin/<first headRefName>` with `--force-with-lease`, retarget the PR base to that branch with `gh pr edit --base`, then end with the EPIC-CHILD-DONE line again" — set its phase back to `running` so the loop catches the second sentinel, then link the pair with `gh stack link` as in step 7. The child does the rebase, not you: it has the context to resolve conflicts in code you never read.

Then confirm every chain is **linear**, with git, not with the PR page:

```bash
git fetch origin <trunk> <every layer branch>
# for each layer, bottom to top: exactly one commit beyond the layer below, whose parent IS the layer below's head
git rev-list --count origin/<below>..origin/<layer>          # must print 1
git rev-parse origin/<layer>^                                 # must equal: git rev-parse origin/<below>
```

Any layer that fails either check has a merge commit or a stale base; run the cascade from step 7 starting at the lowest failing layer. Also confirm, for each PR above the bottom, that `gh pr view <url> --json baseRefName` equals the `headRefName` of the PR below it (or the trunk if the PR below is `MERGED`), and re-read the stack through the GraphQL query in step 7 so `entries` lists every PR. Any mismatch goes back to the PR's agent with a retarget message.

Read the trunk's rulesets once (`gh api repos/<owner>/<repo>/rules/branches/<trunk>`): a `required_status_checks` rule with `strict_required_status_checks_policy: true` means the bottom PR must also contain the trunk's current head before it can merge, so if the trunk has moved, the bottom layer rebases onto it and the cascade runs before you report the stack as ready.

### 10. Report

Post one new comment on the epic containing, per child: issue, PR link, base branch, CI state, workspace link (`ws_link`), stack number (or "standalone"), and the `notes` (assumptions, relayed decisions, open questions, blocked reasons). For each stack, give the one-line landing instruction: `gh stack merge <stack-number> --squash` merges the whole chain atomically and in order, one squash commit per layer on the trunk (match the repository's usual merge method if it differs; every layer is already a single commit, so the content is the same either way). Standalone PRs merge individually in any order. Then reply to the developer with the same table.

- Links, not raw handles — they are clickable.
- Leave child workspaces and agents alive. Reviewers send follow-ups to the agent that wrote the PR; tear one down only when the developer asks — removing a workspace deletes its worktree and any uncommitted work in it.
- Do not tick the epic's task list by hand; `Fixes #<child>` closes each child on merge.
- If any child is `blocked`, `failed`, `skipped`, `stalled`, `asking`, or `not-started`, the epic is not done. Say so plainly, and list every unanswered question.

## Absolute Rules

- **Coordinate, never implement**: a child issue is always done by a child workspace, even the "quick" one
- **One workspace per child**: never two agents sharing a worktree
- **Never merge**: the PR is the approval gate for each child, exactly as in `working-on-an-issue`; a standing "don't merge" instruction on the epic outranks any urgency in the request. `gh stack merge` is for the reviewer, never for you
- **Tool specifics live in step 0 only**: every later step calls `ws_*`; a raw runner command anywhere else is a bug
- **One stack per dependency chain**: independent PRs stay standalone
- **One commit per layer, always linear**: a layer is a single squashed commit on the current head of the layer below; a layer never merges its base or the trunk into itself
- **Cascade bottom-up, with lease**: when a layer moves, every layer above is rebased onto it in order, each push `--force-with-lease`; never leave a chain half-cascaded
- **Stopped is not done**: only the `EPIC-CHILD-DONE` line plus a verified PR counts
- **Answer how, escalate what**: relayed decisions are logged; product decisions are not invented
- **Report honestly**: skipped, blocked, stalled, asking, and failed children are listed, not summarised away

## Quick Reference

**Runner contract (bind in step 0, call everywhere else):**

| Need | Call | Shape |
|------|------|-------|
| Spawn a child | `ws_create <name> <branch> <base> <promptfile>` | the workspace handle, alone |
| Its agent | `ws_agent <ws>` | agent handle; empty if none |
| Branch it actually got | `ws_branch <ws>` | branch name; **read it back, never assume** |
| Busy or stopped? | `ws_state <ws> <agent>` | `working` \| `stopped` \| `gone` |
| Transcript | `ws_transcript <ws> <agent>` | the agent's own messages; assume **no cursor** — re-read and checksum |
| Talk to a child | `ws_send <ws> <agent> <text>` | nothing; may be unsupported — then step 8 is report-only |
| Link for the developer | `ws_link <ws>` | URL or absolute worktree path |

**GitHub and git (tool-independent):**

| Need | Command | Shape |
|------|---------|-------|
| Children issues | GraphQL `issue(number){subIssues{nodes{number}}}` | resolves on GitHub today |
| Stack existing PRs | `gh stack link <PR URL> <PR URL> …` (bottom to top) or `gh stack link <stack-number> <PR URL>` | creates or grows the stack on GitHub; no local tracking needed; may print nothing through a `gh` wrapper |
| Read a stack back | GraphQL `pullRequest(number){ stack { number size entries(first:20){ nodes { position pullRequest { number } } } } }` | the stack number and ordered members GitHub actually recorded |
| Confirm a chain | `gh pr view <url> --json baseRefName,headRefName` per layer | each base equals the head below it |
| Confirm linearity | `git rev-list --count origin/<below>..origin/<layer>` and `git rev-parse origin/<layer>^` | `1`, and the head of `<below>` |
| Cascade after a layer moved | child: `git rebase --onto origin/<below> <old base sha>` + `--force-with-lease`; coordinator fallback: `gh stack rebase` then `gh stack push` | bottom-up, one layer at a time |
| Land a stack (reviewer, not you) | `gh stack merge <stack-number> --squash` | atomic, in order, all or nothing; requires a linear stack |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Calling the runner's CLI directly in steps 1–10 | Every tool-specific command belongs in `runner.sh`; the process must read the same whichever runner is bound |
| Passing a runner's own state word into the poll loop | `ws_state` returns only `working`/`stopped`/`gone`; do the mapping inside the function, once |
| Treating a stopped agent as finished | Stopped is the normal end of a turn; only the sentinel line plus `gh pr view` is done, everything else is `asking` or `stalled` |
| Treating a runner's `blocked` as GitHub's `BLOCKED` | A runner's `blocked` means "waiting for input" (classify it as `stopped`, phase `asking`); GitHub's `BLOCKED` merge state usually means CI is still running |
| Trusting a sentinel found in the transcript | A cursorless transcript returns tool output too, so a quoted `EPIC-CHILD-DONE` can match; only the sentinel **plus** a verified `gh pr view` is `done` |
| Leaving a multi-fleet runner unscoped | Children get created on one target and listed from another; put the scoping flag inside every `ws_*` body |
| Assuming the branch you asked for is the branch you got | Runners namespace branches under a project prefix; `ws_branch` before using the name anywhere |
| Implementing a child yourself because `ws_send` is missing | Report the question in `notes` and in the final comment; a coordinator that implements stops coordinating |
| Starting a chain member from the base branch because the layer below is "basically done" | Wait for its verified `done` and its branch on origin, then base on that branch |
| Running a linearised sibling in parallel and rebasing it later | Spawn along the chain; an out-of-order rebase across sessions has to be repeated for every layer above it |
| Stacking independent PRs "to keep things together" | One stack per dependency chain; a stack merges atomically, so unrelated work would block each other |
| Letting a layer merge its base or the trunk into itself ("Update branch", `git merge origin/main`) | The stack is no longer linear and GitHub refuses to merge it; the fix is a rebase cascade through every layer above. Rebase onto the moved base instead, one commit, `--force-with-lease` |
| Passing branch names to `gh stack link` | PR URLs only; branch arguments are pushed from your checkout, which lacks them |
| Trusting `gh stack link`'s output, or its silence | Read the stack back through the GraphQL `stack` field; a `gh` wrapper can swallow the extension's output |
| Rebasing a child's branch yourself to fix a stack | Message the child's agent; it has the context to resolve conflicts. `gh stack rebase` is a fallback only when every layer is one clean commit |
| Relaying review findings to an upper layer while a lower layer is still being fixed | Fix bottom-up; every lower move re-cascades the layers above it, so upper fixes done first are rebased twice |
| Checking out a stack in the coordinator's workspace | It switches your checkout and creates local tracking you do not need; confirm chains with `gh pr view` |
| Scraping a child's visible pane instead of its transcript | A screen scrape loses scrollback and includes UI chrome; `ws_transcript` must be bound to the agent's own messages |
| Polling with dozens of separate tool calls, or a loop that never returns | One background loop that exits on the first phase change |
| Merging because the developer said "get it landed" | Landed means reviewable PRs; a standing "don't merge" comment on the epic outranks urgency |
| Implementing "just the small one" yourself | Spawn it; the coordinator that implements stops coordinating |
| Tearing down child workspaces at the end | Leave them for reviewers; teardown is the developer's call |
| Spawning children inside your own workspace | They would share your branch and checkout; always `ws_create` |
| Keeping the ledger only in your head | `/tmp/epic-<n>/ledger.tsv` and `runner.sh` survive context compaction; your memory does not |
