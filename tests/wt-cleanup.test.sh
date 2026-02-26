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
"$ROOT/bin/wt-create" feature/merged --repo "$REPO_ROOT" >/dev/null
FEATURE_WT="$REPO_ROOT/branches/feature/merged"
MAIN_WT="$REPO_ROOT/main"

printf "merged\n" >> "$FEATURE_WT/README.md"
git -C "$FEATURE_WT" add README.md
git -C "$FEATURE_WT" commit -m "feature" >/dev/null

git -C "$MAIN_WT" merge --no-ff feature/merged -m "merge feature" >/dev/null

"$ROOT/bin/wt-cleanup" --repo "$REPO_ROOT" --dry-run --yes >/dev/null
[[ -d "$FEATURE_WT" ]] || { echo "FAIL: dry-run should not remove merged worktree"; exit 1; }

set +e
"$ROOT/bin/wt-cleanup" --repo "$REPO_ROOT" </dev/null >/dev/null 2>&1
rc=$?
set -e
[[ $rc -ne 0 ]] || { echo "FAIL: wt-cleanup should require --yes in non-interactive mode"; exit 1; }

"$ROOT/bin/wt-cleanup" --repo "$REPO_ROOT" --yes >/dev/null
[[ ! -d "$FEATURE_WT" ]] || { echo "FAIL: cleanup should remove merged worktree"; exit 1; }

echo "PASS: wt-cleanup destructive flags work"
