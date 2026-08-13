---
name: working-on-an-issue
description: Use when asked to work on, read, or implement a GitHub issue - hands-off workflow (understand, scoped recon, verification plan, implementation plan, implement, verify, PR) with no mid-flow approval gates; assumptions are documented in the plan and PR, and developer review happens on the pull request
---

# Working on an Issue

**Announce at start:** "I'm using the working-on-an-issue skill to implement this GitHub issue."

## Overview

A hands-off workflow for implementing GitHub issues. There are no approval gates before the pull request: the developer reviews finished work on the PR, so every judgment call you make must be recorded where they will see it.

**Core principle:** Understand → Update project status → Recon → Plan verification → Plan implementation → Implement → Verify → PR

**Create TodoWrite todos for the pre-flight checklist and each numbered step below.**

## When to Use

- Developer asks to work on or implement a GitHub issue
- Developer provides an issue URL or number

## When NOT to Use

- Issue is epic-sized or bundles multiple independent changes → run `issue-decomposition` first
- Issue is too vague to restate as testable acceptance criteria → run `requirement-elicitation`, or comment on the issue with your questions, and stop
- Triaging or labeling incoming issues → `triage-new-issues`

## Pre-flight Checklist

- [ ] Issue URL or number obtained
- [ ] Repository cloned; work branch created: `issue-<number>-<short-slug>`
- [ ] CLAUDE.md exists (or run `setting-up-a-project` first)

## The Process

### 1. Read the Whole Issue

Get the issue **and its comments**: `gh issue view <number> --comments` (or GitHub MCP tools, or ask for pasted content). Comments often supersede the body — the latest clarification wins. Check for linked or duplicate PRs already addressing it.

**Sizing check:** restate the issue as 1–5 testable acceptance criteria. If you can't, take the off-ramp in When NOT to Use instead of proceeding.

Do not invent requirements. Where the issue is ambiguous, choose the narrowest interpretation that satisfies the text and record it as an assumption — assumptions go in the plan file and the PR description, never unstated.

**Assumptions resolve ambiguity in *how*, never reduce *what* the issue asks for.** Dropping a named request ("deferred the tour") is not an assumption — it's a scope cut, and scope cuts go through `issue-decomposition`, not the assumptions list. Manufacturing acceptance criteria the issue never stated to pass the sizing check is the same violation.

### 2. Update Linked Project Status

Check whether the issue belongs to any GitHub Projects (v2). If it does, move it to an "in progress" style status in **every** project it belongs to before starting recon — this is what signals to anyone watching a board that work has actually begun.

Query the issue's project items via GraphQL (`gh issue view --json` does not expose Projects v2 membership):

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        projectItems(first: 20) {
          nodes {
            id
            project { id title number }
          }
        }
      }
    }
  }' -F owner=<owner> -F repo=<repo> -F number=<number>
```

If `projectItems.nodes` is empty, the issue isn't tracked in any project — skip the rest of this step.

For each project item returned, look up its status-like single-select field and options, then set it:

```bash
gh project field-list <project-number> --owner <owner> --format json   # locate the status field id + target option id
gh project item-edit --id <item-id> --project-id <project-id> \
  --field-id <status-field-id> --single-select-option-id <in-progress-option-id>
```

- Field and option names vary by project (`Status`/`In Progress`, `Doing`, `Started`, ...) — match case-insensitively on the option that most plausibly means "work has begun." If no such option exists, skip that project and note it rather than guessing.
- Do this for every project item found, not just the first — an issue can belong to more than one project.
- If the `gh` token lacks project scope or the update otherwise fails, don't block the workflow — record it as an assumption/caveat in the plan file and PR, and continue.

### 3. Scoped Reconnaissance

The issue bounds the exploration. Recon exists to *locate the change*, not to understand the codebase.

Stop exploring the moment you can answer all three:
1. Which files will change?
2. Which existing pattern or convention will the change follow?
3. Which tests cover this area?

**Budget:** start from files, symbols, and error messages the issue names; expand at most one hop (direct callers/callees and their tests). Check callers only to confirm the fix won't break them, then stop — "who uses this everywhere and how" is an architecture survey, not recon. If roughly 10 targeted searches haven't produced the file list, more exploration will not fix it — the issue is underspecified; take the off-ramp.

**Forbidden:** reading whole directories "for context", tracing beyond one hop, architecture surveys.

### 4. Write the Verification Plan

Use the `writing-verification-plans` skill. This comes before the implementation plan because acceptance criteria define done and constrain the implementation.

### 5. Write the Implementation Plan

Use `superpowers:writing-plans` (if available) or write a brief plan covering: what changes, which files, order of implementation, risks, and the assumptions from step 1. Save to `docs/plans/issue-<number>-plan.md`, then proceed — do not wait for approval.

### 6. Implement

- Follow TDD practices if `TDD.rules.md` is present (a project-level TDD rules file, if the repo defines one)
- Commit after each logical change; reference the issue in commit messages (e.g. `fix: handle empty input (#123)`)
- Unexpected complexity that invalidates the plan → update the plan file and note it for the PR description
- Genuinely blocked (missing credentials, contradictory requirements) → comment on the issue and stop

### 7. Execute Verification

Run the verification plan and record results in the log format from `writing-verification-plans`.

**If verification fails:** use `superpowers:systematic-debugging` to find the root cause — do not patch symptoms — then fix, re-run, and update the log. Never open the PR with failing verification (`superpowers:verification-before-completion` applies).

### 8. Open the Pull Request

Push the branch and create the PR: `gh pr create`. The PR body must include:

- `Fixes #<number>` so merging closes the issue — only if every named request in the issue is addressed; if anything was split out or deferred, use `Refs #<number>` and say what remains open
- Summary of the change
- Assumptions made (from the plan)
- Verification log results

**The PR is the approval gate.** Everything a reviewer needs to judge the work goes in it.

## Absolute Rules

- **No scope creep**: Only implement what's specified
- **Assumptions documented, never silent**: Narrowest reasonable interpretation, recorded in plan and PR
- **Verification before PR**: The task is incomplete until verification passes
- **Blocked = comment and stop**: Comment on the issue and stop — do not guess through contradictions
