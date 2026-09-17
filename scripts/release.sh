#!/usr/bin/env bash
# Release private main to the public mirror (ethsystems/specs).
# Usage: scripts/release.sh [sha]
#   no argument     embargo default: newest commit older than 7 days
#   origin/main     release everything on main
# Arms SYNC_ENABLED, dispatches the Release workflow, waits for it,
# and always disarms again, even on failure.
set -euo pipefail
repo=ethsystems/specs-private
sha="${1:-}"

gh variable set SYNC_ENABLED --body true -R "$repo"
trap 'gh variable set SYNC_ENABLED --body false -R "$repo"' EXIT

if [ -n "$sha" ]; then
  gh workflow run release.yml -R "$repo" -f "sha=$sha"
else
  gh workflow run release.yml -R "$repo"
fi

sleep 5
run_id=$(gh run list -R "$repo" --workflow release.yml --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$run_id" -R "$repo" --exit-status

echo
echo "Release run passed. Public deploy (takes ~1 min):"
gh run list -R ethsystems/specs --limit 1
echo "Site: https://specs.ethsystems.org"
