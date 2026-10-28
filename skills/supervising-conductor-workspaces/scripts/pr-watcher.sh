#!/usr/bin/env bash
# pr-watcher.sh — poll a repo's open PRs and the Conductor workspaces that own them.
#
# Prints ONE stdout line per NEW event (so it can feed the Monitor tool):
#   BEHIND pr=N branch=B -> messaged workspace 'W' session S   (owner told to merge the base branch)
#   BEHIND pr=N branch=B -> no owning workspace found; ...      (nobody to tell: supervisor decides)
#   CONFLICT pr=N branch=B head=H main=M -> needs conflict resolution
#   CI_FAILED_OR_BLOCKED pr=N branch=B state=S                  (BLOCKED/UNSTABLE: pending OR failing; inspect)
#   MERGED pr=N -> archived workspace 'W'
# Each (PR, head sha, base sha, state) is reported once; state lives in $STATE.
#
# Env: REPO (owner/name, default: current gh repo)   WS_PREFIX (default "Issue ")
#      INTERVAL (seconds, 300)   ONCE=1 (single pass)   DRY_RUN=1 (never message/archive)
#      AUTO_ARCHIVE=0 (never archive)   STATE (dir for dedupe markers)   BASE (default branch)
set -u
REPO=${REPO:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}
REPO_NAME=${REPO#*/}
WS_PREFIX=${WS_PREFIX:-"Issue "}
INTERVAL=${INTERVAL:-300}
ONCE=${ONCE:-0}; DRY_RUN=${DRY_RUN:-0}; AUTO_ARCHIVE=${AUTO_ARCHIVE:-1}
# A dry run keeps its own markers: sharing them would hide every event it saw from the next real run.
STATE=${STATE:-${TMPDIR:-/tmp}/pr-watcher-$REPO_NAME$([ "$DRY_RUN" = 1 ] && echo -dry-run)}
BASE=${BASE:-$(gh repo view "$REPO" --json defaultBranchRef --jq .defaultBranchRef.name)}
mkdir -p "$STATE"

# A pass that can't read GitHub is skipped, never guessed through. With ONCE=1 it is an error.
skip_pass() {
  echo "pr-watcher: $1; skipping this pass" >&2
  [ "$ONCE" = 1 ] && exit 1
  sleep 60
}

# jq filter: the PR implements issue $n — branch "issue-N…"/"…/N-…" or title "(#N)" / "(#N, …)".
# shellcheck disable=SC2016  # $n is a jq variable, not a shell one
MENTIONS='(.headRefName|test("(issue-|/)"+$n+"([^0-9]|$)")) or (.title|test("\\(#"+$n+"[,)]"))'

while true; do
  base_sha=$(gh api "repos/$REPO/commits/$BASE" --jq .sha 2>/dev/null) || { skip_pass "can't read $BASE"; continue; }
  # NB: `conductor workspace list` returns only 5 rows by default — always pass --limit.
  ws_json=$(conductor workspace list --repo "$REPO_NAME" --limit 100 --json 2>/dev/null || echo '{}')
  gh pr list --repo "$REPO" --state open --limit 100 \
    --json number,headRefName,headRefOid,title,mergeStateStatus >"$STATE/open.json" 2>/dev/null \
    || { skip_pass "can't list open PRs"; continue; }

  jq -c '.[]' "$STATE/open.json" | while read -r pr; do
    n=$(jq -r .number <<<"$pr"); br=$(jq -r .headRefName <<<"$pr"); head=$(jq -r .headRefOid <<<"$pr")
    ms=$(jq -r .mergeStateStatus <<<"$pr"); title=$(jq -r .title <<<"$pr")
    [ "$ms" = "UNKNOWN" ] && continue            # GitHub still computing; next tick
    key="$STATE/$n-${head:0:8}-${base_sha:0:8}-$ms"
    [ -e "$key" ] && continue
    case "$ms" in
      BEHIND)
        # Owner = workspace named "<prefix>N", N taken from branch (issue-N or /N-) or title ("#N").
        num=$(grep -oE '(issue-|/)[0-9]+([^0-9]|$)' <<<"$br" | head -1 | grep -oE '[0-9]+')
        [ -z "$num" ] && num=$(grep -oE '#[0-9]+' <<<"$title" | tail -1 | tr -d '#')
        wsid=""; [ -n "$num" ] && wsid=$(jq -r --arg name "$WS_PREFIX$num" '.data[]? | select(.name==$name) | .id' <<<"$ws_json" | head -1)
        sess=""; [ -n "$wsid" ] && sess=$(conductor workspace session "$wsid" --json 2>/dev/null | jq -r '.data[0].id // empty')
        if [ -n "$sess" ]; then
          if [ "$DRY_RUN" = 1 ]; then echo "BEHIND pr=$n branch=$br -> (dry run) would message workspace '$num' session $sess"
          elif conductor message create --session "$sess" --message "PR #$n ($br) is behind $BASE (now ${base_sha:0:8}). Please run: git fetch origin && git merge origin/$BASE, resolve any conflicts, re-run tests/lint/build, and push. Sent automatically by the PR watcher." >/dev/null 2>&1; then
            echo "BEHIND pr=$n branch=$br -> messaged workspace '$num' session $sess"
          else
            echo "BEHIND pr=$n branch=$br -> FAILED to message session $sess"
          fi
        else
          echo "BEHIND pr=$n branch=$br -> no owning workspace found; supervisor decides whether to merge $BASE itself"
        fi ;;
      DIRTY) echo "CONFLICT pr=$n branch=$br head=${head:0:8} main=${base_sha:0:8} -> needs conflict resolution" ;;
      BLOCKED|UNSTABLE) echo "CI_FAILED_OR_BLOCKED pr=$n branch=$br state=$ms" ;;
      *) : ;;   # CLEAN/HAS_HOOKS: the supervisor learns of green PRs by polling, not from this stream
    esac
    touch "$key"
  done

  # Archive "<prefix>N" workspaces whose PR merged AFTER the workspace was created
  # (the time guard stops older PRs that merely mention #N from matching).
  if [ "$AUTO_ARCHIVE" = 1 ]; then
    gh pr list --repo "$REPO" --state merged --limit 60 --json number,headRefName,title,mergedAt 2>/dev/null > "$STATE/merged.json" || echo '[]' > "$STATE/merged.json"
    # "sleeping" workspaces are idle, not gone — only skip ones still initializing.
    jq -c --arg p "$WS_PREFIX" '.data[]? | select(.state!="initializing" and .state!="archived") | select(.name|test("^"+$p+"[0-9]+$"))' <<<"$ws_json" | while read -r w; do
      wname=$(jq -r .name <<<"$w"); wid=$(jq -r .id <<<"$w"); wcreated=$(jq -r .createdAt <<<"$w"); num=${wname#"$WS_PREFIX"}
      [ -e "$STATE/archived-$wid" ] && continue
      # Compare as epoch seconds: gh's mergedAt has no fraction, conductor's createdAt does.
      hit=$(jq -r --arg n "$num" --arg c "$wcreated" '
        def epoch: sub("\\.[0-9]+"; "") | fromdateiso8601;
        .[] | select((.mergedAt|epoch) > ($c|epoch)) | select('"$MENTIONS"') | .number' "$STATE/merged.json" | head -1)
      [ -z "$hit" ] && continue
      # A stacked series ("1/3", "2/3", ...) is only done when no open PR still mentions the issue.
      still=$(jq --arg n "$num" '[.[] | select('"$MENTIONS"')] | length' "$STATE/open.json")
      [ "$still" != 0 ] && continue
      if [ "$DRY_RUN" = 1 ]; then echo "MERGED pr=$hit -> (dry run) would archive workspace '$wname'"
      elif conductor workspace archive "$wid" >/dev/null 2>&1; then echo "MERGED pr=$hit -> archived workspace '$wname'"
      else echo "MERGED pr=$hit -> FAILED to archive '$wname' ($wid)"
      fi
      touch "$STATE/archived-$wid"
    done
  fi

  [ "$ONCE" = 1 ] && exit 0
  sleep "$INTERVAL"
done
