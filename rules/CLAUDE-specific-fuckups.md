# Claude-Specific Failure Patterns

> Referenced by `CLAUDE.md`. This file is Claude Code-specific, not shared with
> `AGENTS.md` - it documents mistakes tied to this model's training data, not
> general project rules.

A running list of mistakes Claude Code makes repeatedly, usually because its
training data lags the tools and ecosystems it's operating in. Check this list
before work that touches an entry below. Add a new entry whenever a mistake
repeats rather than trusting it won't happen again.

## 1. Outdated GitHub Actions versions

Claude's training data is stale relative to the current state of GitHub
Actions. Defaults recalled from memory - action major versions, runner
choices, runtime pins - are frequently outdated by the time they're used, and
GitHub deprecates old runtimes (e.g. the Node 20 runtime) out from under
workflows that were fine when written.

**Before adding or editing any `uses:` step in a workflow file:**

1. Do not trust a version recalled from memory. Check the action's actual
   latest release/major version instead of guessing.
2. Confirm the action targets the current supported runtime, not a deprecated
   one.
3. If unsure, check the action's repository release notes or changelog rather
   than assuming.

A shipped workflow pinned to a version that was current during training is a
bug, not a reasonable default.

## 2. Leaving Playwright/Chrome instances running

Claude often drives Playwright MCP tools (`browser_navigate`,
`browser_click`, etc.) to test a change, then finishes the task without
closing the browser. The launched Chrome instance is left running in the
background, wasting memory and sometimes holding a lock that breaks the next
Playwright session.

**Before ending a task or turn that used Playwright:**

1. If you opened a browser via Playwright MCP tools, call `browser_close`
   once you're done driving it - don't leave it open "in case it's needed
   again."
2. If a task fails partway through browser automation, still close the
   browser during cleanup rather than abandoning it.
