---
name: estimating-change-footprint
description: Use when writing or refining a GitHub issue that needs a cost estimate, when asked to estimate, size, budget or forecast agent spend on work, or when deciding whether an item is an issue or an epic - gives an issue a change footprint (expected lines changed and expected files read, each in a bucket) that predicts coding-agent token spend, recorded as labels, a Footprint section, and a project field
metadata:
  version: "0.2.0"
  calibration: "2026-11 · sandgardenhq/gloria.dev · 103 issues"
---

# Estimating Change Footprint

## Overview

**Core principle:** estimate what the agent will have to *change* and *read*, not how hard the work feels. Token spend on an issue is driven by the size of the diff and the amount of code the agent must hold in context to make it. Story points estimate effort; this skill estimates footprint, and footprint is what the bill tracks.

A footprint has two dimensions, recorded separately:

- **Diff size** — expected lines added plus deleted in the merged change.
- **Read scope** — expected distinct files the agent must read to make the change correctly: the files it edits, plus the callers, tests, types, configs and docs it has to understand first.

Each dimension goes in a bucket, and the two buckets are recorded side by side as separate labels. Expected tokens come from the numbers behind the buckets: the calibration fit takes the product of expected lines and expected files read, so a large diff with a small read scope and a small diff with a wide read scope can cost the same.

Only issues get a footprint. An epic's footprint is the sum of its children's diff sizes and the sum of their read scopes, recomputed whenever a child changes.

**Why this and not points.** On 117 closed issues in `sandgardenhq/gloria.dev` with merged PRs (November 2026), the calibration fit's prediction explained 51% of the variance in log token spend and landed within 2× of the actual for 78% of issues; story points explained 37%. Points and footprint can coexist (see Integration), but when the question is "what will this cost," footprint is the estimate to trust.

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

Put the line count from Step 2 and the file count from Step 3 into the calibration fit:

```
expected tokens = 373,785 × (lines × files)^0.432
```

