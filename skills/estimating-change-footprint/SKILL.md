---
name: estimating-change-footprint
description: Use when writing or refining a GitHub issue that needs a cost estimate, when asked to estimate, size, budget or forecast agent spend on work, or when deciding whether an item is an issue or an epic - gives an issue a change footprint (expected lines changed and expected files read, each in a bucket) that predicts coding-agent token spend, recorded as labels, a Footprint section, and a project field
metadata:
  version: "0.1.0"
  calibration: "2026-10 · sandgardenhq/gloria.dev · 77 issues"
---

# Estimating Change Footprint

## Overview

**Core principle:** estimate what the agent will have to *change* and *read*, not how hard the work feels. Token spend on an issue is driven by the size of the diff and the amount of code the agent must hold in context to make it. Story points estimate effort; this skill estimates footprint, and footprint is what the bill tracks.

A footprint has two dimensions, recorded separately:

- **Diff size** — expected lines added plus deleted in the merged change.
- **Read scope** — expected distinct files the agent must read to make the change correctly: the files it edits, plus the callers, tests, types, configs and docs it has to understand first.

Each dimension goes in a bucket. The two buckets are never multiplied into one number; they are reported side by side, and expected tokens come from a calibration table that weights diff size heavily and read scope lightly.

Only issues get a footprint. An epic's footprint is the sum of its children's diff sizes and the sum of their read scopes, recomputed whenever a child changes.

**Why this and not points.** On 77 closed issues in `sandgardenhq/gloria.dev` with merged PRs, a log-log fit of tokens on lines changed explained 61% of the variance in spend; adding files read brought it to 65%; story points explained 29% and added nothing once lines were known. Points and footprint can coexist (see Integration), but when the question is "what will this cost," footprint is the estimate to trust.

This skill is for an agent estimating on its own while it writes or refines a work item. It is not a planning-poker facilitator.

## When to Use

- Writing an issue (by hand, or via `issue-decomposition` or `writing-user-stories`) that needs a cost estimate
- Asked to estimate, size, budget or forecast agent spend on an issue, an epic, or a backlog
- Deciding whether an item is an issue or an epic
- Re-checking a footprint after an item's scope changed
- Closing the loop after merge: recording the actual footprint beside the estimate

**Not for:** time estimates, scheduling, or effort in hours. `timeline-planning` reads points, not footprint. If a repo wants both, estimate both; see Integration.

## The Scales

### Diff size (lines added + deleted in the merged change)

| Bucket | Lines | What it looks like |
|---|---|---|
| **XS** | under 100 | One function, a config value, a wording fix, a test pin |
| **S** | 100–300 | One component or endpoint touched end to end, with its test |
| **M** | 300–1,000 | A new component with tests, or a change that threads through several files |
| **L** | 1,000–3,000 | A new subsystem, a migration with DAO and UI, a multi-file refactor |
| **XL** | 3,000–10,000 | The ceiling for an issue. Consider splitting. |

Anything expected above 10,000 lines is an epic, whatever it was called when it arrived.

### Read scope (distinct files the agent must read)

| Bucket | Files | What it looks like |
|---|---|---|
| **R1** | 1–3 | The edited file and its test; nothing else needs understanding |
| **R2** | 4–10 | Edited files plus their immediate callers, the shared type, the schema |
| **R3** | 11–30 | A change that crosses a package boundary, or touches a widely imported module |
| **R4** | over 30 | A cross-cutting change: a rename, a shared interface, a convention applied repo-wide |

Rules the scales depend on:

- **Exactly one bucket per dimension.** No ranges, no "S or M".
- **Both dimensions are always recorded**, even when one is obvious.
- **Lines are the merged diff, not the agent's edits.** A file written three times counts once, at its final size. Generated files (lockfiles, snapshots, fixtures) count unless the repo's calibration file says to exclude them.
- **Read scope counts files, not reads.** A file read twice is one file. Files touched only by a search tool (grep, glob) do not count; files whose contents the agent must take in do.

## Process

### Step 0: Gather

- The item text, including comments if it already exists (`gh issue view <n> --comments`).
- The repo's calibration file, `docs/estimation/footprint-calibration.md`, if it exists. Otherwise use the default table in [Calibration](#calibration).
- The repo's label vocabulary (`gh label list`) and whether it has a GitHub Project with a number field named Expected Tokens, Footprint or similar (`gh project field-list <number> --owner <owner>`).
- Access to the repo's source. Footprint is estimated by looking at the code, never from the title alone.

