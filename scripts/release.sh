#!/usr/bin/env bash
# Release private main to the public mirror (ethsystems/specs) now.
#
# The Release workflow already runs daily and pushes anything at least 7 days
# old. This script is for releasing sooner than that. It prints the gap, then
# dispatches the workflow with the resolved sha and waits for it.
#
# Usage: scripts/release.sh [ref]    (default: origin/main, everything)
#
# To pause all releases, including the daily run:
#   gh variable set SYNC_ENABLED --body false -R ethsystems/specs-private
set -euo pipefail
repo=ethsystems/specs-private
public=https://github.com/ethsystems/specs.git
ref="${1:-origin/main}"

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

target="$(git rev-parse --verify "${ref}^{commit}")"
if git merge-base --is-ancestor "$target" "$public_head"; then
  echo "Nothing to release: $(git rev-parse --short "$target") is already public."
  exit 1
fi
if ! git merge-base --is-ancestor "$target" origin/main; then
  echo "Refusing: $(git rev-parse --short "$target") is not on main."
  exit 1
fi
paused="$(gh variable get SYNC_ENABLED -R "$repo" 2>/dev/null || true)"
if [ "$paused" = "false" ]; then
  echo "Releases are paused (SYNC_ENABLED=false). Unpause first:"
  echo "  gh variable set SYNC_ENABLED --body true -R $repo"
  exit 1
fi
echo "will release: $(git log -1 --format='%h %cs %s' "$target")"

# Pass the resolved sha, so the runner cannot reach a different answer.
gh workflow run release.yml -R "$repo" -f "sha=$target"

sleep 5
run_id=$(gh run list -R "$repo" --workflow release.yml --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$run_id" -R "$repo" --exit-status

echo
echo "Release run passed. Public deploy (takes ~1 min):"
gh run list -R ethsystems/specs --limit 1
echo "Site: https://specs.ethsystems.org"
