# Verification Plan — Issue #115: root plugin.json

## Prerequisites

- `bash`, `jq`, `unzip`, `shellcheck`, Python 3 with `jsonschema`
- The published schema from https://agent-plugins.org/schemas/1.0.0/plugin.schema.json

## Scenarios

### Scenario 1: Root manifest validates against the Agent Plugins 1.0.0 schema
1. Validate `plugin.json` with a Draft 2020-12 validator against the downloaded schema.
- [ ] Valid, no errors

### Scenario 2: Lockstep check passes on the branch
1. `./check-versions.sh`
- [ ] Exits 0

### Scenario 3: Lockstep check fails on root drift
1. Set the root `plugin.json` version to `9.9.9`; run `./check-versions.sh`.
2. Delete the root `plugin.json`; run `./check-versions.sh`. Restore it.
- [ ] Both exit 1, naming `plugin.json (repo root)` with `9.9.9` / `MISSING`

### Scenario 4: Full-library zip carries plugin.json at its root
1. `./package-bundles.sh`; list and extract `plugin.json` from `dist/britts-agent-skills-<version>.zip`.
- [ ] `plugin.json` is at the archive root and byte-identical to the repo's
- [ ] The archive still contains every `skills/<name>/SKILL.md`

### Scenario 5: Scripts lint clean
1. `shellcheck check-versions.sh package-bundles.sh`
- [ ] No findings
