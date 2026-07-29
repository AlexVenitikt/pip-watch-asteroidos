#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
VERSION="$(awk -F': ' '/^Version:/ {print $2}' "$ROOT/packaging/control")"
RELEASE_DIR="$ROOT/dist/release-v$VERSION"
PKG_NAME="asteroid-watchface-catfish-pipboy"

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

"$ROOT/scripts/build-ipk.sh"
IPK="$(find "$ROOT/dist" -maxdepth 1 -name "${PKG_NAME}_*.ipk" | sort | tail -n 1)"

cp "$IPK" "$RELEASE_DIR/"
tar -C "$ROOT" \
    --exclude='.git' \
    --exclude='dist' \
    --exclude='device-backups' \
    --exclude='Logos' \
    --exclude='Map Icons' \
    --exclude='Other Icons' \
    -czf "$RELEASE_DIR/${PKG_NAME}-v${VERSION}-source.tar.gz" .

(cd "$RELEASE_DIR" && sha256sum * > SHA256SUMS)

echo "Release artifacts:"
find "$RELEASE_DIR" -maxdepth 1 -type f -print
