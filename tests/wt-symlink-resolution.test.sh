#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

BIN_DIR="$TMP/bin"
mkdir -p "$BIN_DIR"
ln -s "$ROOT/bin/wt-init" "$BIN_DIR/wt-init"

set +e
"$BIN_DIR/wt-init" --help >/dev/null 2>&1
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-init should run through symlink"
  exit 1
fi

echo "PASS: wt-init resolves lib paths when symlinked"