Use the numbers you enumerated, not the bucket midpoints; the buckets are for the labels. Round to the nearest million (the nearest 0.5M below 5M) and record it with its band, the prediction divided and multiplied by the band factor (1.9 in the default calibration). The [grid](#expected-tokens-by-bucket) is a sanity check, and the fallback when only the buckets are known.

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
**Expected tokens: ~10M** (band 5M–20M, calibration 2026-11)

Change:
- packages/core/src/cost/usage-statements.ts +60 (new statement builder)
- packages/core/src/cost/usage-dao.ts +25
- packages/core/src/__tests__/usage-dao.test.ts +120
- packages/web/migrations/0107_x.sql +15
- packages/miranda-web/src/app/(app)/usage/page.tsx +90

Read: the five above, plus usage-schema.ts and the existing getUserSpendForPeriod as the pattern to follow.
Main unknown: whether page.tsx needs a new component or extends UsageTable.
Estimated by: claude-opus-5-5 in Claude Code 2.1.310, estimating-change-footprint 0.2.0
```

For an epic the first line is `**Footprint: epic** — ~N lines changed, ~M files read (sum of children)`, followed by a `Children:` line listing each child with its buckets:

```markdown
## Footprint
**Footprint: epic** — ~4,200 lines changed, ~38 files read (sum of children)
**Expected tokens: ~52M** (sum of children)

Children: #41 IdP metadata config (M · R2), #42 SP metadata endpoint (S · R1), #43 assertion consumer (L · R3), #44 SSO-only login setting (XS · R1)
Estimated by: gpt-5.6-sol in Codex CLI, estimating-change-footprint 0.2.0
```

An epic that has not been decomposed yet says `**Footprint: not yet estimated** (epic, awaiting decomposition)` followed by the provenance line.

### Provenance line

```markdown
Estimated by: <model> in <harness>, estimating-change-footprint <version>
```

Same rules as `estimating-work-items`: the exact model ID (never a marketing name; `unknown-model` if you cannot tell), the harness with its version if findable and `(via <tool>)` if an outer tool is driving it, and this skill's `metadata.version` copied as written. A person's estimate is `Estimated by: human (@handle), estimating-change-footprint 0.2.0`. One line, always current; replace it on re-estimate.

Tools parse it the same way as the points skill's line: it starts with `Estimated by: ` and ends with `, estimating-change-footprint <version>`.

## Calibration

The default fit was made on 103 closed issues in `sandgardenhq/gloria.dev` with a merged PR (Claude Code, Oct–Nov 2026, fitted 2026-11-02), regressing the issue's actual tokens from coding sessions on its **estimated** lines and files read, as written in the Footprint section:

```
tokens ≈ 373,785 × (lines × files)^0.432
```

`lines` and `files` are the estimate's `~N lines changed` and `~M files read`; tokens are uncached input + cache read + cache write + output. Because the fit is on estimates, it already absorbs how far estimates tend to drift from the merged diff and from what the agent actually reads. The residual band is ×/÷1.9 (68% of issues land within that factor; 78% within 2×). The prediction is a median: on a log-log fit the mean is about 20% higher, so the actual total over many issues runs about 20% above the sum of their predictions. A repo should replace the default with its own fit as soon as it has 30+ closed issues with a footprint and measured tokens.

### Expected tokens by bucket

At each bucket's midpoint (lines 50, 175, 550, 1,700, 5,500; files 2, 6, 18, 50):

| Diff \ Reads | R1 | R2 | R3 | R4 |
|---|---|---|---|---|
| XS | ~2.5M | ~4.5M | ~7M | ~11M |
| S | ~5M | ~8M | ~12M | ~19M |
| M | ~8M | ~12M | ~20M | ~31M |
| L | ~13M | ~20M | ~32M | ~50M |
| XL | ~21M | ~34M | ~54M | ~84M |

So an M · R2 issue at its midpoints (550 lines, 6 files) is ~12M, band 6M–24M.

### Recalibrating

A repo-local `docs/estimation/footprint-calibration.md` overrides the defaults. Build it from closed issues that have an `Actual:` line, or directly from the warehouse where the team runs Miranda:

```sql
-- one row per closed issue: merged-PR lines, distinct files read, attributed tokens.
-- Each measure is aggregated in its own CTE: joining tool calls or PRs to sessions
-- before summing would count each session's tokens once per tool call and each PR's
-- lines once per session.
WITH tokens AS (
    SELECT work_item_key AS issue_key,
           sum(input_uncached_tokens + cache_read_tokens
             + cache_write_tokens + output_tokens) AS tokens
    FROM fct_session WHERE work_item_key <> 0 GROUP BY 1
),
files AS (
    SELECT s.work_item_key AS issue_key, count(DISTINCT c.file_path) AS files_read
    FROM fct_tool_call c
    JOIN fct_session s        ON s.session_key = c.session_key
    JOIN dim_tool_category tc ON tc.tool_category_key = c.tool_category_key
    WHERE s.work_item_key <> 0 AND tc.tool_category = 'read'
    GROUP BY 1
),
lines AS (
    SELECT issue_key, sum(additions + deletions) AS lines
    FROM (SELECT DISTINCT s.work_item_key AS issue_key, p.pull_request_key, p.additions, p.deletions
          FROM fct_session s
          JOIN bridge_session_pull_request b ON b.session_key = s.session_key
          JOIN dim_pull_request p            ON p.pull_request_key = b.pull_request_key
          WHERE s.work_item_key <> 0 AND p.merged_at IS NOT NULL)
    GROUP BY 1
)
SELECT i.issue_number,
       i.footprint_lines, i.footprint_files_read,   -- the estimate: what the fit uses
       l.lines, f.files_read,                        -- the actuals: how far the estimate drifted
       t.tokens
FROM dim_issue i
JOIN tokens t USING (issue_key)
JOIN lines  l USING (issue_key)
LEFT JOIN files f USING (issue_key)
WHERE i.issue_state = 'closed'
  AND i.footprint_lines > 0 AND i.footprint_files_read > 0;
```

Miranda's warehouse docs carry the same query with the estimates beside the actuals ("Footprint vs actual per closed issue"). `files_read` counts only the agent's file-read tools; a file read through the shell (`cat`, `sed -n`) is not counted.

Fit `ln(tokens)` on `ln(footprint_lines × footprint_files_read)`, write the coefficient, the exponent, the band (`exp` of the residual standard deviation), the date and the sample size into the calibration file, and regenerate the grid above. Leave out epics, whose sessions are mostly planning and whose numbers sum their children's. To fit on coding sessions only, restrict the `tokens` CTE with Miranda's session-type classification (the Session Types dive); in practice it changes the fit very little, because a session that opens a PR counts as coding. Keep the previous table in the file under a dated heading so estimates made against it can still be read.

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
| Computing tokens from bucket midpoints when you enumerated the files | Throws away the line and file counts you just worked out | Put the enumerated `~N` and `~M` into the fit; use the grid only as a check |
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
- **Expected tokens:** 373,785 × (165 × 7)^0.432 ≈ **8M**, band 4M–15M.
- **Record:** labels `diff-S`, `reads-R2`; Footprint section with the file list and the unknown ("does `render.Table` format values the JSON should carry raw?"); project field 8.

## Integration

- **`estimating-work-items`** (story points) can run alongside this skill. Points answer "how big is this relative to other work"; footprint answers "what will the agent spend". An issue may carry both a `points-<n>` label and `diff-`/`reads-` labels. When a repo uses both, write the Footprint section directly after the Estimate section.
- **`issue-decomposition`** runs this skill for every child it produces and keeps each one at XL or below; the epic's footprint is the sum.
- **`writing-user-stories`** treats a story above XL, or at R4, as a sign the story is too large.
- **`working-on-an-issue`** reads the `Change:` list as a starting plan and the `Read:` list as the files to load first; it appends the `Actual:` line when it finishes.
- **Miranda** parses the labels, the first two lines of the Footprint section (buckets, numbers, expected tokens, band, calibration tag) and the provenance line into its warehouse (`dim_issue.footprint_*`), and holds them against measured lines, files read and tokens there. It does not parse the `Actual:` line; the warehouse's own measurements are the comparison.
