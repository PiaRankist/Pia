#!/usr/bin/env bash
# Halloween-Look für Sheesh live einbauen. Fasst im Live-Theme nur zwei Dateien an:
#   sections/halloween-komplett.liquid (neu) und sections/header-group.json (3 Haken + neue Section).
# Übersetzungen, Templates und alles andere bleiben unberührt.
set -euo pipefail

STORE="holdoch.myshopify.com"
THEME="194227470673"   # Live-Theme "Impact"
DIR="$(cd "$(dirname "$0")" && pwd)"
WORK="$DIR/work"
STAMP="$(date +%Y%m%d-%H%M%S)"

command -v shopify >/dev/null || { echo "Shopify CLI fehlt: npm install -g @shopify/cli"; exit 1; }

rm -rf "$WORK" && mkdir -p "$WORK/sections" "$DIR/backup"

echo "1/4 Live-Header holen ..."
shopify theme pull --store "$STORE" --theme "$THEME" --path "$WORK" --only sections/header-group.json
cp "$WORK/sections/header-group.json" "$DIR/backup/header-group.$STAMP.json"
echo "    Sicherung: backup/header-group.$STAMP.json"

echo "2/4 Header anpassen ..."
python3 "$DIR/patch_header_group.py" "$WORK/sections/header-group.json"
diff -u "$DIR/backup/header-group.$STAMP.json" "$WORK/sections/header-group.json" || true

echo "3/4 Neue Section hochladen ..."
cp "$DIR/sections/halloween-komplett.liquid" "$WORK/sections/"
shopify theme push --store "$STORE" --theme "$THEME" --path "$WORK" --allow-live --nodelete \
  --only sections/halloween-komplett.liquid

echo "4/4 Header hochladen ..."
shopify theme push --store "$STORE" --theme "$THEME" --path "$WORK" --allow-live --nodelete \
  --only sections/header-group.json

echo "Fertig. Prüfen: https://sheesh.de  |  Rückbau: ./rollback.sh"
