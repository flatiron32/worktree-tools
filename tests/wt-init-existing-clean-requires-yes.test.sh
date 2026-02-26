#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

SRC="$TMP/source"
mkdir -p "$SRC"
cd "$SRC"
git init -b main >/dev/null
printf "base\n" > README.md
git add README.md
git commit -m "init" >/dev/null

WS="$TMP/ws"
mkdir -p "$WS"
"$ROOT/bin/wt-init" "$SRC" "$WS" >/dev/null

set +e
"$ROOT/bin/wt-init" "$SRC" "$WS" </dev/null >/dev/null 2>&1
rc=$?
set -e

[[ $rc -ne 0 ]] || { echo "FAIL: expected non-interactive replace to require --yes"; exit 1; }
echo "PASS: wt-init requires --yes for non-interactive clean replace"
