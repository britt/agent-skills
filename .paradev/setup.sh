#!/bin/bash
# Prepare a fresh workspace for this repo.
#
# There are no package-manager dependencies here: the repo is Markdown skills,
# JSON plugin manifests, shell scripts, and a Hugo site. The two things a new
# worktree does NOT inherit are the Hugo theme submodule (git worktrees start
# with submodules uninitialized) and anything sync-agents-skills.sh would
# regenerate. Both are handled below. Both are idempotent and fast.
set -euo pipefail

cd "$(dirname "$0")/.."

# site/themes/re-terminal is a submodule; without it `hugo` fails to build.
echo "==> Initializing git submodules (Hugo theme)"
git submodule update --init --recursive

# Adds any missing .agents/skills/<name> symlinks and re-mirrors rules/.
# Committed content, so this is normally a no-op - it just keeps a workspace
# correct if a skill was added on a branch without the link.
echo "==> Syncing .agents/skills/ and rules/"
./sync-agents-skills.sh

# Hugo is the only tool the site needs, and it must be the extended build
# (the theme compiles SCSS). Warn rather than fail: most work in this repo is
# on skills and never touches the site.
echo "==> Checking tooling"
if hugo version 2>/dev/null | grep -q extended; then
  hugo version
else
  echo "WARNING: hugo extended not found. The site/ dev server (Run) will not work."
  echo "         Install it with: brew install hugo"
fi

echo "==> Workspace ready"
