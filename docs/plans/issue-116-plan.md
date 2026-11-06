# Implementation Plan: Issue #116, CI validation against the Agent Plugins spec

Part of epic #117 (Conform to the Agent Plugins 1.0.0 spec). Builds on #113 (PR #118), #115 (PR #119) and #114 (PR #120).

## Change

1. Vendor `plugin.schema.json` and `mcp.schema.json` from `https://agent-plugins.org/schemas/1.0.0/` under `schemas/agent-plugins/1.0.0/`, copied verbatim.
2. Add `check-plugin-spec.py`. For the repo root and each `bundles/<name>/` (the same set `check-bundles.sh` walks), it checks:
   - `plugin.json` validates against the vendored manifest schema;
   - every immediate child of `skills/` that holds a `SKILL.md` resolves inside the plugin root (realpath prefix check), and that `SKILL.md` is a regular file;
   - the `SKILL.md` frontmatter follows the Agent Skills spec: allowed fields only, `name` matches its directory and the pattern, `description` is 1–1024 characters, `compatibility` is 1–500 characters, `metadata` is a string→string map;
   - if an `mcp.json` exists, it validates against the vendored MCP schema and its `$schema` version matches `plugin.json`.
3. Add `requirements-check.txt`, which pins `jsonschema` and `PyYAML`.
4. Add `.github/workflows/plugin-spec-check.yml`, which runs the script on every PR.
5. Document the check and how to run it locally in CONTRIBUTING.md.

## Files

- `schemas/agent-plugins/1.0.0/{plugin,mcp}.schema.json` (new)
- `check-plugin-spec.py`, `requirements-check.txt` (new)
- `.github/workflows/plugin-spec-check.yml` (new)
- `CONTRIBUTING.md`

## Risks

- Python dependencies in CI. Mitigated by pinning them and using `actions/setup-python`. No step fetches a schema.
- Overlap with `check-bundles.sh`. That script owns drift and "no symlinks in bundles". This one owns spec conformance of what a client loads. A symlink that stays inside the root is allowed here, as the spec allows it.

## Assumptions

See the PR's Assumptions section. This list is the same.

- The "fails on today's main" criterion is checked against `91d89e1` (main before PR #118), because main has already been fixed (coordinator adjustment).
- A new script and workflow, rather than extending `check-bundles.sh`. Drift logic is not duplicated; only the plugin-root set (`.` + `bundles/*/`) is shared.
- Python rather than bash, so the check uses a real JSON Schema (2020-12) validator and a real YAML parser.
- Skill names use ASCII `a-z0-9`, as the spec's parenthetical gives.
- The `compatibility` length and the string type of `license` and `allowed-tools` are checked, because they are part of the same spec frontmatter table.
- `extensions.superset` is not checked for reverse-domain form. The schema does not enforce that, and #113 kept that key as a documented deviation.
