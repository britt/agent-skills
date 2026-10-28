# Plan — Issue #97: supervising-conductor-workspaces

## What changes

| File | Change |
|---|---|
| `skills/supervising-conductor-workspaces/SKILL.md` | The attached draft, restructured to CONTRIBUTING.md: Overview, When to Use / When NOT to Use, Key principles; then dispatch → watch → conflicts → finish |
| `skills/supervising-conductor-workspaces/scripts/pr-watcher.sh` | The attached script, shellcheck-clean, plus fixes found while testing (below) |
| `skills/supervising-conductor-workspaces/tests/pr-watcher.test.sh` | New: drives the watcher with stubbed `gh` and `conductor` on PATH |
| `skills/supervising-conductor-workspaces/agents/conductor-fleet-supervisor.md` | The attached subagent definition, unchanged apart from wording that points at the skill |
| `skills/working-on-an-epic/SKILL.md` | One "When NOT to Use" line routing lists of unrelated issues and PR babysitting to the new skill |
| `.agents/skills/supervising-conductor-workspaces` | Symlink from `./sync-agents-skills.sh` |
| `.claude-plugin/marketplace.json` | New entry 1.0.0; `working-on-an-epic` 1.2.0 → 1.3.0; `agent-skills` 6.5.0 → 6.6.0 (entry + top level) |
| `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json` | `agent-skills` 6.6.0 |
| `README.md`, `site/content/skill-list.md`, `site/content/skills/supervising-conductor-workspaces.md` | Skill list entries and a site page, as other skill additions did |

## Watcher fixes found in review of the draft

- `DRY_RUN=1` wrote the same dedupe markers a real run reads, so a dry run silently suppressed the real run's messages afterwards. Dry runs now default to their own state directory.
- In `DRY_RUN=1` the MERGED line repeated every pass (only real archives were marked). Now marked once.
- If the open-PR lookup in the archive step failed, the "still mentioned" count fell back to 0 and the workspace was archived. A failed lookup now skips archiving for that pass.
- `ONCE=1` with an unreadable base branch slept and retried forever. It now exits non-zero.
- `mergedAt > createdAt` compared strings with and without fractional seconds; both are now converted to epoch seconds.
- `gh pr list` defaulted to 30 open PRs; now `--limit 100`.

## Decisions (the issue's open questions) — assumptions

1. **Relationship to `working-on-an-epic`: (a) separate skill, cross-linked from both.** The issue leans (b), but `working-on-an-epic`'s absolute rules forbid merging and archiving ("never merge", "leave child workspaces alive") while this skill's whole job is telling green PRs to merge and archiving after merge. Folding one into the other would change the epic skill's contract, which is a separate decision for its own issue.
2. **Subagent home: inside the skill folder** at `agents/conductor-fleet-supervisor.md`, with copy instructions in SKILL.md. Skills must stay self-contained (single-skill installs use `./skills/<name>`), and no plugin manifest here declares agents, so a new top-level `agents/` dir would need manifest wiring across three harnesses for one file.
3. **Bundle: only the full `agent-skills` bundle.** It needs the `conductor` CLI like `working-on-an-epic` and `working-on-an-issue`, which are in no curated bundle; it does not fit `chat`, `llpm`, or `project-foundations`.
4. **Authorization defaults: kept exactly as the draft's table.** They are a product decision the reviewer confirms on the PR.
5. **Frontmatter `tags:` dropped.** No skill in this repo has `tags:` in SKILL.md frontmatter; tags live in `marketplace.json`. `metadata.version` is added per CONTRIBUTING.md.
6. **Verification plan lives in `docs/plans/`** like issues #71 and #95, not a project-wide VERIFICATION_PLAN.md.

## Order

1. Script + tests (TDD: test the fixes first, then fix)
2. SKILL.md, subagent file, epic cross-link
3. Sync symlinks, marketplace, versions, README, site
4. Verification plan

## Risks

- The test stubs encode the `gh`/`conductor` JSON shapes; shapes were checked against the live CLIs (`workspace list` → `.data[].{id,name,state,createdAt}`, `workspace session` → `.data[0].id`).
