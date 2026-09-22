#!/usr/bin/env bash
# Render the specs to static HTML in build/. Requires pandoc.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=build
TPL=scripts/spec-template.html
mkdir -p "$OUT"
cp LICENSE "$OUT/"
cp specs/1/COPYING "$OUT/"

pd() { pandoc -f gfm+yaml_metadata_block -t html5 --standalone --wrap=none --template "$TPL" "$@"; }

# Meta-refresh stub so an old flat URL still reaches the clean one.
stub() {
  printf '<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta http-equiv="refresh" content="0; url=%s">\n<link rel="canonical" href="https://specs.ethsystems.org%s">\n<title>Moved</title>\n</head>\n<body><p>This page moved to <a href="%s">%s</a>.</p></body>\n</html>\n' \
    "$2" "$2" "$2" "$2" > "$OUT/$1"
}

sed -E \
  -e 's#\./specs/([0-9]+)#/\1/#g' \
  -e 's#\./CONTRIBUTING\.md#/contributing/#g' \
  -e 's#\./template/README\.md#/template/#g' \
  README.md | awk '
    /^## (Build|Release|Planned|Related|License)[[:space:]]*$/ { skipping = 1; next }
    /^## / && skipping { skipping = 0 }
    !skipping { print }
  ' | pd --metadata title="EthSystems Specifications" \
    --metadata description="Specifications for confidential systems for institutions on Ethereum, by EthSystems." \
    --metadata ogpath=/ -o "$OUT/index.html"

mkdir -p "$OUT/contributing"
sed -E \
  -e 's#\./specs/([0-9]+)#/\1/#g' \
  -e 's#\./template/README\.md#/template/#g' \
  -e 's#\./LICENSE#/LICENSE#g' \
  CONTRIBUTING.md | pd --metadata title="Contributing" \
    --metadata description="How to propose, review, and promote an EthSystems specification." \
    --metadata ogpath=/contributing/ -o "$OUT/contributing/index.html"
stub contributing.html /contributing/

mkdir -p "$OUT/template"
sed -E \
  -e 's#\.\./([0-9]+)#/\1/#g' \
  -e 's#\.\./\.\./LICENSE#/LICENSE#g' \
  template/README.md | pd --metadata title="Specification template" --metadata shortname= \
    --metadata description="The template every EthSystems Standards Track specification uses." \
    --metadata ogpath=/template/ --lua-filter scripts/spec-filter.lua -o "$OUT/template/index.html"
stub template.html /template/

for d in specs/*/; do
  n=$(basename "$d")
  [ -f "$d/README.md" ] || continue
  mkdir -p "$OUT/$n"
  # Provenance comes from version control, never from a hand-maintained field.
  # SPECS_GIT points at a checkout with history when the render runs from an
  # exported tree, as it does in CI.
  meta=()
  rev="$(git -C "${SPECS_GIT:-.}" log -1 --format='%cs %H' -- "specs/$n" 2>/dev/null || true)"
  if [ -n "$rev" ]; then
    meta=(--metadata "revised=${rev%% *}"
          --metadata "revurl=https://github.com/${GITHUB_REPOSITORY:-ethsystems/specs}/blob/${rev##* }/specs/$n/README.md")
  fi
  sed -E \
    -e 's#\(\.\./([0-9]+)\)#(/\1/)#g' \
    -e 's#\.\./\.\./template/README\.md#/template/#g' \
    -e 's#\.\./\.\./LICENSE#/LICENSE#g' \
    "$d/README.md" | pd --toc --toc-depth=3 --metadata ogpath="/$n/" ${meta[@]+"${meta[@]}"} --lua-filter scripts/spec-filter.lua -o "$OUT/$n/index.html"
  for f in "$d"*.png "$d"*.svg "$d"COPYING; do
    [ -f "$f" ] && cp "$f" "$OUT/$n/"
  done
  stub "$n.html" "/$n/"
done

echo "rendered to $OUT/"
