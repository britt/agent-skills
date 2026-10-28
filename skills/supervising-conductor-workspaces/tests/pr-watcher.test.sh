#!/usr/bin/env bash
# pr-watcher.test.sh — drive scripts/pr-watcher.sh against stubbed `gh` and `conductor`.
#
# The stubs serve canned JSON from a fixture directory and log every side effect
# (message create, workspace archive) to calls.log, so the watcher's output and
# actions can be checked without touching a real repo or real workspaces.
#
# Usage: tests/pr-watcher.test.sh        (needs bash and jq; exits non-zero on any failure)
# shellcheck disable=SC2319  # `cond; check $? …` deliberately passes the status of a [ ] test
set -u

HERE=$(cd "$(dirname "$0")" && pwd)
WATCHER="$HERE/../scripts/pr-watcher.sh"
ROOT=$(mktemp -d)
trap 'rm -rf "$ROOT"' EXIT

STUBS="$ROOT/bin"
mkdir -p "$STUBS"
# An exported shell function named gh or conductor would shadow the stubs on PATH.
unset -f gh conductor 2>/dev/null

cat >"$STUBS/gh" <<'EOF'
#!/usr/bin/env bash
# gh stub: api repos/<r>/commits/<b>, pr list --state open|merged
case "$1 $2" in
  "api "*)
    [ -e "$FIX/base_fail" ] && exit 1
    cat "$FIX/base_sha" ;;
  "pr list")
    state=open
    for a in "$@"; do case "$prev" in --state) state=$a ;; esac; prev=$a; done
    [ -e "$FIX/${state}_fail" ] && exit 1
    cat "$FIX/$state.json" ;;
  *) echo "gh stub: unexpected: $*" >&2; exit 2 ;;
esac
EOF

cat >"$STUBS/conductor" <<'EOF'
#!/usr/bin/env bash
# conductor stub: workspace list|session|archive, message create
case "$1 $2" in
  "workspace list") cat "$FIX/ws.json" ;;
  "workspace session") printf '{"data":[{"id":"sess-%s"}]}\n' "$3" ;;
  "workspace archive") echo "archive $3" >>"$FIX/calls.log" ;;
  "message create") echo "message $4" >>"$FIX/calls.log" ;;
  *) echo "conductor stub: unexpected: $*" >&2; exit 2 ;;
esac
EOF
chmod +x "$STUBS/gh" "$STUBS/conductor"

pass=0; fail=0
# check STATUS NAME [DETAIL]: pass if STATUS is 0, else fail and print DETAIL.
# Call as `cond; check $? ...` — $? must be expanded before DETAIL's command substitutions run.
check() {
  if [ "$1" = 0 ]; then pass=$((pass + 1)); echo "ok   - $2"
  else fail=$((fail + 1)); echo "FAIL - $2"; [ -z "${3:-}" ] || printf '%s\n' "$3" | while IFS= read -r l; do echo "       | $l"; done
  fi
}

# Fresh fixture directory; sets FIX, STATE and an empty calls.log.
new_fixture() {
  FIX="$ROOT/fix-$1"; STATE="$FIX/state"
  mkdir -p "$FIX"; : >"$FIX/calls.log"
  echo "aaaaaaaa1111" >"$FIX/base_sha"
  echo '[]' >"$FIX/open.json"; echo '[]' >"$FIX/merged.json"; echo '{"data":[]}' >"$FIX/ws.json"
  export FIX
}

# One watcher pass. Extra env goes in front: run DRY_RUN=1
run() {
  env PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 STATE="$STATE" "$@" \
    timeout 10 "$WATCHER" 2>/dev/null
}

