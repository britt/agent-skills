---
name: working-on-an-issue
description: Use when asked to work on, read, or implement a GitHub issue - structured understand, plan, verify, implement, verify workflow with developer approval gates and mandatory verification
---

# Working on an Issue

**Announce at start:** "I'm using the working-on-an-issue skill to implement this GitHub issue."

## Overview

A structured workflow for implementing GitHub issues with verification.

**Core Principle:** Understand → Plan → Verify → Implement → Verify Again

## When to Use

- Developer asks to work on a GitHub issue
- Developer asks to implement an issue
- Developer provides an issue URL or number

## Pre-flight Checklist

Before starting:
- [ ] Issue URL or number obtained
- [ ] Repository cloned and on correct branch
- [ ] CLAUDE.md exists (or run `setting-up-a-project` first)
- [ ] Developer available for questions (or async mode agreed)

## The Process

### 1. Read and Understand the Issue

Get the issue content via:
- GitHub CLI: `gh issue view <number>`
- Ask user to paste the issue content
- Use GitHub MCP tools if available

**Clarify before proceeding:**
- If requirements are ambiguous, ask specific questions
- If acceptance criteria are missing, propose them
- If scope is unclear, confirm boundaries

**Do not assume or invent requirements not in the issue.**

### 2. Write an Implementation Plan

Use the `superpowers:writing-plans` skill (if available) or create a brief plan covering:
1. What changes are needed
2. Which files will be modified/created
3. Order of implementation
4. Risks or unknowns

Save to `docs/plans/issue-<number>-plan.md` and get developer approval before proceeding.

### 3. Write a Verification Plan

Use the `writing-verification-plans` skill to create acceptance tests for the issue.

### 4. Implement

- Follow TDD practices if `TDD.rules.md` is present (a project-level TDD rules file, if the repo defines one)
- Commit after each logical change
- Pause and ask if you hit unexpected complexity

### 5. Execute Verification

Run the verification plan. Report results using the verification log format from the `writing-verification-plans` skill.

## Absolute Rules

- **No assumptions**: Ask if anything is unclear
- **No scope creep**: Only implement what's specified
- **Verification required**: Task is incomplete until verification passes or developer confirms manual verification
- **Blocked = Stop**: If blocked, stop and ask the developer — do not guess.
