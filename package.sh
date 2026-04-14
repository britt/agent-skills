#!/bin/bash
set -euo pipefail

# Parse flags
if [ "${1:-}" = "--clean" ]; then
  echo "Cleaning dist/ directory..."
  rm -rf dist
fi

# Create dist directory if it doesn't exist
mkdir -p dist

# Go through each directory in skills/
for dir in skills/*/; do
  # Get the directory name (remove trailing slash and skills/ prefix)
  dirname=$(basename "$dir")

  # Skip if no matching directories found (glob didn't expand)
  if [ "$dirname" = "*" ]; then
    echo "Error: No skill directories found in skills/" >&2
    exit 1
  fi

  # Create zip file in dist/ directory
  zip -r "dist/${dirname}.zip" "$dir"

  echo "Created dist/${dirname}.zip"
done

echo "Done! All archives created in dist/"

