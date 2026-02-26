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

set +e
"$ROOT/bin/wt-init" "$SRC" "$WORKSPACE" >/dev/null 2>&1
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-init should initialize repo layout"
  exit 1
fi

[[ -d "$WORKSPACE/source-repo/bare.git" ]] || { echo "FAIL: missing bare.git"; exit 1; }
[[ -d "$WORKSPACE/source-repo/main" ]] || { echo "FAIL: missing main worktree"; exit 1; }
[[ -d "$WORKSPACE/source-repo/branches" ]] || { echo "FAIL: missing branches dir"; exit 1; }

echo "PASS: wt-init created expected layout"
