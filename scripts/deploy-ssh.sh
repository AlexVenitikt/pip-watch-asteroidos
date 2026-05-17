#!/bin/sh
set -eu

WATCH_IP="${1:?usage: ./scripts/deploy-ssh.sh <watch-ip>}"
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
TARGET="/usr/share/asteroid-launcher"

echo "Syncing watchface layout..."
"$ROOT/scripts/sync-watchface-layout.sh"

echo "Deploying to ${WATCH_IP}..."
scp "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/catfish-pipboy.qml" root@"$WATCH_IP":"$TARGET/watchfaces/"
scp -r "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/logic" root@"$WATCH_IP":"$TARGET/watchfaces/"
scp -r "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/ui" root@"$WATCH_IP":"$TARGET/watchfaces/"
scp -r "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces/settings" root@"$WATCH_IP":"$TARGET/watchfaces/"
scp "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchfaces-preview/480x480/catfish-pipboy.svg" root@"$WATCH_IP":"$TARGET/watchfaces-preview/480x480/"
scp "$ROOT/catfish-pipboy/usr/share/asteroid-launcher/watchface-img/catfish-pipboy.svg" root@"$WATCH_IP":"$TARGET/watchface-img/"
ssh root@"$WATCH_IP" "systemctl restart user@1000.service"

echo "Done."
