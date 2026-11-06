# Verification Plan — Issue #114: bundle symlinks

## Scenarios

1. No symlinks in bundles: `find bundles -type l` prints nothing on a fresh clone.
2. Every bundle `skills/*/SKILL.md` resolves (realpath) inside its bundle root.
3. Each bundle's skill set equals the skill set in today's release zip
   (`package-bundles.sh` on main vs. branch: identical file listings and contents,
   apart from the README.md doc edit).
4. `./check-bundles.sh` passes on the branch and fails on main.
5. Drift detection: editing a bundle copy, editing a canonical skill, adding a new
   skill, changing a mode, adding a symlink, or altering an icon each makes
   `./check-bundles.sh` exit 1.
6. `./sync-bundles.sh` is idempotent (second run leaves `git status` clean).
7. `shellcheck` clean; `./check-versions.sh` still passes.
