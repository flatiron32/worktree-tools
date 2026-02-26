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
REPO_ROOT="$WS/source"

set +e
"$ROOT/bin/wt-init" "$SRC" "$WS" --yes >/dev/null 2>&1
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-init should recreate existing clean repo with --yes"
  exit 1
fi

[[ -d "$REPO_ROOT/main" ]] || { echo "FAIL: recreated main missing"; exit 1; }

echo "PASS: wt-init recreates existing clean repo with --yes"
