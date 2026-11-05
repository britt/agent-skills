#!/bin/bash
# Serve the Hugo site at site/ with live reload.
# Hugo falls back to a free port automatically when 1313 is taken, so parallel
# workspaces can each run this without colliding.
set -euo pipefail

cd "$(dirname "$0")/../site"

exec hugo server --buildDrafts --disableFastRender
