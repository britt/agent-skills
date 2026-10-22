---
name: estimating-work-items
description: Use when writing or refining a GitHub issue, epic, or other work item that needs a size, when asked to estimate, point, or size work, or when deciding whether an item is an issue or an epic - gives an issue one story-point estimate on a powers-of-two scale (1, 2, 4, 8) and an epic the sum of its children's points, with no upper limit, recorded as a label, an Estimate section, and a project field
metadata:
  version: "1.2.0"
---

# Estimating Work Items

## Overview

**Core principle:** an estimate is a comparison, not a forecast. Points say how big an item is relative to work the team has already finished. They do not say how long it will take, and they never convert to hours inside an issue.

Only issues are estimated. An epic is never estimated directly: its points are the sum of its child issues' points, whatever that sum is.

This skill is for an agent estimating on its own while it writes or refines a work item. It is not a planning-poker facilitator and does not run a team session.

## When to Use

- Writing an issue (by hand, or via `issue-decomposition` or `writing-user-stories`) that needs a size
- Asked to estimate, size, or point an issue, an epic, or a backlog
- Deciding whether an item is an issue or an epic
- Re-checking an estimate after an item's scope changed

**Not for:** time tracking, velocity reports, or scheduling. `timeline-planning` turns points into durations; this skill never does.

## The Scale

The scale is for issues:

| Points | What it looks like |
|---|---|
| 1 | Trivial. One file, no unknowns, done in one sitting. |
| 2 | Small. A clear path through a few files, nothing to investigate. |
| 4 | Moderate. Several files or one new component, one or two things to work out. |
| 8 | The largest an issue may be. Multiple components and real uncertainty. Consider splitting. |

Rules the scale depends on:

- **Exactly one number from the scale for an issue.** No 0, 3, 6, 12, half points, or ranges. "4 to 8" is not an estimate; it is a 4 with an unresolved unknown, or an 8.
- **8 is the ceiling for an issue.** Anything bigger is an epic, whatever it was called when it arrived.
- **An epic is a container for child issues** and is never implemented as-is.

### Epic points are a sum

An epic's points are exactly the sum of its child issues' points. That is the whole rule:

- **Add, don't round.** Children of 4, 2, 8, and 1 make a 15-point epic, not a 16. The powers-of-two scale applies to issues, never to epic totals.
- **No upper limit.** Children that add up to 48, 120, or 300 make a 48-, 120-, or 300-point epic. There is no larger category such as an initiative, and a big total is not a reason to regroup the children.
- **Sub-epics add up too.** If an epic has child epics, each child epic contributes its own sum, so the parent's total is the sum of every issue beneath it.
- **No children, no points.** Before decomposition an epic has no estimate. Do not guess a total ("feels like 60") to fill the gap; decompose it (Step 5) and add up the children.
- **The sum follows the children.** When a child is added, removed, or re-estimated, recompute the epic's total. Never adjust a child to make the total come out to a particular number.

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

If the bucket comes out larger than 8, stop estimating: the item is an epic. Go to Step 5.

### Step 4: Resolve a tie

Torn between two buckets? Name the unknown that is pulling you up. If one question to the author would resolve it, ask it, or record it as the main unknown and round up. Otherwise round up. Never split the difference with a number that is not on the scale.

### Step 5: Issue or epic

If the item is bigger than 8:

1. Label the item `epic`. Do not give it a number yet.
2. Hand it to `issue-decomposition` to produce the child issues. Every child issue must be 8 or less. A child bigger than 8 is itself an epic and is decomposed in turn.
3. Add up the children's points. The sum, whatever it is, is the epic's points.

If you are writing the epic inline without `issue-decomposition`, list the proposed children with their points under the Estimate section, enforce the ceiling of 8 on each, and record their sum as the epic's points.

### Step 6: Record the estimate

1. **Label** `points-<n>` on an issue, for example `points-4`. Create it if the repo does not have it. When re-estimating, remove any other `points-*` label first. An epic gets the `epic` label and no `points-*` label, because its total can be any number; its points live in the body and the project field.

   ```bash
   gh label create points-4 --color 0E8A16 --description "Estimate: 4 story points" 2>/dev/null
   gh issue edit <n> --remove-label points-2 --add-label points-4
   ```

2. **Body**: an `## Estimate` section using the contract below, ending with the `Estimated by:` line. Put it after the acceptance criteria. When re-estimating, rewrite the section, including the `Estimated by:` line; do not keep the old one.
3. **Project field**: if the repo has a GitHub Project with a number field named Estimate, Points, or Story Points, set it. For an epic, set it to the sum and update it whenever the sum changes; leave it empty until the epic has children. If there is no project or no such field, say so and skip it.

   ```bash
   gh project item-list <project> --owner <owner> --format json   # find the item id
   gh project item-edit --project-id <id> --id <item-id> --field-id <field-id> --number 4
   ```

### Estimate section contract

