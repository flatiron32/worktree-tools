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
MAIN_WT="$REPO_ROOT/main"
"$ROOT/bin/wt-init" "$SRC" "$WS" >/dev/null

"$ROOT/bin/wt-create" feature/clean-merged --repo "$REPO_ROOT" >/dev/null
"$ROOT/bin/wt-create" feature/dirty-merged --repo "$REPO_ROOT" >/dev/null
CLEAN_WT="$REPO_ROOT/branches/feature/clean-merged"
DIRTY_WT="$REPO_ROOT/branches/feature/dirty-merged"

printf "clean\n" > "$CLEAN_WT/CLEAN.txt"
git -C "$CLEAN_WT" add CLEAN.txt
git -C "$CLEAN_WT" commit -m "clean" >/dev/null

printf "dirty\n" > "$DIRTY_WT/DIRTY.txt"
git -C "$DIRTY_WT" add DIRTY.txt
git -C "$DIRTY_WT" commit -m "dirty" >/dev/null
printf "uncommitted\n" >> "$DIRTY_WT/DIRTY.txt"

git -C "$MAIN_WT" merge --no-ff feature/clean-merged -m "merge clean" >/dev/null
git -C "$MAIN_WT" merge --no-ff feature/dirty-merged -m "merge dirty" >/dev/null

set +e
"$ROOT/bin/wt-cleanup" --repo "$REPO_ROOT" --yes >/dev/null 2>&1
rc=$?
set -e

[[ $rc -ne 0 ]] || { echo "FAIL: wt-cleanup should return non-zero when a merged worktree is dirty"; exit 1; }
[[ ! -d "$CLEAN_WT" ]] || { echo "FAIL: clean merged worktree should be removed"; exit 1; }
[[ -d "$DIRTY_WT" ]] || { echo "FAIL: dirty merged worktree should be preserved"; exit 1; }

echo "PASS: wt-cleanup skips dirty merged worktree and continues"
