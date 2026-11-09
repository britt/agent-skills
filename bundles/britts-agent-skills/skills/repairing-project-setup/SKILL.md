---
name: repairing-project-setup
description: Use when a repo's agent setup may be broken, half-finished, or drifted - a setting-up-a-project run failed partway, CLAUDE.md or AGENTS.md is thin or missing sections, leftover {{PLACEHOLDER}} text, AGENTS.md is a symlink, the instruction files disagree, or agents behave inconsistently in the repo - audits the project against what setting-up-a-project would generate today and repairs only the gaps, preserving existing content
---

# Repairing Project Setup

## Overview

The `setting-up-a-project` skill defines what a correctly configured project looks like. This skill checks a real repo against that target state and repairs the delta.

**Core principle: repair the delta, never rebuild.** The existing files record decisions the user already made. Your job is to bring them in line with what `setting-up-a-project` would generate, keeping every decision already recorded.

## When to Use

- A `setting-up-a-project` run failed or was interrupted partway
- `CLAUDE.md` or `AGENTS.md` exists but is thin, stale, or missing sections
- Symptoms of a broken setup: unfilled `{{PLACEHOLDER}}` text, an `AGENTS.md` symlink, an `AGENT.md` (singular), documented commands that fail, the two instruction files disagreeing, agents behaving inconsistently in the repo
- `setting-up-a-project` has changed since this project was set up, and the project should catch up
- As a pre-flight check before starting work (e.g. the `working-on-an-issue` checklist)

## When NOT to Use

- **Never set up at all** (no `CLAUDE.md`, no `AGENTS.md`, no rule files): run `setting-up-a-project` itself - the interview matters and there is nothing to preserve.
- **A deliberate, different scheme**: if the repo has mature agent instructions that clearly never followed `setting-up-a-project`, do not convert it uninvited. Report the differences and ask.

## The Process

### 1. Load the Spec

Read the current `setting-up-a-project` SKILL.md - via the Skill tool, or from the installed plugin's skill directory. **It is the source of truth.** The audit table below is a fast index of its requirements; if the two ever disagree, the skill file wins - it evolves, this table can lag.

The canonical rule files sit next to that SKILL.md: `TDD.rules.md`, `git-commit-rules.md`, `CLAUDE-specific-fuckups.md`. If you cannot find them locally, fetch:

- `https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/rules/TDD.rules.md`
- `https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/rules/CLAUDE-specific-fuckups.md`
- `https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/skills/setting-up-a-project/git-commit-rules.md`

### 2. Audit - Before Touching Anything

Run every check and record PASS / FAIL / N-A. Do not start fixing mid-audit; a full picture first prevents piecemeal edits that miss cross-file drift.

| # | Check | How |
|---|-------|-----|
| 1 | `CLAUDE.md` exists with the sections from the skill's "Finished Files" list (Overview, Tech Stack, Commands, Development Practices; Layout / Environment / Boundaries / CI-CD as applicable) | read headings |
| 2 | `AGENTS.md` exists and is a real file | `test -L AGENTS.md && echo "symlink - defect"` |
| 3 | No `AGENT.md` (singular) - no agent reads it | `ls AGENT.md` fails |
| 4 | `AGENTS.md` has Required Reading, Non-Negotiables, and Maintaining This File sections | read headings |
| 5 | `AGENTS.md` carries no Claude Code-isms | `grep -nE '@[[:alnum:]]|TodoWrite|\.claude/' AGENTS.md` returns nothing |
| 6 | No unfilled placeholders anywhere | `grep -Fn '{{' CLAUDE.md AGENTS.md TDD.rules.md` returns nothing |
| 7 | `TDD.rules.md` at project root, template banner removed, structurally matching the canonical template | `diff` against canonical; only placeholder values and the banner should differ |
| 8 | `CLAUDE.md` points at `TDD.rules.md` in prose **and** via `@TDD.rules.md` | grep |
| 9 | Commit rules present verbatim in both `CLAUDE.md` and `AGENTS.md` | compare against canonical `git-commit-rules.md` |
| 10 | `CLAUDE-specific-fuckups.md` at root, byte-identical to canonical, referenced from `CLAUDE.md` and **not** from `AGENTS.md` | `diff` + grep |
| 11 | `VERIFICATION_PLAN.md` exists; `CLAUDE.md` has a Verification section with `@VERIFICATION_PLAN.md`; it appears in `AGENTS.md` Required Reading | grep |
| 12 | Every command in the Commands table actually runs | run each one |
| 13 | `CLAUDE.md` and `AGENTS.md` agree on commands, stack, layout, and boundaries | read both, side by side |
| 14 | CI/CD Practices section present iff the repo uses GitHub Actions | `ls .github/workflows/` |
| 15 | `.claude/settings.json` command allowlist | note only - optional, consent required |