The first line after the heading starts with `**<n> points**` so that `timeline-planning` and other tools can read it without parsing prose. An epic adds ` (epic)` after it. The last line is always the [provenance line](#provenance-line).

```markdown
## Estimate
**4 points**

Compared with: "Add a --verbose flag to an existing command" (2) and "Add a new subcommand with its own query" (8). Closer to the 2: one flag, one output path. More than a 2 because the JSON field names become a public contract and need their own tests.
Main unknown: whether `render.Table` formats values that the JSON should carry raw.
Estimated by: claude-opus-5-5 in Claude Code 2.1.304 (via Conductor), estimating-work-items 1.2.0
```

For an epic the first line is `**<sum> points** (epic)`, where the sum is exact and unrounded, followed by a `Children:` line that lists each child with its points:

```markdown
## Estimate
**15 points** (epic)

Children: #41 IdP metadata config (4), #42 SP metadata endpoint (2), #43 assertion consumer endpoint (8), #44 SSO-only login setting (1)
Estimated by: gpt-5.6-sol in Codex CLI, estimating-work-items 1.2.0
```

A child epic is listed with its own sum, for example `#50 Per-tenant billing (16, epic)`. Children that do not have issue numbers yet are listed by title.

An epic that has not been decomposed yet has no first line of points. Its Estimate section says `**Not yet estimated** (epic, awaiting decomposition)`, followed by the `Estimated by:` line for whoever made that call.

### Provenance line

The last line of every Estimate section, for issues and epics alike, records who made the estimate and under which rules:

```markdown
Estimated by: <model> in <harness>, estimating-work-items <version>
```

- **Model**: the exact model ID you are running as, for example `claude-opus-5-5`, not "Opus" or "Claude". If you cannot tell, write `unknown-model`. Never guess.
- **Harness**: what you are running in. That can be a coding agent (Claude Code, Codex CLI, Cursor, OpenCode) or anything else (claude.ai, an SDK app, a CI job). Add its version only if you can find it, for example from `claude --version`; otherwise give the name alone. If an outer tool is driving the harness, add `(via <tool>)`, for example `(via Conductor)` when `CONDUCTOR_*` environment variables are set.
- **Version**: `metadata.version` from this skill's frontmatter, copied as written.
- **A person's estimate**: when a person gives the number and you record it, the model is `human`, with their handle if you know it, and there is no harness: `Estimated by: human (@britt), estimating-work-items 1.2.0`.
- **One line, always current**: the line describes the estimate it sits under. On a re-estimate, or when an epic's sum is recomputed, replace it; never stack old lines.

Tools parse the line this way: it starts with `Estimated by: ` and ends with `, estimating-work-items <version>`. The model is everything before the first ` in ` (model IDs contain no spaces), and the harness is everything between that ` in ` and the last `, `. A line with no ` in ` is a person's estimate: everything before the last `, ` names them, and there is no harness.

## Reference Stories

Reference stories give the scale its meaning. The bundled [reference-stories.md](reference-stories.md) holds generic software examples for every bucket. Prefer a repo-local `docs/estimation/reference-stories.md` when one exists, because stories the team actually shipped calibrate better than generic ones.

To seed a repo-local file, pick two or three closed issues per bucket that the team still agrees were that size and that most contributors understand. Keep the list between 15 and 30 items so one bad reference does not get reused across every comparison, and drop items as they age and the team forgets them.

## Splitting an Oversized Item

An issue at 8 that could be smaller, or an item bigger than 8, gets split into child issues. This is how an epic gets its children; it is not a reason to break up an epic because its total is large. Each child must deliver something a user or operator can observe and test on its own; never split by layer (frontend issue, backend issue, database issue). Patterns, from the Humanizing Work guide:

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
| Off-scale numbers on an issue (3, 6, 12) | Breaks the doubling and the ability to add | Pick the nearest bucket. Above 8, it is an epic. |
| Rounding an epic's total to a power of two, or capping it | The total stops matching the work beneath it | Record the exact sum of the children, however large. |
| Estimating an epic directly ("it's about a 32") | A guess that the children will not add up to | Decompose, then add up the children. |
| Epic child issues above 8 | The epic has not been decomposed, only relabelled | Decompose again until every child issue is 8 or less. |
| Sizing from the title ("just a flag, so 1") | Skips the dimensions that make small things big | Score effort, complexity, and uncertainty first (Step 2). |
| Estimating the goal instead of the work ("improve search": 8) | Nothing observable to size | Fail the estimability gate. Ask, or write a spike. |
| Re-estimating finished work | Rewrites history to fix velocity | Leave done work alone. Fix the reference stories instead. |
| Fitting the number to the plan ("it has to be a 4 to fit the sprint") | The estimate stops being information | Estimate first, then split if it does not fit. |
| Guessing the model or harness version in the `Estimated by:` line | The provenance stops being evidence | Write `unknown-model`, or the harness name without a version. |
| Comparing teams or people by points | Each team's scale is its own; comparison inflates estimates | Compare an item only with the same team's reference stories. |

## Worked Example

Item: "Add a `--json` flag to `shiplog list` so the output can be piped to jq. The table output must stay the default."

- **Done looks like:** `shiplog list --json` prints a JSON array that `jq .` parses; `shiplog list` is unchanged.
- **Effort: Low.** One command file, one new output path, a handful of tests.
- **Complexity: Medium.** The JSON keys become a public contract; stdout must carry only JSON.
- **Uncertainty: Low.** The data is already fetched; only the rendering changes.
- **Triangulate:** smaller reference "Add a `--verbose` flag to an existing command" (2); larger "Add a new subcommand with its own store query" (8). Closer to the 2 than the 8, but more than a 2: the flag itself is one half of the work, and the output contract with its tests is the other half. Two 2s make a 4. **Bucket: 4.**
- **Record:** label `points-4`, Estimate section as in the contract above ending with its `Estimated by:` line, project field set to 4.

## Integration

- `issue-decomposition` runs this skill for every proposed issue and keeps each one at 8 or less; anything bigger becomes an epic whose points are the sum of its children.
- `timeline-planning` reads the `points-<n>` label or the first line of the Estimate section and converts points to durations with a mapping the user confirms.
- `writing-user-stories` treats INVEST "Small" as 8 points or less on this scale.
- `working-on-an-issue` sends anything bigger than 8, or labelled `epic`, to `issue-decomposition` first; `working-on-an-epic` expects every child issue at 8 or less.