open_pr() { # number branch head mergeState title
  jq -n --argjson n "$1" --arg b "$2" --arg h "$3" --arg s "$4" --arg t "$5" \
    '{number:$n, headRefName:$b, headRefOid:$h, mergeStateStatus:$s, title:$t}'
}
merged_pr() { # number branch title mergedAt
  jq -n --argjson n "$1" --arg b "$2" --arg t "$3" --arg m "$4" \
    '{number:$n, headRefName:$b, title:$t, mergedAt:$m}'
}
workspace() { # id name createdAt
  jq -n --arg i "$1" --arg n "$2" --arg c "$3" '{id:$i, name:$n, state:"ready", createdAt:$c}'
}
set_open()   { jq -s . >"$FIX/open.json"; }
set_merged() { jq -s . >"$FIX/merged.json"; }
set_ws()     { jq -s '{data:.}' >"$FIX/ws.json"; }
calls()      { cat "$FIX/calls.log"; }
lines()      { if [ -z "$1" ]; then echo 0; else wc -l <<<"$1" | tr -d ' '; fi; }

# --- one line per new event, never repeated ---------------------------------
new_fixture events
{ open_pr 1 issue-11-add-thing aaaa0001 BEHIND "Add thing"
  open_pr 2 issue-12-other    bbbb0002 DIRTY  "Other (#12)"
  open_pr 3 issue-13-ci       cccc0003 BLOCKED "CI (#13)"
  open_pr 4 issue-14-green    dddd0004 CLEAN  "Green (#14)"
  open_pr 5 issue-15-unknown  eeee0005 UNKNOWN "Unknown (#15)"; } | set_open
workspace w11 "Issue 11" 2026-10-01T00:00:00Z | set_ws

out=$(run)
[ "$(lines "$out")" = 3 ]; check $? "first pass prints one line per actionable PR" "$out"
grep -q "^BEHIND pr=1 branch=issue-11-add-thing -> messaged workspace '11' session sess-w11$" <<<"$out"; check $? "BEHIND messages the owning workspace" "$out"
grep -q "^CONFLICT pr=2 " <<<"$out"; check $? "DIRTY is reported as CONFLICT" "$out"
grep -q "^CI_FAILED_OR_BLOCKED pr=3 .*state=BLOCKED$" <<<"$out"; check $? "BLOCKED is reported as CI_FAILED_OR_BLOCKED" "$out"
[ "$(calls)" = "message sess-w11" ]; check $? "exactly one message sent" "$(calls)"

out=$(run)
[ -z "$out" ]; check $? "second pass over unchanged PRs prints nothing" "$out"
[ "$(lines "$(calls)")" = 1 ]; check $? "second pass sends no message" "$(calls)"

{ open_pr 1 issue-11-add-thing aaaa9999 BEHIND "Add thing"
  open_pr 2 issue-12-other    bbbb0002 DIRTY  "Other (#12)"; } | set_open
out=$(run)
[ "$(lines "$out")" = 1 ] && grep -q "^BEHIND pr=1 " <<<"$out"; check $? "a new head sha on the same PR is reported again" "$out"

echo "bbbbbbbb2222" >"$FIX/base_sha"
out=$(run)
grep -q "^CONFLICT pr=2 .*main=bbbbbbbb" <<<"$out"; check $? "a new base sha re-reports a still-conflicting PR" "$out"

# --- BEHIND with no owner ----------------------------------------------------
new_fixture ownerless
open_pr 7 dependabot/npm/foo-1.2 ffff0007 BEHIND "Bump foo" | set_open
out=$(run)
grep -q "^BEHIND pr=7 .*no owning workspace found" <<<"$out" && [ -z "$(calls)" ]; check $? "ownerless BEHIND is reported, not messaged" "$out"

# --- archiving ----------------------------------------------------------------
new_fixture archive
workspace w20 "Issue 20" 2026-10-10T12:00:00.500Z | set_ws
merged_pr 30 issue-20-fix "Fix (#20)" 2026-10-10T12:00:00Z | set_merged
out=$(run)
[ -z "$(calls)" ]; check $? "a PR merged before the workspace was created does not archive it" "$(calls)"

