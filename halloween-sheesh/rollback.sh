#!/usr/bin/env bash
# Halloween-Look wieder ausschalten (nach Halloween oder wenn etwas nicht passt).
# Holt den aktuellen Live-Header, nimmt die 3 Haken raus und entfernt die Section aus dem Header.
# Die Datei halloween-komplett.liquid bleibt im Theme liegen, ist dann aber nirgends eingebunden.
set -euo pipefail

STORE="holdoch.myshopify.com"
THEME="194227470673"
DIR="$(cd "$(dirname "$0")" && pwd)"
WORK="$DIR/work"
STAMP="$(date +%Y%m%d-%H%M%S)"

rm -rf "$WORK" && mkdir -p "$WORK/sections" "$DIR/backup"
shopify theme pull --store "$STORE" --theme "$THEME" --path "$WORK" --only sections/header-group.json
cp "$WORK/sections/header-group.json" "$DIR/backup/header-group.before-rollback.$STAMP.json"
python3 "$DIR/patch_header_group.py" "$WORK/sections/header-group.json" --undo
shopify theme push --store "$STORE" --theme "$THEME" --path "$WORK" --allow-live --nodelete \
  --only sections/header-group.json
echo "Halloween-Look ist aus."
