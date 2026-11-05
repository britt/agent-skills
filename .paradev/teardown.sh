#!/bin/bash
# Runs when a workspace is deleted.
#
# Setup starts no services - no containers, no databases, no servers - so there
# is nothing to stop here. Everything setup creates (the Hugo theme submodule
# checkout, the .agents/skills symlinks) lives inside the workspace directory
# and goes away when the worktree does, as does the submodule's clone under
# .git/worktrees/<workspace>/modules/.
#
# Two things are deliberately NOT done:
#   - `git submodule deinit`: a linked worktree shares .git/config with the main
#     checkout and every other workspace, so deinit would strip the submodule
#     entry out from under all of them.
#   - deleting site/themes/re-terminal: that leaves the worktree dirty with a
#     staged-looking deletion, which can make `git worktree remove` refuse.
#
# So all that is left is gitignored build output. Best-effort - teardown must
# never block deleting a workspace.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 0

rm -rf dist site/public site/resources site/.hugo_build.lock || true

exit 0
