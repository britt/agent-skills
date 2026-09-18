#!/bin/bash
#
# Build one zip archive per bundle for attaching to a GitHub release.
#
# A "bundle" is any plugin entry in .claude-plugin/marketplace.json whose
# source is not a single skill under ./skills/ — today that means agent-skills
# (the whole library, source "./"), project-foundations, and llpm. Dropping a
# new bundle into bundles/ and adding its marketplace entry is enough; nothing
# in this script or the release workflow needs to change.
#
# Archives are named <bundle>-<version>.zip, with the version read from that
# bundle's own .claude-plugin/plugin.json — bundle versions move independently
# of the repo's release tags.
#
# Skills inside bundles/ are symlinks into skills/. They are dereferenced here
# so each archive carries real files and unzips standalone.

set -euo pipefail

cd "$(dirname "$0")"

MARKETPLACE=".claude-plugin/marketplace.json"
DIST="$(pwd)/dist"
STAGE="$DIST/.stage"

# Bundles that also carry a zip per skill at the archive root, alongside
# skills/. Chat agents take skills one at a time as uploads, so shipping them
# pre-zipped saves unpacking and re-zipping by hand.
NESTED_SKILL_ZIPS=(chat)

# What goes into the full-library archive (source "./"). The repo root also
# holds site/, docs/, and .github/, which have no place in a plugin install.
# .agents/ is omitted deliberately: it is a symlink farm pointing back into
# skills/, and dereferencing it would duplicate every skill in the archive.
ROOT_INCLUDES=(
  .claude-plugin
  .codex-plugin
  .cursor-plugin
  skills
  rules
  README.md
  LICENSE
)

command -v jq >/dev/null || { echo "error: jq is required" >&2; exit 1; }
command -v zip >/dev/null || { echo "error: zip is required" >&2; exit 1; }

rm -rf "$STAGE"
mkdir -p "$STAGE"

count=0
while IFS=$'\t' read -r name source; do
  version=$(jq -r '.version' "$source/.claude-plugin/plugin.json")
  if [ -z "$version" ] || [ "$version" = "null" ]; then
    echo "error: no version in $source/.claude-plugin/plugin.json" >&2
    exit 1
  fi

  stage_dir="$STAGE/$name"
  mkdir -p "$stage_dir"

  # -L dereferences the skill symlinks inside bundles/
  if [ "$source" = "./" ]; then
    for item in "${ROOT_INCLUDES[@]}"; do
      cp -RL "$item" "$stage_dir/"
    done
  else
    cp -RL "$source/." "$stage_dir/"
  fi

  # Nested per-skill zips, each holding <skill>/ at its root so it can be
  # uploaded to a chat agent as-is.
  for nested in "${NESTED_SKILL_ZIPS[@]}"; do
    if [ "$name" = "$nested" ]; then
      for skill_path in "$stage_dir"/skills/*/; do
        [ -d "$skill_path" ] || continue
        skill=$(basename "$skill_path")
        (cd "$stage_dir/skills" && zip -rq "../$skill.zip" "$skill")
      done
    fi
  done

  archive="$name-$version.zip"
  rm -f "$DIST/$archive"
  (cd "$stage_dir" && zip -rq "$DIST/$archive" .)

  echo "Created dist/$archive ($(find "$stage_dir" -type f | wc -l | tr -d ' ') files)"
  count=$((count + 1))
done < <(jq -r '
  .plugins[]
  | select(.source | startswith("./skills/") | not)
  | [.name, .source] | @tsv
' "$MARKETPLACE")

rm -rf "$STAGE"

# A jq failure or a marketplace file with no bundle entries would otherwise
# leave the release workflow uploading nothing, quietly.
if [ "$count" -eq 0 ]; then
  echo "error: no bundles found in $MARKETPLACE" >&2
  exit 1
fi

echo "Done! $count bundle archive(s) in dist/"