### 3. Repair

Fix only the FAIL rows, under these rules:

- **Merge, never overwrite.** Read every file before editing it. Keep the user's wording; add only missing sections; correct only what is wrong. If `CLAUDE.md` says something `setting-up-a-project` would not have written but it is a project fact, it stays.
- **Verbatim files stay verbatim.** Repair `TDD.rules.md`, the commit rules, and `CLAUDE-specific-fuckups.md` by copying from the canonical source and filling placeholders - nothing else. If the project has no linter or build step, fill that placeholder with an honest value (`echo "no linter configured - update this line when one is added"`), do not delete the rule sections that mention it.
- **Evidence over interview.** Fill gaps from the repo itself: manifests, lockfiles, CI workflows, git history, the existing files. Interactive session: confirm conclusions, one question at a time, only for what the repo cannot answer. Autonomous session: apply the defaults `setting-up-a-project` documents (e.g. 90%/85% coverage) and record every assumption for the final report.
- **A documented command that fails is always a FAIL** - fix the command (add the missing script) or fix the docs (remove the phantom row), whichever matches what the project actually has. Never leave it.
- **`VERIFICATION_PLAN.md` is not optional.** Missing means write it, with the `writing-verification-plans` skill if available. A young project gets scenarios scoped to what exists today - not a skipped file.
- **`.claude/settings.json` needs consent.** Offer it if missing; in an autonomous session, recommend it in the report instead of writing it.
- **Commit after each repaired area**, per the commit rules.

### 4. Verify, Then Report

Re-run the entire audit table - every row must now be PASS or N-A, including the ones that passed before your edits (a repair can break a neighbor). Then run `setting-up-a-project`'s own final verification step (its step 9).

Report: each check as before → action → after, plus every assumption made. If the audit was clean at step 2, say so and change nothing - a clean audit is a valid result.

## Rationalizations - All Wrong

| Excuse | Reality |
|--------|---------|
| "The project is too young for honest verification scenarios" | `writing-verification-plans` handles nascent projects. Scope scenarios to what exists. Skipping leaves `AGENTS.md` telling agents to read a file that isn't there. |
| "This rule section doesn't apply here, I'll delete it" | Fill the placeholder with an honest value instead. Pruned copies drift from canonical and can never be diffed again. |
| "The existing CLAUDE.md is messy - cleaner to rewrite it" | A rewrite destroys recorded decisions. Merge. |
| "The obvious defects are fixed, that's surely all of them" | Drift lives in the subtle rows: verbatim diffs, cross-file agreement, commands that run. Every row, every time. |
| "I'll just run the full setting-up-a-project interview again" | That interrogates the user about facts the repo and existing files already answer. Audit and repair instead; fall back to the full skill only when nothing exists. |
| "It passed before my edit, no need to re-check" | Repairs break neighbors - a fixed command row can desync `AGENTS.md`. Re-run the whole table. |

## Red Flags - STOP

- About to `Write` over a `CLAUDE.md` or `AGENTS.md` you haven't read
- Paraphrasing or "improving" a rule file instead of copying it
- Deleting sections from a verbatim file
- Asking the user something a manifest, workflow, or existing file answers
- Declaring done without re-running the audit table

## Common Mistakes

- Auditing only `CLAUDE.md` and forgetting `AGENTS.md` must independently agree with it
- Treating a symlinked `AGENTS.md` as "close enough" - it ships `@` imports to agents that read them as dead text
- Filling placeholders with plausible commands instead of ones verified against `package.json` / Makefile / CI
- Comparing rule files by eye instead of `diff` against the canonical copy
- Fixing files without committing per area, so a later failure loses everything
- Skipping the spec-loading step and auditing against memory of what `setting-up-a-project` used to say
