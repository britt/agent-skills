---
name: estimating-work-items
description: Use when writing or refining a GitHub issue, epic, or other work item that needs a size, when asked to estimate, point, or size work, or when deciding whether an item is an issue or an epic - produces one story-point estimate on a powers-of-two scale (1, 2, 4, 8 for issues; 16, 32 for epics) recorded as a label, an Estimate section, and a project field
---

# Estimating Work Items

## Overview

**Core principle:** an estimate is a comparison, not a forecast. Points say how big an item is relative to work the team has already finished. They do not say how long it will take, and they never convert to hours inside an issue.

This skill is for an agent estimating on its own while it writes or refines a work item. It is not a planning-poker facilitator and does not run a team session.

## When to Use

- Writing an issue (by hand, or via `issue-decomposition` or `writing-user-stories`) that needs a size
- Asked to estimate, size, or point an issue, an epic, or a backlog
- Deciding whether an item is an issue or an epic
- Re-checking an estimate after an item's scope changed

**Not for:** time tracking, velocity reports, or scheduling. `timeline-planning` turns points into durations; this skill never does.

## The Scale

| Points | Kind | What it looks like |
|---|---|---|
| 1 | issue | Trivial. One file, no unknowns, done in one sitting. |
| 2 | issue | Small. A clear path through a few files, nothing to investigate. |
| 4 | issue | Moderate. Several files or one new component, one or two things to work out. |
| 8 | issue | The largest an issue may be. Multiple components and real uncertainty. Consider splitting. |
| 16 | epic | Decompose into child issues of 8 or less before any implementation. |
| 32 | epic | Decompose into child issues, usually through sub-epics of 16. |

Rules the scale depends on:

- **Exactly one number from the scale.** No 0, 3, 6, 12, half points, or ranges. "4 to 8" is not an estimate; it is a 4 with an unresolved unknown, or an 8.
- **8 is the ceiling for an issue.** Anything bigger is an epic, whatever it was called when it arrived.
- **16 and 32 are epics**, and an epic is never implemented as-is. It is a container for child issues.
- **Nothing is larger than 32.** If the children of an item add up to more than 32, it is an initiative, not an epic. Label it `epic` with no `points-*` label, make the first line of its Estimate section `**Over 32** (initiative)`, and estimate the epics beneath it instead.
- **Points add.** Two 4s are roughly an 8. An epic's points should roughly match the sum of its children. If the sum lands in a different bucket, the epic's estimate changes, not the children's.

## Process

### Step 0: Gather

- The item text, including comments if it already exists (`gh issue view <n> --comments`).
- Reference stories: `docs/estimation/reference-stories.md` in the target repo if it exists, otherwise [reference-stories.md](reference-stories.md) bundled with this skill.
- The repo's label vocabulary (`gh label list`) and whether it has a GitHub Project with a number field for points (`gh project field-list <number> --owner <owner>`).

### Step 1: Estimability gate

Write one sentence that describes what "done" looks like for this item. If you can write it, continue.

If you cannot, because the item names a goal with no observable outcome ("make search better", "improve onboarding"), **do not estimate it**. Do one of these instead:

- Ask the author the one or two questions whose answers would make the item estimable, and stop.
- Rewrite the item as a **spike**: a time-boxed investigation with a specific question, a deliverable (a written finding, a recommendation, or a list of follow-up issues), and the rule that no production code ships from it. A spike is estimable because its scope is the time box. Size it 1 or 2 and label it `spike` in addition to `points-<n>`.

A number with "low confidence" or a range attached is not a substitute for this step. It is a guess wearing a disclaimer.

### Step 2: Score the dimensions before picking a number

Do this before you look at the scale, so the title does not anchor the result. Rate each dimension Low, Medium, or High and give a few words of evidence:

| Dimension | Question | Evidence to cite |
|---|---|---|
| Effort | How much has to be written, changed, and tested? | Files, components, surfaces, test cases |
| Complexity | How hard is each piece? | New patterns, migrations, concurrency, security-sensitive paths, public contracts |
| Uncertainty | What is not known yet? | Undecided design, unfamiliar library, external dependency, live-data migration |

### Step 3: Triangulate against reference stories

From the reference stories, pick one that seems slightly smaller than this item and one slightly larger. Then answer two questions:

- Is this item closer to the smaller one or the larger one?
- Would two of the smaller one add up to about this item?

The answers name the bucket. Use the dimension scores as a cross-check:

| Dimension pattern | Bucket |
|---|---|
| All Low | 1 or 2 |
| One Medium, rest Low | 2 or 4 |
| Any High, or two Mediums | 4 or 8 |
| Two or more High | 8, or an epic |
| High uncertainty about *what* to build (not how) | Not estimable. Back to Step 1. |

### Step 4: Resolve a tie

Torn between two buckets? Name the unknown that is pulling you up. If one question to the author would resolve it, ask it, or record it as the main unknown and round up. Otherwise round up. Never split the difference with a number that is not on the scale.

### Step 5: Issue or epic

If the bucket is 16 or 32:

1. Label the item `epic` as well as `points-<n>`.
2. Hand it to `issue-decomposition` to produce the child issues. Every child must be 8 or less. A child that comes out at 16 is itself an epic and is decomposed in turn.
3. After decomposition, add up the children. If the sum lands in a different bucket, change the epic's estimate to match.

If you are writing the epic inline without `issue-decomposition`, list the proposed children with their points under the Estimate section and still enforce the ceiling of 8 on each.

