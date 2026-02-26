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
REPO_ROOT="$WS/source"
"$ROOT/bin/wt-init" "$SRC" "$WS" >/dev/null

set +e
"$ROOT/bin/wt-remove" main --repo "$REPO_ROOT" --yes >/dev/null 2>&1
rc=$?
set -e

[[ $rc -ne 0 ]] || { echo "FAIL: wt-remove must refuse main worktree"; exit 1; }
[[ -d "$REPO_ROOT/main" ]] || { echo "FAIL: main worktree should remain"; exit 1; }

echo "PASS: wt-remove protects main worktree"
