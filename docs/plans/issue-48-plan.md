# Implementation Plan: issue #48 — skill: project-planning — update

Parent epic: #44. Verification plan: `docs/plans/issue-48-verification-plan.md`.

## What the issue asks

Run `project-planning` end-to-end, verify the sub-skill hand-offs under both the individual
and bundle install paths plus the "perform inline if unavailable" fallback, confirm the
`gh issue create` step and the `docs/plans/<slug>-plan.md` output, fix what the run
surfaces, and decide whether the overlap with `project-foundations` is worth calling out.

## Findings from the end-to-end run

Run log: `.context/e2e-48/run.log` (gitignored; reproduced in the PR body).

1. **Broken bundle claim.** The Prerequisites line says the sub-skills arrive "installed
   individually or via the project-foundations bundle". `bundles/project-foundations/skills/`
   contains neither `timeline-planning` nor `project-planning`; `bundles/llpm/skills/` is the
   bundle that ships `project-planning`, and it omits `architecture-diagramming`. The same
   wrong sentence is repeated on `site/content/skills/project-planning.md`.
2. **Hand-off cannot execute in the documented order.** Steps 5 and 6 invoke
   `dependency-mapping` and `timeline-planning`, whose own Step 1 fetches issues with
   `gh issue list --state open`. At that point the decomposed issues are unfiled proposals —
   creation is Step 8 — so the documented input path returns the wrong issue set.
3. **Plan-local issue numbers are never reconciled.** The Step 7 preview and both diagrams
   are produced before creation, so they carry invented numbers, while the plan document's
   "Issues Created" table carries real ones. Nothing rewrites the former after Step 8.
4. **Step 8 lists the same save twice** (items 2 and 3).
5. **Redundant questioning and a double confirmation gate.** Step 1's scoping questions
   duplicate `issue-decomposition` Step 1; Step 7's preview duplicates `issue-decomposition`
   Step 5's preview, so the user approves the same issue set twice.
6. **Labels are not reconciled before an irreversible batch.** `gh issue create` has no
   `--dry-run` in gh 2.100.0, and `feature`/`chore` from the sub-skill's default taxonomy do
   not exist in this repo, so the batch aborts partway with issues already filed.
7. **The "perform inline if unavailable" fallback has no trigger.** Nothing says how to
   decide a sub-skill is unavailable or what "inline" should cover.
8. **Step 2 does not reference `project-analysis`**, the library's own skill for exactly
   that step.

## Changes

| File | Change |
|---|---|
| `skills/project-planning/SKILL.md` | Fix findings 1–8 |
| `site/content/skills/project-planning.md` | Fix the repeated bundle claim (finding 1) |
| `.claude-plugin/marketplace.json` | `project-planning` 1.1.0 → 1.2.0; `llpm` 1.0.0 → 1.1.0; `agent-skills` 4.3.0 → 4.4.0; marketplace 4.4.0 → 4.5.0 |
| `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json` | full-bundle version → 4.4.0 (lockstep, per CONTRIBUTING.md) |
| `bundles/llpm/.claude-plugin/plugin.json` and its `.codex-plugin`/`.cursor-plugin` peers | llpm → 1.1.0 |
| `README.md` | the `llpm` bundle install comment now says it ships the project-planning orchestrator and omits architecture-diagramming |
| `docs/plans/issue-48-plan.md`, `docs/plans/issue-48-verification-plan.md` | this plan and its verification plan |

`project-foundations` is **not** bumped and its composition is **not** changed: it does not
contain `project-planning`, and the epic puts bundle composition out of scope.

## Order

1. Rewrite `skills/project-planning/SKILL.md`.
2. Fix the site page sentence.
3. Version bumps across marketplace and bundle manifests.
4. README llpm bundle note.
5. Run `./sync-agents-skills.sh`; run the verification plan; record the log.

## Assumptions

- **A1.** The token cannot create repositories (`POST /user/repos` → 403), so the epic's
  scratch-repo option is unavailable and `gh issue create` is exercised in dry-run mode
  through an argv-recording shim. Nothing was created, edited, or closed on GitHub.
- **A2.** "Note where this skill's purpose overlaps with the `project-foundations` bundle and
  decide whether that's worth calling out ... in the description" is answered as: call it out
  in the skill body, not in the YAML `description`. The description is the trigger-matching
  string, and install-topology detail there would dilute it without helping discovery.
- **A3.** The wrong bundle claim is fixed rather than made true by adding `timeline-planning`
  to `project-foundations`: the epic lists bundle composition as out of scope.
- **A4.** The fix for finding 2 keeps the sub-skills unmodified. `dependency-mapping` and
  `timeline-planning` are owned by sibling issues (#49 owns `timeline-planning`), so
  `project-planning` states the input contract on its own side of the hand-off.
- **A5.** Version bumps follow the precedent in PR #75: minor bump on the per-skill plugin,
  the containing full bundle, and the marketplace.
- **A6.** The issue's Projects v2 membership could not be read or updated: the GraphQL
  `projectItems` query returns `FORBIDDEN / Resource not accessible by personal access token`.
  Per `working-on-an-issue`, this is recorded rather than treated as a blocker; if #48 is on a
  board, its status was not moved by this session.

## Risks

- Four sibling PRs touch `marketplace.json` and `README.md`. Edits here are confined to the
  `project-planning` entry, the `llpm`/`agent-skills`/marketplace version fields, and the
  three-line `llpm` install comment in README. `llpm` also contains `prepare-meeting-agenda` (#47) and `timeline-planning`
  (#49), so the `llpm` version line is a likely rebase conflict; it resolves by taking the
  higher version.
