#!/bin/sh
set -eu

WATCH_IP="${1:?usage: ./scripts/install-watchface.sh <watch-ip> [ipk-file]}"
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

if [ "${2:-}" ]; then
    IPK="$2"
else
    "$ROOT/scripts/build-ipk.sh"
    IPK="$(find "$ROOT/dist" -maxdepth 1 -name 'asteroid-watchface-catfish-pipboy_*.ipk' | sort | tail -n 1)"
fi

if [ ! -f "$IPK" ]; then
    echo "IPK not found: $IPK" >&2
    exit 1
fi

REMOTE_IPK="/tmp/$(basename "$IPK")"
WATCHFACE_URI="file:///usr/share/asteroid-launcher/watchfaces/catfish-pipboy.qml"

echo "Copying $(basename "$IPK") to $WATCH_IP..."
scp "$IPK" root@"$WATCH_IP":"$REMOTE_IPK"

echo "Installing package on watch..."
ssh root@"$WATCH_IP" "opkg install --force-reinstall '$REMOTE_IPK' && rm -f '$REMOTE_IPK'"

echo "Selecting watchface when the ceres user is reachable..."
ssh ceres@"$WATCH_IP" "dconf write /desktop/asteroid/watchface \"'$WATCHFACE_URI'\"" || true

echo "Installed Catfish Pip-Boy watchface."
