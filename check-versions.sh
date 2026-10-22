#!/bin/bash
#
# Verify that every bundle's version is in lockstep across the places that
# declare it.
#
# A bundle's version lives in four files:
#   <source>/.claude-plugin/plugin.json
#   <source>/.codex-plugin/plugin.json
#   <source>/.cursor-plugin/plugin.json
#   the bundle's entry in .claude-plugin/marketplace.json
#
# The root agent-skills bundle has a fifth: the top-level "version" in
# .claude-plugin/marketplace.json, which describes the marketplace itself but
# has always tracked the full bundle.
#
# This checks that those agree — not that a bump happened — so it is safe to
# run on every pull request. Bundles version independently of one another;
# only the sources for a single bundle are compared.
#
# A single skill's version lives in its entry in .claude-plugin/marketplace.json
# and, if the skill declares one, in metadata.version in its SKILL.md
# frontmatter, which is how a running agent learns the version. Skills that
# declare no frontmatter version are skipped.
#
# Exits non-zero and names every mismatch if any bundle or skill is out of
# lockstep.

set -euo pipefail

cd "$(dirname "$0")"

MARKETPLACE=".claude-plugin/marketplace.json"

command -v jq >/dev/null || { echo "error: jq is required" >&2; exit 1; }

failed=0

printf '%-22s %-10s %-10s %-10s %-12s %s\n' \
  BUNDLE CLAUDE CODEX CURSOR MARKETPLACE STATUS

while IFS=$'\t' read -r name source; do
  claude=$(jq -r '.version // "MISSING"' "$source/.claude-plugin/plugin.json")
  codex=$(jq -r '.version // "MISSING"' "$source/.codex-plugin/plugin.json")
  cursor=$(jq -r '.version // "MISSING"' "$source/.cursor-plugin/plugin.json")
  entry=$(jq -r --arg n "$name" \
    '(.plugins[] | select(.name == $n) | .version) // "MISSING"' "$MARKETPLACE")

  versions=("$claude" "$codex" "$cursor" "$entry")
  labels=(".claude-plugin/plugin.json" ".codex-plugin/plugin.json" \
          ".cursor-plugin/plugin.json" "$MARKETPLACE ($name entry)")

  # The marketplace's own version tracks the root bundle
  if [ "$source" = "./" ]; then
    top=$(jq -r '.version // "MISSING"' "$MARKETPLACE")
    versions+=("$top")
    labels+=("$MARKETPLACE (top-level)")
  fi

  status=ok
  for v in "${versions[@]}"; do
    if [ "$v" != "${versions[0]}" ] || [ "$v" = "MISSING" ]; then
      status=MISMATCH
      failed=1
    fi
  done

  printf '%-22s %-10s %-10s %-10s %-12s %s\n' \
    "$name" "$claude" "$codex" "$cursor" "$entry" "$status"

  if [ "$status" = MISMATCH ]; then
    for i in "${!versions[@]}"; do
      echo "    ${labels[$i]}: ${versions[$i]}" >&2
    done
  fi
done < <(jq -r '
  .plugins[]
  | select(.source | startswith("./skills/") | not)
  | [.name, .source] | @tsv
' "$MARKETPLACE")

# metadata.version from a SKILL.md's frontmatter, or nothing if it has none
skill_md_version() {
  awk '
    NR == 1 && $0 == "---" { fm = 1; next }
    fm && $0 == "---" { exit }
    fm && /^metadata:/ { meta = 1; next }
    fm && meta && /^[^[:space:]]/ { meta = 0 }
    fm && meta && /^[[:space:]]+version:/ {
      sub(/^[[:space:]]+version:[[:space:]]*/, "")
      gsub(/["'\''[:space:]]/, "")
      print
      exit
    }
  ' "$1"
}

echo
printf '%-30s %-10s %-12s %s\n' SKILL SKILL.MD MARKETPLACE STATUS

while IFS=$'\t' read -r name source version; do
  skill_md="$source/SKILL.md"
  [ -f "$skill_md" ] || continue
  declared=$(skill_md_version "$skill_md")
  [ -n "$declared" ] || continue

  status=ok
  if [ "$declared" != "$version" ]; then
    status=MISMATCH
    failed=1
  fi

  printf '%-30s %-10s %-12s %s\n' "$name" "$declared" "$version" "$status"

  if [ "$status" = MISMATCH ]; then
    echo "    $skill_md (metadata.version): $declared" >&2
    echo "    $MARKETPLACE ($name entry): $version" >&2
  fi
done < <(jq -r '
  .plugins[]
  | select(.source | startswith("./skills/"))
  | [.name, .source, (.version // "MISSING")] | @tsv
' "$MARKETPLACE")

echo
if [ "$failed" -ne 0 ]; then
  echo "error: versions are out of lockstep (see above)" >&2
  echo "Bump every source for a bundle or skill together; see CONTRIBUTING.md." >&2
  exit 1
fi

echo "All bundle and skill versions are in lockstep."
