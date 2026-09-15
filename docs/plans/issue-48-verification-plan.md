# Verification Plan: issue #48 — project-planning skill update

Acceptance procedure for the `project-planning` skill revision. Every scenario is run
against the real repository and the real `gh` CLI. No mocks, with one exception recorded
in Prerequisites: `gh issue create` is routed to a dry-run shim, because creating issues in
`britt/agent-skills` is forbidden by the epic and the token cannot create a scratch repo.

## Prerequisites

- Working copy of `britt/agent-skills` on branch `issue-48-update-project-planning`.
- `gh` CLI authenticated against `britt/agent-skills` (read access is sufficient).
- `python3` for JSON assertions.
- Dry-run shim at `.context/e2e-48/bin/gh` that records `argv` and creates nothing.
  The active `gh` is a shell wrapper pinned to `/conductor/bin/gh`, so the shim is invoked
  by absolute path rather than by `PATH` precedence.

## Scenarios

### Scenario 1: Every skill and bundle the revised SKILL.md names actually exists

**Context**: Revised `skills/project-planning/SKILL.md` on disk.

**Steps**:
1. Extract every `skills/<name>` and bundle name referenced in the SKILL.md body.
2. Assert each named skill directory exists under `skills/`.
3. Assert each claim of the form "skill X ships in bundle Y" matches the symlinks under
   `bundles/<Y>/skills/`.

**Success Criteria**:
- [ ] Every referenced skill directory exists.
- [ ] Every bundle-membership claim matches the symlinks on disk.
- [ ] The text no longer claims `project-foundations` supplies `timeline-planning` or
      `project-planning`.

**If Blocked**: stop if the bundle layout changes under a sibling PR; re-read the bundles.

### Scenario 2: Sub-skill hand-off is executable in the documented order

**Context**: Revised SKILL.md; a project description with no issues yet filed.

**Steps**:
1. Read the revised Steps 3, 5 and 6 and the sub-skills' own Step 1 input requirements.
2. Confirm the revised skill states where the issue list comes from at Steps 5 and 6 when
   no GitHub issues exist yet.
3. Run `gh issue list --state open` to confirm that the pre-creation issue set is empty of
   the planned work, i.e. that the GitHub-read path cannot supply it.

**Success Criteria**:
- [ ] Steps 5 and 6 name the in-memory Step 3 decomposition as the input.
- [ ] The `gh issue list` path is scoped to planning over already-filed issues.
- [ ] A reader can execute Steps 3 → 5 → 6 without the issues existing on GitHub.

**If Blocked**: none expected; this is a read of the revised text plus one `gh` read.

### Scenario 3: The issue-creation batch runs, with labels reconciled first

**Context**: Revised Step 8; `britt/agent-skills` label set.

**Steps**:
1. Run `gh label list` against the real repo.
2. Query the REST API for two labels from `issue-decomposition`'s default taxonomy.
3. Execute two `gh issue create` invocations through the dry-run shim with real
   `--title`/`--body-file`/`--label` arguments and capture `argv`.
4. Re-list the repo's issues to confirm nothing was created.

**Success Criteria**:
- [ ] Missing default-taxonomy labels are demonstrated against the real repo.
- [ ] The revised Step 8 requires reconciling labels before the batch runs.
- [ ] The revised Step 8 states what to do when the batch fails partway.
- [ ] `argv` capture shows well-formed `gh issue create` invocations.
- [ ] `gh issue list --state all` shows no new issues in `britt/agent-skills`.

**If Blocked**: if the shim is bypassed, abort — do not fall through to the real `gh`.

### Scenario 4: Plan document is produced at the documented path with real issue numbers

**Context**: Revised Step 8 and Planning Document Format.

**Steps**:
1. Write a plan document to `docs/plans/<slug>-plan.md` following the revised format,
   using plan-local ids before creation.
2. Apply the revised post-creation reconciliation step to substitute real issue numbers.
3. Render the document's Mermaid blocks through a syntax check.

**Success Criteria**:
- [ ] The document is written at `docs/plans/<slug>-plan.md`.
- [ ] No plan-local placeholder id survives into the reconciled document.
- [ ] Mermaid blocks parse.
- [ ] The save instruction appears exactly once in Step 8.

**If Blocked**: if no Mermaid parser is installed, fall back to bracket/paren linting per
the `mermaid-diagrams` rules and say so in the log.

### Scenario 5: Repo metadata stays consistent

**Context**: Edited SKILL.md, `marketplace.json`, `README.md`, site page.

**Steps**:
1. Parse `.claude-plugin/marketplace.json` and assert it is valid JSON.
2. Assert the `project-planning`, `agent-skills`, `llpm` and marketplace versions moved as
   intended and that `project-foundations` did not.
3. Assert the four full-bundle version locations are in lockstep per CONTRIBUTING.md.
4. Run `./sync-agents-skills.sh` and confirm a clean tree.

**Success Criteria**:
- [ ] `marketplace.json` parses.
- [ ] Versions match the intended bumps.
- [ ] The four full-bundle version locations agree.
- [ ] `sync-agents-skills.sh` produces no diff.

**If Blocked**: none expected.

## Verification Rules

- Never use mocks or fakes; the single dry-run shim is scoped to `gh issue create` and is
  declared in Prerequisites.
- If any success criterion fails, verification fails.
- No issue, PR, or label may be created, edited, or closed in `britt/agent-skills`.
