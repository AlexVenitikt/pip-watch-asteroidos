#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/docs/qmlscene-preview.png}"

mkdir -p "$(dirname "$OUT")"

xvfb-run -a -s "-screen 0 480x480x24" sh -c '
    cd "$1"
    QT_QUICK_BACKEND=software qmlscene -I "$1/dev/qml-stubs" -geometry 480x480 qml/Main.qml &
    pid=$!
    sleep 2
    import -window root "$2"
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
' sh "$ROOT" "$OUT"

identify "$OUT"
