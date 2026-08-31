---
title: "Repairing Project Setup"
description: "Restore an existing project's agent setup to the current setting-up-a-project specification without discarding recorded decisions"
---

A successful repair brings an existing project setup back into agreement with the current [setting-up-a-project]({{< relref "skills/setting-up-a-project.md" >}}) specification. It closes setup gaps without discarding the decisions and wording already recorded in the project.

## Prerequisites and when to use this guide

Use `repairing-project-setup` when the project has an existing setup that may have failed, stopped partway through, or drifted from the current specification. Typical symptoms include:

- `CLAUDE.md` or `AGENTS.md` exists but lacks sections or contains stale guidance.
- `{{PLACEHOLDER}}` text remains in the setup files.
- `AGENTS.md` is a symlink, or the project has an `AGENT.md` file instead of `AGENTS.md`.
- A command documented in the setup fails.
- `CLAUDE.md` and `AGENTS.md` disagree, or agents behave inconsistently in the project.
- The `setting-up-a-project` skill changed after the project setup ran.
- A pre-flight check should confirm the setup before work begins.

Do not use this skill in either of these cases:

- **The project has never had setup.** When `CLAUDE.md`, `AGENTS.md`, and the rule files do not exist, use [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}). Its interview supplies the decisions that a repair preserves.
- **The project deliberately follows a different mature scheme.** Report the differences and ask before changing it. Do not convert the project to the `setting-up-a-project` scheme without consent.

## Process

### 1. Load the current setup specification

Read the current `setting-up-a-project` skill before auditing anything. Treat it as the source of truth rather than relying on memory or on this guide's audit summary.

Read the canonical rule files next to that skill:

- `TDD.rules.md`
- `git-commit-rules.md`
- `CLAUDE-specific-fuckups.md`

When local copies are unavailable, use the documented raw files:

- [`TDD.rules.md`](https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/rules/TDD.rules.md)
- [`CLAUDE-specific-fuckups.md`](https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/rules/CLAUDE-specific-fuckups.md)
- [`git-commit-rules.md`](https://raw.githubusercontent.com/britt/agent-skills/refs/heads/main/skills/setting-up-a-project/git-commit-rules.md)

### 2. Complete the audit before editing

Run and record all 15 checks before touching any file. Record each check as `PASS`, `FAIL`, or `N-A`; do not repair a defect during the audit. A complete audit prevents an early fix from hiding a related problem elsewhere.

Check the following areas:

1. `CLAUDE.md` exists with `Project Overview`, `Tech Stack`, `Commands`, and `Development Practices`, plus applicable `Repository Layout`, `Environment`, `Boundaries`, and `CI/CD Practices` sections.
2. `AGENTS.md` exists as a real file.
3. The project has no singular `AGENT.md` file.
4. `AGENTS.md` contains `Required Reading`, `Non-Negotiables`, and `Maintaining This File` sections.
5. `AGENTS.md` contains no Claude Code specific content that other agents cannot use.
6. `CLAUDE.md`, `AGENTS.md`, and `TDD.rules.md` contain no unfilled placeholders.
7. The root `TDD.rules.md` matches the canonical structure; only the template banner removal and project-specific placeholder values differ.
8. `CLAUDE.md` points to `TDD.rules.md` in prose and through its `@TDD.rules.md` import.
9. Both instruction files contain the canonical commit rules verbatim.
10. The root `CLAUDE-specific-fuckups.md` matches the canonical file, `CLAUDE.md` references it, and `AGENTS.md` does not.
11. `VERIFICATION_PLAN.md` exists, `CLAUDE.md` has a `Verification` section with `@VERIFICATION_PLAN.md`, and `AGENTS.md` lists it under `Required Reading`.
12. Every command in the `Commands` section runs successfully.
13. `CLAUDE.md` and `AGENTS.md` agree about commands, the stack, the repository layout, and boundaries.
14. `CI/CD Practices` appears exactly when the project uses GitHub Actions.
15. The optional `.claude/settings.json` command allowlist is recorded as a note without imposing a change that requires consent.

### 3. Repair only failed checks

Repair the delta identified by the audit. Do not rebuild the setup.

- Read every file before editing it. Merge missing sections into existing files, preserve existing decisions and wording, and correct only what conflicts with the current specification.
- Keep `TDD.rules.md`, `git-commit-rules.md`, and `CLAUDE-specific-fuckups.md` verbatim against their canonical sources. Fill project values honestly, including values for capabilities the project does not currently use; do not delete canonical sections.
- Use repository evidence from manifests, lockfiles, workflows, git history, and existing files to fill gaps. Confirm only conclusions that the repository cannot answer, and record assumptions when the session cannot ask.
- Treat every failing documented command as a failed check. Correct the command or correct the documentation to match the project; do not leave a command that does not run.
- Create `VERIFICATION_PLAN.md` when it is missing. Scope it to the project's current state rather than skipping it because the project is young.
- Offer `.claude/settings.json` only with consent. In an autonomous session, recommend it in the report instead of creating it.
- Commit after each repaired area according to the project's commit rules.

> **Repair boundary:** The audit decides what to change. A failed row permits a targeted repair; a passing row remains untouched.

### 4. Re-audit and verify before reporting

Run the entire 15-check audit again after all repairs, including every check that passed before editing. Every row must now be `PASS` or `N-A`; a repair can introduce drift in a neighboring check.

Then run the final verification from `setting-up-a-project`: run every documented command, check `CLAUDE.md`, `AGENTS.md`, and `TDD.rules.md` for placeholders, check `AGENTS.md` for Claude Code specific content, confirm agreement between the instruction files, confirm that `AGENTS.md` is a real file, and reread both files for contradictions. Apply `elements-of-style:writing-clearly-and-concisely` when available, then commit as required.

Report each check as **before → action → after**, followed by every assumption made. If the initial audit was clean, report that result and change nothing.

## Availability

`repairing-project-setup` ships through the full `agent-skills` bundle and the curated [Project Foundations bundle]({{< relref "skills/project-foundations.md" >}}). It is not a standalone marketplace installation. Use the repository's [installation guidance]({{< relref "_index.md" >}}) for the supported bundle and agent installation paths rather than installing this skill with a per-skill plugin command.