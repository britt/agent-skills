#!/usr/bin/env bash
# pr-watcher.test.sh — drive scripts/pr-watcher.sh against stubbed `gh` and `paradev`.
#
# The stubs serve canned JSON from a fixture directory and log every side effect
# (terminals send, workspaces archive) to calls.log, so the watcher's output and
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
# An exported shell function named gh or paradev would shadow the stubs on PATH.
unset -f gh paradev 2>/dev/null

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

cat >"$STUBS/paradev" <<'EOF'
#!/usr/bin/env bash
# paradev stub: workspaces list|archive, snapshot, terminals list|send.
# Every call must carry an explicit scope (--local or --host): the watcher must never
# let Paradev fall back to cloud workspaces.
case " $* " in
  *" --local "*|*" --host "*) ;;
  *" snapshot "*) ;;                      # snapshot defaults to this machine; no --local exists
  *) echo "paradev stub: unscoped call: $*" >&2; exit 3 ;;
esac
ws=""; prev=""
for a in "$@"; do case "$prev" in --workspace) ws=$a ;; esac; prev=$a; done
case "$1 $2" in
  "workspaces list")    cat "$FIX/ws.json" ;;
  "workspaces archive") echo "archive $3" >>"$FIX/calls.log" ;;
  "snapshot "*|"snapshot")
    # one pane, one agent, terminal id derived from the workspace id
    jq -n --arg t "term-$ws" '{workspaces:[{layout:{tabs:[{panes:[{terminalId:$t,agent:{id:"claude",state:"idle"}}]}]}}]}' ;;
  "terminals list")     jq -n --arg t "term-$ws" '{sessions:[{terminalId:$t,exited:false}]}' ;;
  "terminals send")     echo "message $ws" >>"$FIX/calls.log" ;;
  *) echo "paradev stub: unexpected: $*" >&2; exit 2 ;;
esac
EOF
chmod +x "$STUBS/gh" "$STUBS/paradev"

# `timeout` is GNU coreutils and absent on stock macOS. Fall back to a bounded wait on a
# known PID (never an unbounded `wait`), so a hung watcher still fails instead of blocking.
tmo() { # tmo <seconds> <command...>
  local secs=$1; shift
  if command -v timeout  >/dev/null 2>&1; then timeout  "$secs" "$@"; return $?; fi
  if command -v gtimeout >/dev/null 2>&1; then gtimeout "$secs" "$@"; return $?; fi
  "$@" &
  local pid=$! n=0
  while kill -0 "$pid" 2>/dev/null && [ "$n" -lt $((secs * 10)) ]; do sleep 0.1; n=$((n + 1)); done
  if kill -0 "$pid" 2>/dev/null; then kill -9 "$pid" 2>/dev/null; wait "$pid" 2>/dev/null; return 124; fi
  wait "$pid"
}

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
  echo '[]' >"$FIX/open.json"; echo '[]' >"$FIX/merged.json"; echo '[]' >"$FIX/ws.json"
  export FIX
}

# One watcher pass. Extra env goes in front: run DRY_RUN=1
run() {
  (
    export PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 STATE="$STATE"
    for kv in "$@"; do export "$kv"; done
    tmo 10 "$WATCHER" 2>/dev/null
  )
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
  jq -n --arg i "$1" --arg n "$2" --arg c "$3" '{id:$i, name:$n, createdAt:$c, archivedAt:null}'
}
set_open()   { jq -s . >"$FIX/open.json"; }
set_merged() { jq -s . >"$FIX/merged.json"; }
set_ws()     { jq -s . >"$FIX/ws.json"; }
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
grep -q "^BEHIND pr=1 branch=issue-11-add-thing -> messaged workspace '11' terminal term-w11$" <<<"$out"; check $? "BEHIND messages the owning workspace's agent terminal" "$out"
grep -q "^CONFLICT pr=2 " <<<"$out"; check $? "DIRTY is reported as CONFLICT" "$out"
grep -q "^CI_FAILED_OR_BLOCKED pr=3 .*state=BLOCKED$" <<<"$out"; check $? "BLOCKED is reported as CI_FAILED_OR_BLOCKED" "$out"
[ "$(calls)" = "message w11" ]; check $? "exactly one message sent" "$(calls)"

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

# --- an archived workspace never owns a PR -----------------------------------
new_fixture archived_owner
open_pr 8 issue-18-thing aaaa0008 BEHIND "Thing (#18)" | set_open
jq -n '{id:"w18", name:"Issue 18", createdAt:"2026-10-01T00:00:00Z", archivedAt:"2026-10-05T00:00:00Z"}' | set_ws
out=$(run)
grep -q "^BEHIND pr=8 .*no owning workspace found" <<<"$out" && [ -z "$(calls)" ]; check $? "an archived workspace is not treated as the owner" "$out"

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
dry() { ( export PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 TMPDIR="$FIX" DRY_RUN=1; tmo 10 "$WATCHER" 2>/dev/null ); }
out=$(dry)
[ -z "$(calls)" ]; check $? "DRY_RUN=1 sends no message and archives nothing" "$(calls)"
grep -q "^BEHIND pr=1 .*(dry run) would message" <<<"$out" && grep -q "^MERGED pr=36 -> (dry run) would archive workspace 'Issue 25'$" <<<"$out"; check $? "DRY_RUN=1 reports what it would do" "$out"
out=$(dry)
[ -z "$out" ]; check $? "a second dry run repeats nothing" "$out"
out=$( export PATH="$STUBS:$PATH" REPO=acme/widgets BASE=main ONCE=1 TMPDIR="$FIX"; tmo 10 "$WATCHER" 2>/dev/null )
grep -q "^BEHIND pr=1 .*messaged workspace" <<<"$out" && grep -q "^archive w25$" "$FIX/calls.log"; check $? "a dry run does not suppress the next real run" "$out"$'\n'"$(calls)"

# --- scope ----------------------------------------------------------------------
new_fixture scope
open_pr 1 issue-11-add-thing aaaa0001 BEHIND "Add thing" | set_open
workspace w11 "Issue 11" 2026-10-01T00:00:00Z | set_ws
out=$(run PD_HOST=mach-7)
grep -q "^BEHIND pr=1 .*messaged workspace" <<<"$out"; check $? "PD_HOST scopes every call to that host" "$out"

# --- failures -----------------------------------------------------------------
new_fixture basefail
touch "$FIX/base_fail"
run >/dev/null; rc=$?
[ "$rc" != 0 ] && [ "$rc" != 124 ]; check $? "ONCE=1 exits non-zero when the base branch can't be read" "exit $rc (124 = hung until timeout)"

echo
echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
