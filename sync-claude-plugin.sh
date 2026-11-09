#!/bin/bash
#
# Materialize claude-plugin/, the plugin folder submitted to Anthropic's
# plugin directory, from the canonical sources at the repo root.
#
# The directory reads one plugin folder: the folder holding
# .claude-plugin/plugin.json. Submitting the repo root fails its checks, because
# the root is also a marketplace that lists several plugins, carries a symlink
# farm under .agents/skills/, a git submodule under site/, and a README written
# for four different tools. claude-plugin/ holds exactly one plugin and nothing
# else, so the directory's "Plugin path" setting can point at it.
#
# Generated (never edit by hand; this script wipes and recreates them):
#   claude-plugin/.claude-plugin/plugin.json   copy of .claude-plugin/plugin.json
#   claude-plugin/skills/                      copy of skills/, minus
#                                              EXCLUDED_SKILLS (below)
#   claude-plugin/assets/icon.png              copy of assets/icon.png
#   claude-plugin/LICENSE                      copy of LICENSE
#
# Hand-maintained (this script leaves it alone and fails if it is missing):
#   claude-plugin/README.md                    the directory shows it as the
#                                              listing's description
#
# .github/workflows/sync-claude-plugin.yml runs this on every push to main and
# commits the result, so merging a PR is enough to update the folder.
# check-claude-plugin.sh verifies the folder; sync-agents-skills.sh also runs
# this script for local use.

set -euo pipefail

cd "$(dirname "$0")"

PLUGIN=claude-plugin
MANIFEST=.claude-plugin/plugin.json
ICON=assets/icon.png

# Skills left out of the directory copy. The directory accepts only Markdown,
# text, JSON, YAML and a few image types from organizations that are not
# Verified, and refuses any file that starts with #!. These two skills depend
# on a bundled shell script (scripts/pr-watcher.sh), so they cannot ship
# without it; they stay available from the repository's own marketplace.
# check-claude-plugin.sh reads this list too.
EXCLUDED_SKILLS=(supervising-conductor-workspaces supervising-paradev-workspaces)

for src in "$MANIFEST" skills "$ICON" LICENSE; do
  [ -e "$src" ] || { echo "error: $src is missing" >&2; exit 1; }
done

if [ ! -f "$PLUGIN/README.md" ]; then
  echo "error: $PLUGIN/README.md is missing; it is hand-maintained, not generated" >&2
  exit 1
fi

# Wipe the generated parts so nothing stale survives a removed skill.
rm -rf "$PLUGIN/.claude-plugin" "$PLUGIN/skills" "$PLUGIN/assets" "$PLUGIN/LICENSE"
mkdir -p "$PLUGIN/.claude-plugin" "$PLUGIN/assets"

# -p keeps file modes identical to the sources, which check-claude-plugin.sh compares.
cp -p "$MANIFEST" "$PLUGIN/$MANIFEST"
cp -Rp skills "$PLUGIN/skills"
for skill in "${EXCLUDED_SKILLS[@]}"; do
  rm -rf "${PLUGIN:?}/skills/$skill"
done
cp -p "$ICON" "$PLUGIN/$ICON"
cp -p LICENSE "$PLUGIN/LICENSE"

# The directory blocks a submission over these; keep them out of the copy even
# if they sneak into skills/ on a contributor's machine.
find "$PLUGIN" \( -name .DS_Store -o -name Thumbs.db -o -name desktop.ini -o -name __MACOSX \) \
  -prune -exec rm -rf {} +

count=$(find "$PLUGIN/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo "Synced $PLUGIN/ ($count skills, manifest, icon, license)"