merged_pr 30 issue-20-fix "Fix (#20)" 2026-10-11T09:00:00Z | set_merged
out=$(run)
[ "$(calls)" = "archive w20" ] && [ "$out" = "MERGED pr=30 -> archived workspace 'Issue 20'" ]; check $? "a PR merged after the workspace was created archives it" "$out"$'\n'"$(calls)"
out=$(run)
[ -z "$out" ] && [ "$(lines "$(calls)")" = 1 ]; check $? "an archived workspace is not archived or reported twice" "$out"

new_fixture stacked
workspace w21 "Issue 21" 2026-10-10T00:00:00Z | set_ws
merged_pr 31 issue-21-part-1 "Part 1/2 (#21)" 2026-10-11T00:00:00Z | set_merged
open_pr 32 issue-21-part-2 abcd0032 CLEAN "Part 2/2 (#21)" | set_open
out=$(run)
[ -z "$(calls)" ]; check $? "an open PR still mentioning the issue blocks archiving" "$(calls)"
echo '[]' >"$FIX/open.json"
out=$(run)
[ "$(calls)" = "archive w21" ]; check $? "the stack's last merge archives it" "$(calls)"

new_fixture mention
workspace w22 "Issue 22" 2026-10-10T00:00:00Z | set_ws
merged_pr 33 diagnose-stuff "Diagnose #22 and write it up" 2026-10-11T00:00:00Z | set_merged
run >/dev/null
[ -z "$(calls)" ]; check $? "a merged PR that merely mentions #N does not archive" "$(calls)"

new_fixture openfail
workspace w23 "Issue 23" 2026-10-10T00:00:00Z | set_ws
merged_pr 34 issue-23-fix "Fix (#23)" 2026-10-11T00:00:00Z | set_merged
touch "$FIX/open_fail"
run >/dev/null
[ -z "$(calls)" ]; check $? "a failed open-PR lookup never archives" "$(calls)"

new_fixture noarchive
workspace w24 "Issue 24" 2026-10-10T00:00:00Z | set_ws
merged_pr 35 issue-24-fix "Fix (#24)" 2026-10-11T00:00:00Z | set_merged
run AUTO_ARCHIVE=0 >/dev/null
[ -z "$(calls)" ]; check $? "AUTO_ARCHIVE=0 never archives" "$(calls)"

# --- DRY_RUN -------------------------------------------------------------------
new_fixture dryrun
open_pr 1 issue-11-add-thing aaaa0001 BEHIND "Add thing" | set_open
{ workspace w11 "Issue 11" 2026-10-01T00:00:00Z
  workspace w25 "Issue 25" 2026-10-01T00:00:00Z; } | set_ws
merged_pr 36 issue-25-fix "Fix (#25)" 2026-10-11T00:00:00Z | set_merged
# Default STATE (under TMPDIR), as a user would run it.
dry() { env PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 TMPDIR="$FIX" DRY_RUN=1 timeout 10 "$WATCHER" 2>/dev/null; }
out=$(dry)
[ -z "$(calls)" ]; check $? "DRY_RUN=1 sends no message and archives nothing" "$(calls)"
grep -q "^BEHIND pr=1 .*(dry run) would message" <<<"$out" && grep -q "^MERGED pr=36 -> (dry run) would archive workspace 'Issue 25'$" <<<"$out"; check $? "DRY_RUN=1 reports what it would do" "$out"
out=$(dry)
[ -z "$out" ]; check $? "a second dry run repeats nothing" "$out"
out=$(env PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 TMPDIR="$FIX" timeout 10 "$WATCHER" 2>/dev/null)
grep -q "^BEHIND pr=1 .*messaged workspace" <<<"$out" && grep -q "^archive w25$" "$FIX/calls.log"; check $? "a dry run does not suppress the next real run" "$out"$'\n'"$(calls)"

# --- failures -----------------------------------------------------------------
new_fixture basefail
touch "$FIX/base_fail"
run >/dev/null; rc=$?
[ "$rc" != 0 ] && [ "$rc" != 124 ]; check $? "ONCE=1 exits non-zero when the base branch can't be read" "exit $rc (124 = hung until timeout)"

echo
echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