### Step 6: Record the estimate in all three places

1. **Label** `points-<n>`, for example `points-4`. Create it if the repo does not have it. When re-estimating, remove any other `points-*` label first.

   ```bash
   gh label create points-4 --color 0E8A16 --description "Estimate: 4 story points" 2>/dev/null
   gh issue edit <n> --remove-label points-2 --add-label points-4
   ```

2. **Body**: an `## Estimate` section using the contract below. Put it after the acceptance criteria.
3. **Project field**: if the repo has a GitHub Project with a number field named Estimate, Points, or Story Points, set it. If there is no project or no such field, say so and skip it.

   ```bash
   gh project item-list <project> --owner <owner> --format json   # find the item id
   gh project item-edit --project-id <id> --id <item-id> --field-id <field-id> --number 4
   ```

### Estimate section contract

The first line after the heading is always `**<n> points**` so that `timeline-planning` and other tools can read it without parsing prose.

```markdown
## Estimate
**4 points**

Compared with: "Add a --verbose flag to an existing command" (2) and "Add a new subcommand with its own query" (8). Closer to the 2: one flag, one output path. More than a 2 because the JSON field names become a public contract and need their own tests.
Main unknown: whether `render.Table` formats values that the JSON should carry raw.
```

For an epic the first line is `**16 points** (epic)` and a `Children:` line lists each child with its points once they exist.

## Reference Stories

Reference stories give the scale its meaning. The bundled [reference-stories.md](reference-stories.md) holds generic software examples for every bucket. Prefer a repo-local `docs/estimation/reference-stories.md` when one exists, because stories the team actually shipped calibrate better than generic ones.

To seed a repo-local file, pick two or three closed issues per bucket that the team still agrees were that size and that most contributors understand. Keep the list between 15 and 30 items so one bad reference does not get reused across every comparison, and drop items as they age and the team forgets them.

## Splitting an Oversized Item

An 8 that could be smaller, or anything at 16 or above, gets split. Each child must deliver something a user or operator can observe and test on its own; never split by layer (frontend issue, backend issue, database issue). Patterns, from the Humanizing Work guide:

| Pattern | Split by |
|---|---|
| Workflow steps | The simple end-to-end path first, then the middle steps and special cases |
| Operations | Create, read, update, and delete as separate items |
| Business rule variations | One rule per item |
| Data variations | A good-enough data model first, then each variation |
| Data entry methods | The simplest input first, the richer one later |
| Major effort | Isolate the hard part so the rest become cheap follow-ups |
| Simple versus complex | The plainest version first, each complication its own item |
| Defer performance | Make it work, then make it fast, secure, or scalable |
| Break out a spike | A time-boxed investigation when the approach is unknown. Last resort. |

Prefer the split that produces children of similar size and that lets the lowest-value children be dropped or deferred.

## Anti-patterns

| Pattern | Why it fails | Do instead |
|---|---|---|
| Points as hours or days ("4 points is 2 days") | Hides uncertainty and makes velocity meaningless | Keep points relative. Conversion lives in `timeline-planning`, where the user confirms it. |
| A range or a confidence level instead of a number | Pushes the decision onto the reader | Resolve the unknown or round up (Step 4). If the item is not estimable, say that. |
| Off-scale numbers (3, 6, 12, 64) | Breaks the doubling and the ability to add | Pick the nearest bucket. Above 32, decompose first. |
| Epic children at 16 | The epic has not been decomposed, only relabelled | Decompose again until every child is 8 or less. |
| Sizing from the title ("just a flag, so 1") | Skips the dimensions that make small things big | Score effort, complexity, and uncertainty first (Step 2). |
| Estimating the goal instead of the work ("improve search": 8) | Nothing observable to size | Fail the estimability gate. Ask, or write a spike. |
| Re-estimating finished work | Rewrites history to fix velocity | Leave done work alone. Fix the reference stories instead. |
| Fitting the number to the plan ("it has to be a 4 to fit the sprint") | The estimate stops being information | Estimate first, then split if it does not fit. |
| Comparing teams or people by points | Each team's scale is its own; comparison inflates estimates | Compare an item only with the same team's reference stories. |

## Worked Example

Item: "Add a `--json` flag to `shiplog list` so the output can be piped to jq. The table output must stay the default."

- **Done looks like:** `shiplog list --json` prints a JSON array that `jq .` parses; `shiplog list` is unchanged.
- **Effort: Low.** One command file, one new output path, a handful of tests.
- **Complexity: Medium.** The JSON keys become a public contract; stdout must carry only JSON.
- **Uncertainty: Low.** The data is already fetched; only the rendering changes.
- **Triangulate:** smaller reference "Add a `--verbose` flag to an existing command" (2); larger "Add a new subcommand with its own store query" (8). Closer to the 2 than the 8, but more than a 2: the flag itself is one half of the work, and the output contract with its tests is the other half. Two 2s make a 4. **Bucket: 4.**
- **Record:** label `points-4`, Estimate section as in the contract above, project field set to 4.

## Integration

- `issue-decomposition` runs this skill for every proposed issue and keeps each one at 8 or less; 16 and 32 become epics with children.
- `timeline-planning` reads the `points-<n>` label or the first line of the Estimate section and converts points to durations with a mapping the user confirms.
- `writing-user-stories` treats INVEST "Small" as 8 points or less on this scale.
- `working-on-an-issue` sends anything estimated at 16 or above to `issue-decomposition` first; `working-on-an-epic` expects every child at 8 or less.
