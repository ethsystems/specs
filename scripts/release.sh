#!/usr/bin/env bash
# Release private main to the public mirror (ethsystems/specs).
# Usage: scripts/release.sh [sha]
#   no argument     embargo default: newest commit older than 7 days
#   origin/main     release everything on main
# Arms SYNC_ENABLED, dispatches the Release workflow, waits for it,
# and always disarms again, even on failure.
set -euo pipefail
repo=ethsystems/specs-private
public=https://github.com/ethsystems/specs.git
sha="${1:-}"

# Report the gap and resolve the target before arming anything. A dispatched
# release that pushes nothing exits 0 and reads as a success, which is how an
# unreleased commit sits unnoticed.
git fetch --no-tags -q origin main
git fetch --no-tags -q "$public" main
public_head="$(git rev-parse FETCH_HEAD)"

echo "public main:  $(git log -1 --format='%h %cs %s' "$public_head")"
pending="$(git rev-list --count "$public_head..origin/main")"
if [ "$pending" -eq 0 ]; then
  echo "Nothing unreleased. The public mirror matches private main."
  exit 0
fi
echo "unreleased on private main ($pending):"
git log --format='  %h %cs %s' "$public_head..origin/main"
echo

target="$(git rev-parse --verify --quiet "${sha:-$(git rev-list -1 --before='7 days ago' origin/main)}^{commit}" || true)"
if [ -z "$target" ]; then
  echo "Nothing on main is older than the 7-day embargo yet."
  echo "To release now: $0 origin/main"
  exit 1
fi
if git merge-base --is-ancestor "$target" "$public_head"; then
  echo "Nothing to release: $(git rev-parse --short "$target") is already public."
  echo "Every unreleased commit above is newer than the 7-day embargo."
  echo "To release now: $0 origin/main"
  exit 1
fi
echo "will release: $(git log -1 --format='%h %cs %s' "$target")"

gh variable set SYNC_ENABLED --body true -R "$repo"
trap 'gh variable set SYNC_ENABLED --body false -R "$repo"' EXIT

# Pass the resolved sha, so the runner cannot reach a different answer.
gh workflow run release.yml -R "$repo" -f "sha=$target"

sleep 5
run_id=$(gh run list -R "$repo" --workflow release.yml --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$run_id" -R "$repo" --exit-status

echo
echo "Release run passed. Public deploy (takes ~1 min):"
gh run list -R ethsystems/specs --limit 1
echo "Site: https://specs.ethsystems.org"
