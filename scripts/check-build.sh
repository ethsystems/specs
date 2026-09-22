#!/usr/bin/env bash
# Assert that build/ holds exactly the files the source tree says it should,
# then print that verified list, one path per line, on stdout.
#
# The publishable set is derived, never hardcoded, so adding a specification
# needs no edit here. Two independent rules produce it:
#
#   1. specs/<N>/ exists, where N is a number, and
#   2. the index table in README.md has a row for N.
#
# Adding that row is the act that publishes a specification. The two rules
# cross-check each other, and both are checked against what render.sh wrote.
#
# Usage: scripts/check-build.sh [root]    (default: the repository root)
set -euo pipefail

root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
build="$root/build"

err() {
  if [ -n "${GITHUB_ACTIONS:-}" ]; then
    echo "::error::$*"
  else
    echo "error: $*"
  fi >&2
}

if [ ! -d "$build" ]; then
  err "no build/ directory at $root. Run scripts/render.sh first."
  exit 1
fi

expected="$(mktemp)"
rendered="$(mktemp)"
trap 'rm -f "$expected" "$rendered"' EXIT

# Pages that are not per-specification. render.sh hardcodes these too.
printf '%s\n' \
  COPYING LICENSE index.html \
  contributing.html contributing/index.html \
  template.html template/index.html >> "$expected"

# Specification numbers listed in the README.md index table.
indexed="$(grep -oE '^\| *[0-9]+ *\|' "$root/README.md" | tr -cd '0-9\n' || true)"

for dir in "$root"/specs/*/; do
  n="$(basename "$dir")"
  # Unnumbered directories, such as specs/raw/, hold drafts. They never publish.
  [[ "$n" =~ ^[0-9]+$ ]] || continue
  if [ ! -f "$dir/README.md" ]; then
    err "specs/$n has no README.md, so render.sh skips it."
    err "Add the file, or remove the directory."
    exit 1
  fi
  if ! grep -qx "$n" <<<"$indexed"; then
    err "specs/$n exists, but the README.md index table has no row for it."
    err "Add the row. That row is what publishes a specification."
    exit 1
  fi
  printf '%s\n' "$n.html" "$n/index.html" >> "$expected"
  # Assets render.sh copies alongside a specification.
  find "$dir" -maxdepth 1 -type f \
    \( -name '*.png' -o -name '*.svg' -o -name 'COPYING' \) \
    -printf "$n/%f\n" >> "$expected"
done

while read -r n; do
  [ -n "$n" ] || continue
  if [ ! -d "$root/specs/$n" ]; then
    err "the README.md index table lists specification $n, but specs/$n does not exist."
    exit 1
  fi
done <<<"$indexed"

# Only regular files may be published. A symlink in build/ could point the
# published artifact at anything on the machine that rendered it.
odd="$(cd "$build" && find . -mindepth 1 ! -type d ! -type f | sed 's#^\./##')"
if [ -n "$odd" ]; then
  err "build/ holds files that are neither directories nor regular files:"
  printf '%s\n' "$odd" >&2
  exit 1
fi

LC_ALL=C sort -u -o "$expected" "$expected"
(cd "$build" && find . -type f | sed 's#^\./##' | LC_ALL=C sort) > "$rendered"

if ! diff -u --label 'expected (from specs/N/ and the README.md index)' \
             --label 'rendered (build/)' "$expected" "$rendered" >&2; then
  err "build/ does not match the set derived from the source tree."
  err "A '-' line is expected but was not rendered: check scripts/render.sh."
  err "A '+' line was rendered but is not expected: check specs/N/, or the rules in this script."
  exit 1
fi

cat "$expected"
