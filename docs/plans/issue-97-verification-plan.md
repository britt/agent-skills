# Verification Plan — Issue #97: supervising-conductor-workspaces

**Verification runs after implementation, before opening the PR.**

## Prerequisites

- Working tree on the issue branch with all changes committed
- `bash`, `jq`, and `shellcheck` on PATH
- The Claude and Codex `skill-creator` validators (`quick_validate.py`), if installed
- `conductor` and `gh` authenticated (for the live dry run in Scenario 4)

## Scenarios

### Scenario 1: Watcher test suite passes against stubbed `gh` and `conductor`

**Steps**:
1. `skills/supervising-conductor-workspaces/tests/pr-watcher.test.sh`

**Success Criteria**:
- [ ] Exits 0
- [ ] One line per new BEHIND, CONFLICT, CI_FAILED_OR_BLOCKED and MERGED event; a second pass over unchanged (PR, head, base, state) prints nothing
- [ ] A new head sha on the same PR is reported again
- [ ] A PR merged before the workspace was created does not archive it; one merged after does, once
- [ ] An open PR that still mentions the issue (stacked series) blocks archiving
- [ ] `DRY_RUN=1` sends no message and archives nothing, and does not suppress events for a later real run
- [ ] A failed open-PR lookup never archives
- [ ] `ONCE=1` exits non-zero instead of looping when the base branch can't be read

### Scenario 2: shellcheck is clean

**Steps**:
1. `shellcheck skills/supervising-conductor-workspaces/scripts/pr-watcher.sh skills/supervising-conductor-workspaces/tests/pr-watcher.test.sh`

**Success Criteria**:
- [ ] Exits 0 with no findings

### Scenario 3: Versions, symlinks, and frontmatter

**Steps**:
1. `./check-versions.sh`
2. `./sync-agents-skills.sh && git status --porcelain .agents rules`
3. Run the Claude and Codex `quick_validate.py` on `skills/supervising-conductor-workspaces`

**Success Criteria**:
- [ ] `check-versions.sh` exits 0 and lists `supervising-conductor-workspaces` 1.0.0 / 1.0.0 ok, and `agent-skills` at the bumped version in all five places
- [ ] `.agents/skills/supervising-conductor-workspaces` is a committed symlink; the sync leaves no further changes
- [ ] Both validators accept the frontmatter (or are recorded as unavailable)

### Scenario 4: Live dry run against this repository

**Steps**:
1. From the repo checkout: `ONCE=1 DRY_RUN=1 STATE=$(mktemp -d) skills/supervising-conductor-workspaces/scripts/pr-watcher.sh`

**Success Criteria**:
- [ ] Exits 0 against the real `gh` and `conductor` APIs
- [ ] Every printed line starts with one of the four event names and any action reads "(dry run)"
- [ ] No message was sent and no workspace archived (`conductor workspace list --limit 100` unchanged)

### Scenario 5: Triggering boundaries

**Steps**:
1. Read the three descriptions (`supervising-conductor-workspaces`, `working-on-an-issue`, `working-on-an-epic`) side by side
2. Give a fresh subagent only the three descriptions and these prompts, asking which skill it would load: "dispatch workspaces for issues 310–315 and monitor them", "keep these PRs up to date with main", "work on issue 97", "work on epic 40"

**Success Criteria**:
- [ ] The first two pick `supervising-conductor-workspaces`; the last two pick `working-on-an-issue` and `working-on-an-epic`

### Scenario 6: Docs site builds

**Steps**:
1. `cd site && hugo --minify` if `hugo` is installed

**Success Criteria**:
- [ ] Exits 0 (or recorded as skipped if `hugo` is unavailable)

## Verification Rules

- The live dry run uses the real APIs; the stubbed suite exists because a real run would message agents and archive workspaces
- If any success criterion fails, verification fails
