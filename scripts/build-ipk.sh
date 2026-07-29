#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/dist"
PKG_NAME="$(awk -F': ' '/^Package:/ {print $2}' "$ROOT/packaging/control")"
PKG_VERSION="$(awk -F': ' '/^Version:/ {print $2}' "$ROOT/packaging/control")"
PKG_ARCH="$(awk -F': ' '/^Architecture:/ {print $2}' "$ROOT/packaging/control")"
PKG="${PKG_NAME}_${PKG_VERSION}_${PKG_ARCH}.ipk"
WORK="$OUT/ipk-work"

rm -rf "$WORK"
mkdir -p "$WORK/CONTROL" "$OUT"

"$ROOT/scripts/sync-watchface-layout.sh"
cp "$ROOT/packaging/control" "$WORK/CONTROL/control"
cp "$ROOT/packaging/postinst" "$WORK/CONTROL/postinst"
cp "$ROOT/packaging/prerm" "$WORK/CONTROL/prerm"
chmod 0755 "$WORK/CONTROL/postinst" "$WORK/CONTROL/prerm"
cp -R "$ROOT/catfish-pipboy/usr" "$WORK/"
cp -R "$ROOT/catfish-pipboy/etc" "$WORK/"

(cd "$WORK/CONTROL" && tar --owner=0 --group=0 -czf "$WORK/control.tar.gz" control postinst prerm)
(cd "$WORK" && tar --owner=0 --group=0 -czf "$WORK/data.tar.gz" usr etc)
echo "2.0" > "$WORK/debian-binary"
(cd "$WORK" && ar r "$OUT/$PKG" debian-binary control.tar.gz data.tar.gz >/dev/null 2>&1)

echo "Built $OUT/$PKG"
