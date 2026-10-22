# Verification Plan — Issue #95: estimate provenance line

**Verification runs after implementation, before opening the PR.**

## Prerequisites

- Working tree on the issue branch with all changes committed
- `jq` and `python3` on PATH
- The Claude and Codex `skill-creator` validators (`quick_validate.py`), found under `~/.claude/plugins/...` and `~/.codex/skills/.system/...`
- A real model session (a subagent) to follow the updated skill end to end

## Scenarios

### Scenario 1: Version lockstep passes on the real repo

**Steps**:
1. `./check-versions.sh`

**Success Criteria**:
- [ ] Exits 0
- [ ] Lists `estimating-work-items` with SKILL.md `1.2.0` and marketplace `1.2.0`, status ok
- [ ] Skills without a frontmatter version are not reported as mismatches

### Scenario 2: A skill version mismatch fails the check

**Steps**:
1. Temporarily change `metadata.version` in `skills/estimating-work-items/SKILL.md` to `9.9.9`
2. `./check-versions.sh; echo $?`
3. Revert with `git checkout -- skills/estimating-work-items/SKILL.md`

**Success Criteria**:
- [ ] Exits non-zero
- [ ] Output names `estimating-work-items`, the SKILL.md value `9.9.9`, and the marketplace value `1.2.0`

### Scenario 3: Frontmatter passes both skill validators

**Steps**:
1. Run the Claude `quick_validate.py` on `skills/estimating-work-items`
2. Run the Codex `quick_validate.py` on `skills/estimating-work-items`

**Success Criteria**:
- [ ] Both report the skill valid (no unexpected-key error for `metadata`)

### Scenario 4: An agent following the skill writes the provenance line

**Context**: A fresh subagent is given only the updated `SKILL.md` and its reference stories, plus a sample item, and told to write the issue body to a local file (no GitHub writes).

**Steps**:
1. New issue: ask the subagent to estimate a sample issue and write the full `## Estimate` section
2. Re-estimate: give it an existing Estimate section with an old `Estimated by:` line and a scope change; ask for the updated section
3. Human estimate: tell it the developer (@britt) says the item is a 2; ask for the section
4. Epic: give it an epic with four child issues and their points; ask for the section

**Success Criteria**:
- [ ] (1) First line is `**<n> points**`; last line matches `^Estimated by: \S+ in .+, estimating-work-items 1\.2\.0$` with the subagent's real model ID
- [ ] (1) The harness has no version the subagent couldn't find (no invented version)
- [ ] (2) Exactly one `Estimated by:` line, describing the new estimate
- [ ] (3) Last line is `Estimated by: human (@britt), estimating-work-items 1.2.0`
- [ ] (4) First line is `**<sum> points** (epic)` and the section ends with an `Estimated by:` line

### Scenario 5: timeline-planning still reads the points

**Steps**:
1. Confirm `timeline-planning` reads only the first line of the Estimate section (`skills/timeline-planning/SKILL.md`, Estimate to Duration Conversion, source 3)
2. Confirm the Scenario 4 outputs keep `**<n> points**` as that first line

**Success Criteria**:
- [ ] No change is needed in `timeline-planning`

### Scenario 6: Bundle versions bumped and the docs site builds

**Steps**:
1. `git diff origin/main -- '*.json'` shows estimating-work-items, issue-decomposition, and every bundle containing them bumped
2. `cd site && hugo --minify` if `hugo` is installed

**Success Criteria**:
- [ ] Every bundle that carries an edited skill has a new version in all of its manifests
- [ ] Site build exits 0 (or is recorded as skipped if `hugo` is unavailable)

## Verification Rules

- Never use mocks or fakes
- If any success criterion fails, verification fails
- Ask the developer for help if blocked; don't guess
