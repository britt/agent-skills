---
name: changelog-generation
description: Generate a changelog from git history using conventional commit messages, grouped by release type
---

# Changelog Generation

Generate well-formatted changelogs from git commit history using conventional commit conventions.

## When to Use

- User asks to "generate a changelog" or "write release notes"
- Before publishing a new release
- When summarizing changes between two git tags or branches

## Process

1. **Identify the range**: Ask the user for the start and end points (tags, branches, or commits). Default to changes since the last tag.

2. **Parse commits**: Read git log for the specified range and categorize by conventional commit prefix:

   | Prefix | Changelog Section |
   |--------|------------------|
   | `feat` | Features |
   | `fix` | Bug Fixes |
   | `perf` | Performance Improvements |
   | `docs` | Documentation |
   | `refactor` | Code Refactoring |
   | `test` | Tests |
   | `chore` | Maintenance |

3. **Detect breaking changes**: Scan commit footers for `BREAKING CHANGE:` tokens. List these prominently at the top of the changelog.

4. **Format output**: Generate Markdown grouped by section:

   ```markdown
   # Changelog

   ## [version] - YYYY-MM-DD

   ### Breaking Changes
   - **scope:** description of breaking change

   ### Features
   - **scope:** description (#PR)

   ### Bug Fixes
   - **scope:** description (#PR)
   ```

5. **Review with user**: Present the draft changelog and ask if any entries should be reworded, reordered, or removed before finalizing.

## Key Principles

- Only include user-facing changes by default (skip `chore`, `test`, `refactor` unless asked)
- Use the commit scope as a bold prefix for readability
- Link to PRs or issues when reference numbers are present in the commit message
- Group related changes together even if they span multiple commits
