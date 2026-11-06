#!/bin/bash
#
# Fail if any bundle under bundles/ has drifted from the canonical skills/ and
# assets/ trees, or contains a symlink.
#
# Bundles hold real copies (see sync-bundles.sh for why). This checks that:
#   - no bundle contains a symlink, so nothing can escape its plugin root
#     (Agent Plugins 1.0.0 §4.1.3-4.1.4);
#   - a full-library bundle carries exactly the skills in skills/;
#   - every bundled skill matches skills/<name> file for file, including the
#     executable bit;
#   - every bundle's assets/icon.png matches assets/icon.png.
#
# The fix for any failure is ./sync-bundles.sh, then commit the result.

set -euo pipefail

cd "$(dirname "$0")"

# Keep in step with sync-bundles.sh.
FULL_LIBRARY_BUNDLES=(britts-agent-skills)

ICON="assets/icon.png"

is_full_library() {
  local bundle=$1 b
  for b in "${FULL_LIBRARY_BUNDLES[@]}"; do
    [ "$b" = "$bundle" ] && return 0
  done
  return 1
}

# "<mode> <relative path>" for every file and directory under a tree.
modes() {
  (cd "$1" && find . -printf '%m %p\n' | LC_ALL=C sort)
}

fail=0
err() {
  echo "error: $*" >&2
  fail=1
}

for bundle_dir in bundles/*/; do
  bundle=$(basename "$bundle_dir")
  root="bundles/$bundle"
  skills_dir="$root/skills"

  links=$(find "$root" -type l)
  if [ -n "$links" ]; then
    while IFS= read -r link; do
      err "$link is a symlink; bundles must hold real files"
    done <<< "$links"
    continue
  fi

  if [ ! -d "$skills_dir" ]; then
    err "$skills_dir is missing"
    continue
  fi

  bundled=$(cd "$skills_dir" && find . -mindepth 1 -maxdepth 1 -printf '%f\n' | LC_ALL=C sort)

  if is_full_library "$bundle"; then
    canonical=$(cd skills && find . -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | LC_ALL=C sort)
    if [ "$bundled" != "$canonical" ]; then
      err "$skills_dir does not carry exactly the skills in skills/:"
      comm -23 <(echo "$canonical") <(echo "$bundled") | sed 's/^/  missing: /' >&2
      comm -13 <(echo "$canonical") <(echo "$bundled") | sed 's/^/  extra:   /' >&2
    fi
  fi

  while IFS= read -r name; do
    [ -n "$name" ] || continue
    if [ ! -d "skills/$name" ]; then
      err "$skills_dir/$name has no canonical skills/$name"
      continue
    fi
    if ! diff -r "skills/$name" "$skills_dir/$name" >/dev/null; then
      err "$skills_dir/$name differs from skills/$name"
      diff -rq "skills/$name" "$skills_dir/$name" | sed 's/^/  /' >&2 || true
    elif [ "$(modes "skills/$name")" != "$(modes "$skills_dir/$name")" ]; then
      err "$skills_dir/$name file modes differ from skills/$name"
    fi
  done <<< "$bundled"

  if ! cmp -s "$ICON" "$root/$ICON"; then
    err "$root/$ICON differs from $ICON (or is missing)"
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "Bundle copies have drifted. Run ./sync-bundles.sh and commit the result." >&2
  exit 1
fi

echo "OK: every bundle matches skills/ and assets/, with no symlinks."
