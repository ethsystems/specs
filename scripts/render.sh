#!/usr/bin/env bash
# Render the specs to static HTML in build/. Requires pandoc.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=build
TPL=scripts/spec-template.html
mkdir -p "$OUT"
cp LICENSE "$OUT/"
cp specs/1/COPYING "$OUT/"

pd() { pandoc -f gfm+yaml_metadata_block -t html5 --standalone --template "$TPL" "$@"; }

sed -E \
  -e 's#\./specs/([0-9]+)#\1.html#g' \
  -e 's#\./CONTRIBUTING\.md#contributing.html#g' \
  -e 's#\./template/README\.md#template.html#g' \
  README.md | awk '
    /^## (Build|Release|Planned|Related|License)[[:space:]]*$/ { skipping = 1; next }
    /^## / && skipping { skipping = 0 }
    !skipping { print }
  ' | pd --metadata title="EthSystems Specifications" -o "$OUT/index.html"

sed -E \
  -e 's#\./specs/([0-9]+)#\1.html#g' \
  -e 's#\./template/README\.md#template.html#g' \
  CONTRIBUTING.md | pd --metadata title="Contributing" -o "$OUT/contributing.html"

sed -E \
  -e 's#\.\./([0-9]+)#\1.html#g' \
  -e 's#\.\./\.\./LICENSE#LICENSE#g' \
  template/README.md | pd --metadata title="Specification template" --metadata shortname= -o "$OUT/template.html"

for d in specs/*/; do
  n=$(basename "$d")
  [ -f "$d/README.md" ] || continue
  sed -E \
    -e 's#\(\.\./([0-9]+)\)#(\1.html)#g' \
    -e 's#\.\./\.\./template/README\.md#template.html#g' \
    -e 's#\.\./\.\./LICENSE#LICENSE#g' \
    "$d/README.md" | pd -o "$OUT/$n.html"
  for img in "$d"*.png "$d"*.svg; do
    [ -f "$img" ] && cp "$img" "$OUT/"
  done
done

echo "rendered to $OUT/"