### Step 1: Estimability gate

Write one sentence that names the files, or the kinds of files, the change will touch. If you can write it, continue.

If you cannot, because the item names a goal with no implementation shape ("make search better", "reduce flakiness"), **do not estimate it**. Either ask the author the one or two questions whose answers would reveal where the change lands, or rewrite the item as a time-boxed **spike** whose deliverable is a written finding and follow-up issues. A spike gets a footprint of XS · R2 by convention (it reads, it does not change) and the `spike` label.

### Step 2: Enumerate the change

List every file you expect the change to create or modify, with a rough line count for each. Use the repo to do this: open the files, find the pattern the change follows, look at how the last similar change was shaped (`git log --stat` on a comparable PR is the fastest calibration there is).

```
packages/core/src/cost/usage-statements.ts   +60  (new statement builder)
packages/core/src/cost/usage-dao.ts          +25  (thin DAO)
packages/core/src/__tests__/usage-dao.test.ts +120 (tests, TDD)
packages/web/migrations/0107_x.sql           +15
packages/miranda-web/src/app/.../page.tsx    +90  (new section)
                                             ----
                                             ~310 → M
```

Sum the lines. That is the diff size. Round to the bucket.

### Step 3: Enumerate the reading

Starting from the files in Step 2, list what the agent must understand to change them safely:

- the files being edited;
- their direct callers and the interfaces they implement;
- the tests that exercise them;
- the schema, migration or type definitions they depend on;
- any `CLAUDE.md`, `CODING-STANDARDS.md` or design doc the repo requires reading for that area;
- for a change that follows a pattern, one canonical example of the pattern.

Count distinct files. Use `grep -rl` for callers rather than guessing. That is the read scope. Round to the bucket.

Read scope is where the estimate is most often wrong, in the same direction: a change to a widely imported module looks small in lines and large in reading. If the edited file has more than ten importers, the read scope is at least R3.

### Step 4: Derive expected tokens

Look up the diff bucket in the calibration table and apply the read-scope multiplier. Record the result as a single expected-tokens figure plus the band from the calibration file.

### Step 5: Issue or epic

If the diff size is above XL, or the change clearly decomposes into independently mergeable parts each with its own tests:

1. Label the item `epic`. It gets no buckets of its own yet.
2. Hand it to `issue-decomposition` to produce child issues. Every child gets its own footprint by this process. A child above XL is itself an epic.
3. The epic's footprint is the sum of the children's expected lines and the sum of their expected files read, with expected tokens summed from the children. Record it when the children exist; recompute when they change.

Prefer splits that produce children with similar footprints and that keep each child's read scope small. Splitting by file cluster (everything in `core`, then everything in `web`) usually does that; splitting by layer across every file does not.

### Step 6: Record the footprint

1. **Labels**: `diff-<bucket>` and `reads-<bucket>`, for example `diff-M` and `reads-R2`. Create them if the repo does not have them. When re-estimating, remove the old labels first. An epic gets `epic` and no `diff-`/`reads-` labels; its totals live in the body and the project field.

   ```bash
   gh label create diff-M  --color 1D76DB --description "Expected diff: 300–1,000 lines" 2>/dev/null
   gh label create reads-R2 --color 5319E7 --description "Expected read scope: 4–10 files" 2>/dev/null
   gh issue edit <n> --remove-label diff-S --add-label diff-M
   ```

2. **Body**: a `## Footprint` section using the contract below, placed after the acceptance criteria. When re-estimating, rewrite the section; do not stack old ones.

3. **Project field**: if the repo has a GitHub Project with a number field for expected tokens, set it (in millions). For an epic, set it to the children's sum. If there is no such field, say so and skip it.

### Step 7: Close the loop after merge

When the issue's PR merges, append an `Actual:` line to the Footprint section with the merged diff size (from the PR's additions + deletions) and, where the team runs Miranda, the measured tokens and files read. This is what the calibration file is rebuilt from, and it is the whole reason footprint beats points: the estimate and the measurement are in the same units.

```markdown
Actual: 412 lines · 7 files read · 11.8M tokens (PR #1988, merged 2026-10-29)
```

If an automation does this, it says so in the provenance line; otherwise the agent closing the issue does it.

### Footprint section contract

