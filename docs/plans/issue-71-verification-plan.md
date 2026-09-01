# Verification Plan — Issue #71: `llpm` bundle plugin

**Verification runs after implementation, before opening the PR.**

## Prerequisites

- Working tree on branch `issue-71-llpm-bundle-plugin`
- `jq` and `hugo` available on PATH (confirmed present)

## Scenarios

### Scenario 1: Bundle skills are single-sourced, not duplicated

**Context**: `bundles/llpm/skills/` has been populated.

**Steps**:
1. `find bundles/llpm/skills -maxdepth 1 -type l -exec ls -l {} \;`
2. For each symlink, confirm it resolves to a real file under `skills/<name>/SKILL.md`

**Success Criteria**:
- [ ] Every entry in `bundles/llpm/skills/` is a symlink (not a real directory/copy)
- [ ] Every symlink target resolves and points at `../../../skills/<name>`
- [ ] Skill count matches the final agreed list

### Scenario 2: Marketplace manifests are valid and additive

**Context**: `.claude-plugin/marketplace.json` and `.cursor-plugin/marketplace.json` have a new `llpm` entry.

**Steps**:
1. `jq . .claude-plugin/marketplace.json` and `jq . .cursor-plugin/marketplace.json` — must parse without error
2. `jq '.plugins[] | select(.name=="llpm")' .claude-plugin/marketplace.json` — must return the new entry with `source: "./bundles/llpm"`
3. `jq '.plugins[] | select(.name=="agent-skills")' .claude-plugin/marketplace.json` — must be byte-for-byte unchanged in `name` and `source` (only a version bump, if any, is acceptable)
4. `jq . bundles/llpm/.claude-plugin/plugin.json bundles/llpm/.cursor-plugin/plugin.json bundles/llpm/.codex-plugin/plugin.json` — must all parse without error

**Success Criteria**:
- [ ] All JSON files parse
- [ ] `llpm` entry present in both marketplace.json files with correct source path
- [ ] `agent-skills` catch-all entry's name/source untouched

### Scenario 3: Docs site builds

**Context**: `site/content/skills/llpm.md` created; `_index.md` and `skill-list.md` updated.

**Steps**:
1. `cd site && hugo --minify` (or equivalent build command used by the existing `hugo.yml` workflow)

**Success Criteria**:
- [ ] Build completes with exit code 0
- [ ] No broken `relref` warnings for the new `llpm` page

### Scenario 4: README documents the new bundle

**Steps**:
1. `grep -n "llpm@britt" README.md`

**Success Criteria**:
- [ ] `/plugin install llpm@britt` documented next to the existing `project-foundations@britt` bundle example

## Verification Rules

- No mocks — every check runs against the real files in the working tree
- All scenarios must pass before the PR is opened
