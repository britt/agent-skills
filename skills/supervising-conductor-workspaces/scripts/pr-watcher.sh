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
#      AUTO_ARCHIVE=0 (never archive)   STATE (dir for dedupe markers)
set -u
REPO=${REPO:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}
REPO_NAME=${REPO#*/}
WS_PREFIX=${WS_PREFIX:-"Issue "}
INTERVAL=${INTERVAL:-300}
ONCE=${ONCE:-0}; DRY_RUN=${DRY_RUN:-0}; AUTO_ARCHIVE=${AUTO_ARCHIVE:-1}
STATE=${STATE:-${TMPDIR:-/tmp}/pr-watcher-$REPO_NAME}
BASE=${BASE:-$(gh repo view "$REPO" --json defaultBranchRef --jq .defaultBranchRef.name)}
mkdir -p "$STATE"

while true; do
  base_sha=$(gh api "repos/$REPO/commits/$BASE" --jq .sha 2>/dev/null) || { sleep 60; continue; }
  # NB: `conductor workspace list` returns only 5 rows by default — always pass --limit.
  ws_json=$(conductor workspace list --repo "$REPO_NAME" --limit 100 --json 2>/dev/null || echo '{}')

  gh pr list --repo "$REPO" --state open --json number,headRefName,headRefOid,title,mergeStateStatus \
  | jq -c '.[]' | while read -r pr; do
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
          else
            conductor message create --session "$sess" --message "PR #$n ($br) is behind $BASE (now ${base_sha:0:8}). Please run: git fetch origin && git merge origin/$BASE, resolve any conflicts, re-run tests/lint/build, and push. Sent automatically by the PR watcher." >/dev/null 2>&1 \
              && echo "BEHIND pr=$n branch=$br -> messaged workspace '$num' session $sess" \
              || echo "BEHIND pr=$n branch=$br -> FAILED to message session $sess"
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
      hit=$(jq -r --arg n "$num" --arg c "$wcreated" '.[] | select(.mergedAt > $c) | select((.headRefName|test("(issue-|/)"+$n+"([^0-9]|$)")) or (.title|test("\\(#"+$n+"[,)]"))) | .number' "$STATE/merged.json" | head -1)
      [ -z "$hit" ] && continue
      # A stacked series ("1/3", "2/3", ...) is only done when no open PR still mentions the issue.
      still=$(gh pr list --repo "$REPO" --state open --json headRefName,title 2>/dev/null | jq --arg n "$num" '[.[]|select((.headRefName|test("(issue-|/)"+$n+"([^0-9]|$)")) or (.title|test("\\(#"+$n+"[,)]")))]|length' 2>/dev/null || echo 0)
      [ "${still:-0}" != 0 ] && continue
      if [ "$DRY_RUN" = 1 ]; then echo "MERGED pr=$hit -> (dry run) would archive workspace '$wname'"
      else
        conductor workspace archive "$wid" >/dev/null 2>&1 && echo "MERGED pr=$hit -> archived workspace '$wname'" || echo "MERGED pr=$hit -> FAILED to archive '$wname' ($wid)"
        touch "$STATE/archived-$wid"
      fi
    done
  fi

  [ "$ONCE" = 1 ] && exit 0
  sleep "$INTERVAL"
done
