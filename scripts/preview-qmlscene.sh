#!/bin/sh
set -eu
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
qmlscene -I "$ROOT/dev/qml-stubs" "$ROOT/qml/Main.qml"
