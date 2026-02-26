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

WORKSPACE="$TMP/ws"
mkdir -p "$WORKSPACE"
REPO_ROOT="$WORKSPACE/source-repo"

"$ROOT/bin/wt-init" "$SRC" "$WORKSPACE" >/dev/null
"$ROOT/bin/wt-create" feature/auth --repo "$REPO_ROOT" >/dev/null

set +e
out="$($ROOT/bin/wt-switch feature/auth --repo "$REPO_ROOT" 2>/dev/null)"
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-switch should succeed"
  exit 1
fi

expected="$(cd "$REPO_ROOT/branches/feature/auth" && pwd -P)"
[[ "$out" == "$expected" ]] || { echo "FAIL: wt-switch should output $expected, got: $out"; exit 1; }

echo "PASS: wt-switch resolved worktree path"
