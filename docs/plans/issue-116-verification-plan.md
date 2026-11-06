# Verification Plan: Issue #116

| # | Scenario | Expected |
|---|---|---|
| 1 | Run `check-plugin-spec.py` (with the vendored schemas copied in) at `91d89e1`, main before PR #118 | Exit 1. Bundle `$schema` errors, skills resolving outside each bundle root, and a missing root `plugin.json` |
| 2 | Same at current `origin/main` | Exit 0 |
| 3 | Same on the branch | Exit 0. `check-bundles.sh` and `check-versions.sh` still pass |
| 4 | Fixture: bad frontmatter (name≠dir, bad pattern, non-string metadata, 1025-char description, extra field, missing description) | One error per case, exit 1 |
| 5 | Fixture: manifest with an unknown field and a bad name; `mcp.json` with a wrong version and an invalid server | Schema errors plus a version-mismatch error, exit 1 |
| 6 | Fixture: valid `mcp.json`; skill symlinked within the root | Exit 0 |
| 7 | Fixture: skill symlinked outside the root | Exit 1 |
| 8 | Run with the proxy pointed at a dead port | Exit 0 (no network use) |
| 9 | CI: the `Check Agent Plugins conformance` job on the PR | Green |
| 10 | CONTRIBUTING.md documents running the check locally | Present |
