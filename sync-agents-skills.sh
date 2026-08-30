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

# Mirror bundled rule sets into rules/ so they are fetchable by raw URL.
# The copy inside the skill is canonical: single-skill plugin installs use
# "source": "./skills/<name>", so the skill must stay self-contained. A symlink
# would dangle there, and raw.githubusercontent.com serves a symlink as its
# target path rather than the file contents - so this is a real copy.
mkdir -p rules
for f in TDD.rules.md CLAUDE-specific-fuckups.md; do
  cp "skills/setting-up-a-project/$f" "rules/$f"
  echo "Mirrored rules/$f from skills/setting-up-a-project/."
done
