#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

SRC="$TMP/source-repo"
mkdir -p "$SRC"
cd "$SRC"
git init -b main >/dev/null
printf "hello\n" > README.md
git add README.md
git commit -m "init" >/dev/null

RUN_DIR="$TMP/run"
mkdir -p "$RUN_DIR"
cd "$RUN_DIR"

set +e
"$ROOT/bin/wt-init" "$SRC" >/dev/null 2>&1
rc=$?
set -e
[[ $rc -eq 0 ]] || { echo "FAIL: wt-init should succeed with default workspace"; exit 1; }

[[ -d "$RUN_DIR/source-repo/main" ]] || { echo "FAIL: main should be at repo root"; exit 1; }
[[ ! -d "$RUN_DIR/source-repo/bare.git/source-repo/main" ]] || { echo "FAIL: main should not be inside bare.git"; exit 1; }

echo "PASS: wt-init places main correctly with relative workspace"
