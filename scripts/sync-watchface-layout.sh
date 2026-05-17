#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/catfish-pipboy/usr/share/asteroid-launcher"

mkdir -p "$TARGET/watchfaces" "$TARGET/watchfaces-preview/480x480" "$TARGET/watchface-img"
cp "$ROOT/qml/Main.qml" "$TARGET/watchfaces/catfish-pipboy.qml"
rm -rf "$TARGET/watchfaces/logic" "$TARGET/watchfaces/ui" "$TARGET/watchfaces/settings"
rm -rf "$TARGET/watchfaces/assets"
cp -R "$ROOT/qml/logic" "$TARGET/watchfaces/"
cp -R "$ROOT/qml/ui" "$TARGET/watchfaces/"
cp -R "$ROOT/qml/settings" "$TARGET/watchfaces/"
mkdir -p "$TARGET/watchfaces/assets/logos" "$TARGET/watchfaces/assets/map-icons" "$TARGET/watchfaces/assets/other-icons"
cp "$ROOT/Logos/"*.png "$TARGET/watchfaces/assets/logos/"
cp "$ROOT/Map Icons/"*.png "$TARGET/watchfaces/assets/map-icons/"
cp "$ROOT/Other Icons/"*.png "$TARGET/watchfaces/assets/other-icons/"
cp "$ROOT/assets/icons/catfishpipboy_preview.svg" "$TARGET/watchfaces-preview/480x480/catfish-pipboy.svg"
cp "$ROOT/assets/icons/catfishpipboy_preview.svg" "$TARGET/watchface-img/catfish-pipboy.svg"

echo "AsteroidOS watchface layout synced to $TARGET"
