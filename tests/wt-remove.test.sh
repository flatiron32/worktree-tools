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
"$ROOT/bin/wt-create" feature/remove-me --repo "$REPO_ROOT" >/dev/null
TARGET="$REPO_ROOT/branches/feature/remove-me"

"$ROOT/bin/wt-remove" feature/remove-me --repo "$REPO_ROOT" --dry-run --yes >/dev/null
[[ -d "$TARGET" ]] || { echo "FAIL: dry-run should not remove worktree"; exit 1; }

set +e
"$ROOT/bin/wt-remove" feature/remove-me --repo "$REPO_ROOT" </dev/null >/dev/null 2>&1
rc=$?
set -e
[[ $rc -ne 0 ]] || { echo "FAIL: wt-remove should require --yes in non-interactive use"; exit 1; }

"$ROOT/bin/wt-remove" feature/remove-me --repo "$REPO_ROOT" --yes >/dev/null
[[ ! -d "$TARGET" ]] || { echo "FAIL: wt-remove should remove worktree"; exit 1; }

echo "PASS: wt-remove destructive flags work"
