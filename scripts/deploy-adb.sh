#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
TARGET="/usr/share/asteroid-launcher"

"$ROOT/scripts/sync-watchface-layout.sh"

adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/catfish-pipboy.qml" "$TARGET/watchfaces/"
adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/logic" "$TARGET/watchfaces/"
adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/ui" "$TARGET/watchfaces/"
adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/settings" "$TARGET/watchfaces/"
adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces-preview/480x480/catfish-pipboy.svg" "$TARGET/watchfaces-preview/480x480/"
adb push "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchface-img/catfish-pipboy.svg" "$TARGET/watchface-img/"
adb shell "systemctl restart user@1000.service"

echo "ADB deployment complete."
