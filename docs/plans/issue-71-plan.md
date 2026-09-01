# Implementation Plan — Issue #71: `llpm` bundle plugin

## Goal

Create a new curated bundle plugin `llpm`, mirroring `bundles/project-foundations/`, containing the project-management and product-management skills. The catch-all `agent-skills` plugin is untouched.

## Assumption: refined skill list

Issue #71 proposed an 18-skill candidate list flagged as "not final." Recon found the docs site (`site/content/skill-list.md`, `site/content/_index.md`) already encodes the repo owner's own PM/product taxonomy via section headings and the explicit `project-management` marketplace tag. Using that as the authoritative signal instead of my own guess, the list narrows to 15 skills — dropping `repairing-project-setup` and `setting-up-a-project`, which the site categorizes under "Development Workflow" (project bootstrapping, not PM/product management):

1. `at-risk-detection`
2. `context-aware-questions`
3. `dependency-mapping`
4. `idea-to-design`
5. `issue-decomposition`
6. `prepare-meeting-agenda`
7. `project-planning`
8. `requirement-elicitation`
9. `stakeholder-tracking`
10. `stakeholder-updates`
11. `timeline-planning`
12. `triage-new-issues`
13. `writing-product-specs`
14. `writing-user-stories`
15. `writing-verification-plans`

This is recorded as an assumption for the PR — narrows *how* the issue's own explicitly-provisional list is finalized, doesn't drop anything the issue named as required.

## Steps

1. Create `bundles/llpm/.claude-plugin/plugin.json`, `.cursor-plugin/plugin.json`, `.codex-plugin/plugin.json` — mirror `bundles/project-foundations/` field-for-field, `skills: "./skills/"` for codex/cursor, description covering PM/product management, version `1.0.0`.
2. Create `bundles/llpm/skills/<name>` as a symlink to `../../../skills/<name>` for each of the 15 skills above.
3. Add an `llpm` plugin entry to `.claude-plugin/marketplace.json` and `.cursor-plugin/marketplace.json`, `source: "./bundles/llpm"`, placed after `project-foundations`. Leave the `agent-skills` entry untouched. Bump the marketplace `version` (root-level) with a minor bump: `4.2.0` → `4.3.0`.
4. Update `README.md`: add an `llpm@britt` bundle example next to `project-foundations@britt`, and add `llpm` to the "only available via bundle" note if any of its 15 skills aren't already individually installable (none are — all 15 already have standalone marketplace entries, so no README note change needed there).
5. Update docs site:
   - New `site/content/skills/llpm.md` page mirroring `project-foundations.md`'s structure (Included Skills table, How to use it).
   - `site/content/skill-list.md`: add an `llpm` row under the "### Bundle" section.
   - `site/content/_index.md`: add `/plugin install llpm@britt` next to `project-foundations@britt` in the Claude Code / Codex CLI sections, and an `llpm` row in the "All Skills" table.

## Risks

- Missed a skill the repo owner intended in scope, or included one that shouldn't be. Mitigated by recording the list + reasoning as an explicit assumption in the plan and PR for review.
- `hugo --minify` might fail for unrelated pre-existing reasons — if so, note it in the verification log rather than treating it as caused by this change.

## Out of scope (per issue)

- Renaming `agent-skills`.
- Deprecated-alias handling.
- Repository rename.