The first line after the heading starts with `**Footprint:**` and carries both buckets and the numbers behind them in a fixed shape, so `timeline-planning`, cost dashboards and the calibration script can parse it without reading prose. The last line before any `Actual:` line is the [provenance line](#provenance-line).

```markdown
## Footprint
**Footprint: M · R2** — ~310 lines changed, ~7 files read
**Expected tokens: ~12M** (band 7M–20M, calibration 2026-10)

Change:
- packages/core/src/cost/usage-statements.ts +60 (new statement builder)
- packages/core/src/cost/usage-dao.ts +25
- packages/core/src/__tests__/usage-dao.test.ts +120
- packages/web/migrations/0107_x.sql +15
- packages/miranda-web/src/app/(app)/usage/page.tsx +90

Read: the five above, plus usage-schema.ts and the existing getUserSpendForPeriod as the pattern to follow.
Main unknown: whether page.tsx needs a new component or extends UsageTable.
Estimated by: claude-opus-5-5 in Claude Code 2.1.310, estimating-change-footprint 0.1.0
```

For an epic the first line is `**Footprint: epic** — ~N lines changed, ~M files read (sum of children)`, followed by a `Children:` line listing each child with its buckets:

```markdown
## Footprint
**Footprint: epic** — ~4,200 lines changed, ~38 files read (sum of children)
**Expected tokens: ~95M** (sum of children)

Children: #41 IdP metadata config (M · R2), #42 SP metadata endpoint (S · R1), #43 assertion consumer (L · R3), #44 SSO-only login setting (XS · R1)
Estimated by: gpt-5.6-sol in Codex CLI, estimating-change-footprint 0.1.0
```

An epic that has not been decomposed yet says `**Footprint: not yet estimated** (epic, awaiting decomposition)` followed by the provenance line.

### Provenance line

```markdown
Estimated by: <model> in <harness>, estimating-change-footprint <version>
```

Same rules as `estimating-work-items`: the exact model ID (never a marketing name; `unknown-model` if you cannot tell), the harness with its version if findable and `(via <tool>)` if an outer tool is driving it, and this skill's `metadata.version` copied as written. A person's estimate is `Estimated by: human (@handle), estimating-change-footprint 0.1.0`. One line, always current; replace it on re-estimate.

Tools parse it the same way as the points skill's line: it starts with `Estimated by: ` and ends with `, estimating-change-footprint <version>`.

## Calibration

The default table was fitted on 77 closed issues in `sandgardenhq/gloria.dev` (one developer, Claude Code, Aug–Oct 2026) with merged PRs and Miranda session data. The fit is

```
tokens ≈ 0.083M × lines^0.755 × files^0.207
```

with a residual band of ±1.65× (68% of issues land within that factor of the prediction). That is the default; a repo should replace it with its own numbers as soon as it has 30+ closed issues with `Actual:` lines.

### Expected tokens by diff bucket, at R1

| Bucket | Midpoint lines | Expected tokens |
|---|---|---|
| XS | 50 | ~2M |
| S | 175 | ~5M |
| M | 550 | ~11M |
| L | 1,700 | ~26M |
| XL | 5,500 | ~63M |

### Read-scope multiplier

| Bucket | Midpoint files | Multiplier |
|---|---|---|
| R1 | 2 | ×1.0 |
| R2 | 6 | ×1.25 |
| R3 | 18 | ×1.6 |
| R4 | 50 | ×2.0 |

So an M · R2 issue is ~11M × 1.25 ≈ 14M, with a band of roughly 8M–23M.

### Recalibrating

A repo-local `docs/estimation/footprint-calibration.md` overrides the defaults. Build it from closed issues that have an `Actual:` line, or directly from the warehouse where the team runs Miranda:

```sql
-- tokens on sessions attributed to each closed issue, with merged-PR lines and distinct files read
SELECT i.issue_number,
       SUM(p.additions + p.deletions)                         AS lines,
       COUNT(DISTINCT c.file_path) FILTER (WHERE t.tool_name = 'Read') AS files_read,
       SUM(s.input_uncached_tokens + s.cache_read_tokens
         + s.cache_write_tokens + s.output_tokens)            AS tokens
FROM fct_session s
JOIN dim_issue i                 ON i.issue_key = s.work_item_key
JOIN bridge_session_pull_request b USING (session_key)
JOIN dim_pull_request p          USING (pull_request_key)
LEFT JOIN fct_tool_call c        USING (session_key)
LEFT JOIN dim_tool t             USING (tool_key)
WHERE p.merged_at IS NOT NULL AND i.closed_at IS NOT NULL
GROUP BY 1;
```

Fit `ln(tokens)` on `ln(lines)` and `ln(files_read)`, write the coefficients, the band, the date and the sample size into the calibration file, and regenerate the two tables above. Keep the previous table in the file under a dated heading so estimates made against it can still be read.

The calibration file also records repo conventions: whether generated files count toward lines, which directories are excluded, and what counts as a "read" (the agent's `Read` tool only, or `cat`/`sed` in a shell too).

## Splitting an Oversized Item

An issue above XL, or an L/XL whose read scope is R4, is split into child issues. Each child must be mergeable and testable on its own; never split by layer. Patterns, footprint-oriented:

| Pattern | Split by |
|---|---|
| File cluster | Everything in one package first, then the next; keeps each child's read scope small |
| Schema first | The migration + DAO + statement builder as one child, every consumer as later children |
| Pattern then instances | One canonical instance of a repo-wide change, then the remaining instances as a follow-up with a tiny read scope |
| Simple path first | The minimal end-to-end change, then each variation as its own child |
| Isolate the wide read | Put the change to the widely-imported module in its own child so only that child carries R3/R4 |
| Spike | When the files can't be named yet. Last resort. |

Prefer the split where the children's read scopes don't overlap much; overlapping read scope means the same files get loaded into context twice.

## Anti-patterns

| Pattern | Why it fails | Do instead |
|---|---|---|
| Estimating from the title ("add a flag, so XS · R1") | Skips the enumeration that finds the ten callers | Open the files; `grep -rl` the importers (Steps 2–3) |
| Counting the agent's edits instead of the merged diff | A file written five times is not five files' worth of diff | Estimate the final diff; the PR's additions + deletions is the ground truth |
| Multiplying the buckets into one number | Files read matter far less than lines; a product over-weights them | Record both; use the calibration table for the combined figure |
| Converting footprint to hours | Nothing here predicts duration; it predicts spend | Leave duration to points and `timeline-planning` |
| Skipping the `Actual:` line | The calibration never improves and the estimate never gets checked | Close the loop at merge, by hand or automation |
| Re-estimating merged work | Rewrites history | Leave it; fix the calibration file instead |
| Using the default calibration past 30 closed issues | Another team's coefficients, another agent's habits | Rebuild the repo-local file |
| Treating a long session as a big footprint | A 150M session on a 300-line change is a session-hygiene problem, not a diff-size one | Flag it in the `Actual:` line; don't inflate the next estimate to match |

## Worked Example

Item: "Add a `--json` flag to `shiplog list` so the output can be piped to jq. The table output must stay the default."

- **Files named:** `cmd/shiplog/list.go`, its test, and the render package's `Table` helper — the gate passes.
- **Change:** `list.go` +40 (flag, branch), `list_test.go` +70 (JSON shape, empty case), `render/json.go` +45 (new), `docs/cli.md` +10. Sum ~165 → **S**.
- **Read:** the four above, plus `render/table.go` (to learn the value-formatting rules), `cmd/shiplog/root.go` (flag registration pattern), and one existing `--json` implementation elsewhere in the repo as the canonical example. Seven files → **R2**.
- **Expected tokens:** S at R1 is ~5M; × 1.25 for R2 ≈ **6M**, band 4M–10M.
- **Record:** labels `diff-S`, `reads-R2`; Footprint section with the file list and the unknown ("does `render.Table` format values the JSON should carry raw?"); project field 6.

## Integration

- **`estimating-work-items`** (story points) can run alongside this skill. Points answer "how big is this relative to other work"; footprint answers "what will the agent spend". An issue may carry both a `points-<n>` label and `diff-`/`reads-` labels. When a repo uses both, write the Footprint section directly after the Estimate section.
- **`issue-decomposition`** runs this skill for every child it produces and keeps each one at XL or below; the epic's footprint is the sum.
- **`writing-user-stories`** treats a story above XL, or at R4, as a sign the story is too large.
- **`working-on-an-issue`** reads the `Change:` list as a starting plan and the `Read:` list as the files to load first; it appends the `Actual:` line when it finishes.
- **Miranda** dashboards read the first two lines of the Footprint section (buckets, expected tokens) and the `Actual:` line to report estimate-vs-actual per issue and to drive recalibration.
