# Issue #114: Materialize bundle skills and icons (no escaping symlinks)

Part of epic #117. Decision (coordinator): Option 1 from the issue.

## Change

- `sync-bundles.sh` (new): regenerates real copies of each bundle's skills and
  `assets/icon.png` from the canonical `skills/` and `assets/`.
  - `britts-agent-skills` (listed in `FULL_LIBRARY_BUNDLES`) carries every skill.
  - Other bundles carry the skills whose directories already exist under
    `bundles/<name>/skills/`.
- `sync-agents-skills.sh`: calls `sync-bundles.sh` at the end, so the one
  existing sync command still does everything.
- `check-bundles.sh` (new) + `.github/workflows/bundle-drift-check.yml` (new):
  fail a PR if a bundle holds a symlink, a bundled skill/icon differs from the
  canonical copy (content or mode), or the full-library bundle's skill set
  differs from `skills/`.
- `package-bundles.sh`, `CONTRIBUTING.md`, `README.md`: stop describing bundle
  contents as symlinks.

## Assumptions

- Option 1 chosen by the coordinator; recorded, not re-litigated.
- Bundle membership for curated bundles is the set of directories under
  `bundles/<name>/skills/` (the same thing the symlinks encoded), so no new
  membership file is introduced.
- `bundles/britts-agent-skills` is kept (PR #119: Paradev needs it).
- The drift check is a standalone script/workflow so #116 can build on it; it
  does no manifest or frontmatter validation (owned by #116).
- `.agents/skills/` symlinks are out of scope (outside any bundle).

## Risks

- ~6 MB of duplication, mostly four copies of the 1.4 MB icon.
