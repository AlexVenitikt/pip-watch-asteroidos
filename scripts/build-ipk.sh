#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist"
PKG="asteroid-watchface-catfish-pipboy_0.1.0_all.ipk"
WORK="$OUT/ipk-work"

rm -rf "$WORK"
mkdir -p "$WORK/CONTROL" "$OUT"

"$ROOT/scripts/sync-watchface-layout.sh"
cp "$ROOT/packaging/control" "$WORK/CONTROL/control"
cp -R "$ROOT/catfish-pipboy/usr" "$WORK/"

(cd "$WORK/CONTROL" && tar --owner=0 --group=0 -czf "$WORK/control.tar.gz" control)
(cd "$WORK" && tar --owner=0 --group=0 -czf "$WORK/data.tar.gz" usr)
echo "2.0" > "$WORK/debian-binary"
(cd "$WORK" && ar r "$OUT/$PKG" debian-binary control.tar.gz data.tar.gz >/dev/null 2>&1)

echo "Built $OUT/$PKG"
