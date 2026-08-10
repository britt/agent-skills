#!/bin/bash
# Keep .agents/skills/ in sync with skills/ so Codex CLI, OpenCode, and
# Cursor (which all discover skills under .agents/skills/) see the same
# canonical skill content as Claude Code, with no duplicated files.
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p .agents/skills

# Add a symlink for any skill missing one.
for dir in skills/*/; do
  name=$(basename "$dir")
  link=".agents/skills/$name"
  if [ ! -e "$link" ]; then
    ln -s "../../skills/$name" "$link"
    echo "Linked $link -> skills/$name"
  fi
done

# Remove symlinks for skills that no longer exist.
for link in .agents/skills/*/; do
  name=$(basename "$link")
  if [ ! -d "skills/$name" ]; then
    rm "$link" 2>/dev/null || rm -rf "${link%/}"
    echo "Removed stale link .agents/skills/$name"
  fi
done

echo "Done! .agents/skills/ is in sync with skills/."
