#!/bin/bash
#
# Fail if claude-plugin/ (the folder submitted to Anthropic's plugin directory)
# has drifted from its sources or breaks a directory rule we can check locally.
#
# The directory's pre-submission checklist
# (https://claude.com/docs/plugins/pre-submission-checklist) is the source of
# the rules below. This checks that:
#   - the generated parts match their sources file for file, including the
#     executable bit (the fix is ./sync-claude-plugin.sh);
#   - nothing in the folder is a symlink (the directory wants regular files);
#   - no .DS_Store, Thumbs.db, desktop.ini or __MACOSX entry is present;
#   - .claude-plugin/plugin.json parses, names the plugin, and carries a
#     license, an icon that exists, and a version;
#   - README.md exists, has at least 40 words outside code blocks, and names
#     every skill in skills/ in backticks, so it cannot go stale silently;
#   - every non-image file is under 256 KiB, every file is under 5 MiB, and
#     the folder holds 512 files or fewer (the directory holds a version for
#     a reviewer above the first two and stops validating above the last).
#
# Run from CI after ./sync-claude-plugin.sh, and locally before a PR.

set -euo pipefail

cd "$(dirname "$0")"

PLUGIN=claude-plugin
MANIFEST=.claude-plugin/plugin.json
ICON=assets/icon.png

command -v jq >/dev/null || { echo "error: jq is required" >&2; exit 1; }

fail=0
err() {
  echo "error: $*" >&2
  fail=1
}

[ -d "$PLUGIN" ] || { echo "error: $PLUGIN/ is missing; run ./sync-claude-plugin.sh" >&2; exit 1; }

# "<mode> <relative path>" for every file and directory under a tree.
modes() {
  (cd "$1" && find . -printf '%m %p\n' | LC_ALL=C sort)
}

# --- generated parts match their sources ------------------------------------

for pair in "$MANIFEST" "$ICON" LICENSE; do
  if ! cmp -s "$pair" "$PLUGIN/$pair"; then
    err "$PLUGIN/$pair differs from $pair (or is missing)"
  fi
done

if [ ! -d "$PLUGIN/skills" ]; then
  err "$PLUGIN/skills is missing"
elif ! diff -r skills "$PLUGIN/skills" >/dev/null; then
  err "$PLUGIN/skills differs from skills/:"
  diff -rq skills "$PLUGIN/skills" | sed 's/^/  /' >&2 || true
elif [ "$(modes skills)" != "$(modes "$PLUGIN/skills")" ]; then
  err "$PLUGIN/skills file modes differ from skills/"
fi

# Nothing in the folder beyond the generated parts and the README. An extra
# file would be published to everyone who installs the plugin.
while IFS= read -r entry; do
  case "$entry" in
    .claude-plugin|skills|assets|LICENSE|README.md) ;;
    *) err "$PLUGIN/$entry is not one of the known plugin folder entries" ;;
  esac
done < <(cd "$PLUGIN" && find . -mindepth 1 -maxdepth 1 -printf '%f\n')

# --- directory rules on the folder's contents --------------------------------

links=$(find "$PLUGIN" -type l)
if [ -n "$links" ]; then
  while IFS= read -r link; do
    err "$link is a symlink; the directory wants regular files"
  done <<< "$links"
fi

junk=$(find "$PLUGIN" \( -name .DS_Store -o -name Thumbs.db -o -name desktop.ini -o -name __MACOSX \))
if [ -n "$junk" ]; then
  while IFS= read -r f; do
    err "$f is an OS system file; the directory blocks a submission that has one"
  done <<< "$junk"
fi

total=$(find "$PLUGIN" -type f | wc -l | tr -d ' ')
if [ "$total" -gt 512 ]; then
  err "$PLUGIN holds $total files; the directory holds more than 512 for a reviewer"
fi

while IFS= read -r f; do
  size=$(stat -c %s "$f")
  if [ "$size" -ge $((5 * 1024 * 1024)) ]; then
    err "$f is $size bytes; every file must be under 5 MiB"
  fi
  case "$f" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg|*.woff|*.woff2|*.ttf|*.otf) ;;
    *)
      if [ "$size" -ge $((256 * 1024)) ]; then
        err "$f is $size bytes; a non-image file of 256 KiB or more is held for a reviewer"
      fi
      ;;
  esac
done < <(find "$PLUGIN" -type f)

# --- manifest ----------------------------------------------------------------

manifest="$PLUGIN/$MANIFEST"
if [ -f "$manifest" ]; then
  if ! jq -e . "$manifest" >/dev/null 2>&1; then
    err "$manifest is not valid JSON"
  else
    name=$(jq -r '.name // ""' "$manifest")
    [ "$name" = "britts-agent-skills" ] || err "$manifest: name is '$name', expected britts-agent-skills"
    [ "$(jq -r '.version // ""' "$manifest")" != "" ] || err "$manifest: version is missing"
    [ "$(jq -r '.description // ""' "$manifest")" != "" ] || err "$manifest: description is missing"
    [ "$(jq -r '.author.name // ""' "$manifest")" != "" ] || err "$manifest: author.name is missing"
    if [ "$(jq -r '.license // ""' "$manifest")" = "" ] && [ ! -f "$PLUGIN/LICENSE" ]; then
      err "$manifest: no license field and no $PLUGIN/LICENSE; the directory blocks this"
    fi
    icon=$(jq -r '.icon // ""' "$manifest")
    if [ -n "$icon" ]; then
      case "$icon" in
        ./*) [ -f "$PLUGIN/${icon#./}" ] || err "$manifest: icon $icon does not exist inside $PLUGIN/" ;;
        *) err "$manifest: icon '$icon' must be a ./ path inside the plugin folder" ;;
      esac
    fi
  fi
fi

# --- README ------------------------------------------------------------------

readme="$PLUGIN/README.md"
if [ ! -f "$readme" ]; then
  err "$readme is missing; the directory blocks a submission without one"
else
  # Words outside fenced code blocks, which the directory does not count.
  words=$(awk '/^```/ { infence = !infence; next } !infence { print }' "$readme" | wc -w | tr -d ' ')
  if [ "$words" -lt 40 ]; then
    err "$readme has $words words outside code blocks; the directory requires at least 40"
  fi
  for dir in skills/*/; do
    skill=$(basename "$dir")
    if ! grep -qF "\`$skill\`" "$readme"; then
      err "$readme does not mention \`$skill\`; add it to the skills list"
    fi
  done
fi

if [ "$fail" -ne 0 ]; then
  echo "$PLUGIN/ is not ready for the plugin directory. For drift, run ./sync-claude-plugin.sh and commit; for the rest, see the errors above." >&2
  exit 1
fi

echo "OK: $PLUGIN/ matches its sources ($total files) and passes the local directory checks."
