---
title: "Repairing Project Setup"
description: "Audit a repo's agent setup against what Setting Up a Project would generate today and repair only the gaps"
---

Check a real repository against the target state that [Setting Up a Project]({{< relref "skills/setting-up-a-project.md" >}}) defines, then repair the difference. The existing files record decisions you already made, so the skill keeps every one of them and fixes only what is missing or wrong — it never rebuilds from scratch.

## Supported coding agents

| Coding agent | Supported |
|--------------|:---------:|
| Claude Code | ✓ |
| Codex CLI | ✓ |
| OpenCode | ✓ |
| Cursor | ✓ |

## How to use it

Use this skill when:
- A Setting Up a Project run failed or was interrupted partway
- `CLAUDE.md` or `AGENTS.md` exists but is thin, stale, or missing sections
- The setup shows symptoms of breakage: leftover `{{PLACEHOLDER}}` text, a symlinked `AGENTS.md`, documented commands that fail, or the two instruction files disagreeing
- Setting Up a Project has changed since the repo was set up, and the repo should catch up
- You want a pre-flight check before starting work on an issue

If the repo has never been set up at all, run Setting Up a Project instead. If it has mature agent instructions that clearly follow a different scheme, the skill reports the differences and asks rather than converting them.

## Features

**The current skill is the spec**
Loads the current Setting Up a Project skill and its canonical rule files before auditing, so the check measures the repo against what the setup would produce today, not against an outdated memory of it.

**A full audit before any edit**
Runs every check — required sections in both instruction files, no symlinked or singular `AGENT.md`, no unfilled placeholders, rule files matching their canonical copies, a verification plan in place, every documented command actually running, and the two files agreeing — and records each as pass, fail, or not applicable before touching anything.

**Merge, never overwrite**
Reads every file before editing it, keeps your wording, adds only missing sections, and corrects only what is wrong. Rule files that must stay verbatim are repaired by copying from the canonical source and filling placeholders, nothing else.

**Evidence over interview**
Fills gaps from manifests, lockfiles, CI workflows, git history, and the existing files. In an interactive session it asks one question at a time, and only about what the repo cannot answer; in an autonomous session it applies the documented defaults and records every assumption.

**Verified, reported repairs**
Commits after each repaired area, re-runs the whole audit so a fix cannot quietly break a neighboring check, and reports each check's before state, the action taken, and its after state. A clean audit is a valid result: it says so and changes nothing.
