# Verification Plan — Issue #113: bundle manifests declare a non-spec `$schema`

**Verification runs after implementation, before opening the PR.**

## Prerequisites

- Working tree on `issue-113-bundle-schema` with all changes committed
- `python3` with `jsonschema` (Draft 2020-12), `jq`, `curl`
- Local copies of `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json` and Paradev's `https://paradev.com/schemas/plugin/1.0.0.json` (the old `superset.sh` URL serves the same document)

## Scenarios

### Scenario 1: Every bundle manifest validates against the Agent Plugins 1.0.0 schema

**Steps**:
1. Validate each `bundles/*/plugin.json` with `jsonschema.Draft202012Validator` against the Agent Plugins schema.

**Success Criteria**:
- [ ] All four manifests report no errors
- [ ] Run against `main` first, the same check fails on `$schema` for all four (proves the check discriminates)

### Scenario 2: `$schema` equals the Agent Plugins 1.0.0 URL

**Steps**:
1. `jq -r '."$schema"' bundles/*/plugin.json`
2. `grep -rn 'superset.sh/schemas' --exclude-dir=.git .`

**Success Criteria**:
- [ ] Four lines, each exactly `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json`
- [ ] No manifest still names the `superset.sh` schema (a mention in CONTRIBUTING.md prose is fine)

### Scenario 3: Paradev still accepts the manifests

**Steps**:
1. Validate each manifest against Paradev's plugin schema.

**Success Criteria**:
- [ ] All four report no errors (`extensions.superset.interface.displayName` still present)

### Scenario 4: `extensions` key exception is documented

**Steps**:
1. `jq -r '.extensions | keys[]' bundles/*/plugin.json`
2. Read CONTRIBUTING.md §5.

**Success Criteria**:
- [ ] Key is `superset` in all four manifests
- [ ] CONTRIBUTING.md names `extensions.superset` as a known client deviation from Agent Plugins §8, with the evidence and the condition for changing it
- [ ] The `extensions.superset.interface.icon` paragraph still matches the manifests

### Scenario 5: Release tooling still passes

**Steps**:
1. `./check-versions.sh`
2. `./package-bundles.sh`

**Success Criteria**:
- [ ] Both exit 0
