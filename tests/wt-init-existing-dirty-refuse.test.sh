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
"$ROOT/bin/wt-create" feature/existing --repo "$REPO_ROOT" >/dev/null

set +e
"$ROOT/bin/wt-init" "$SRC" "$WS" --yes >/dev/null 2>&1
rc=$?
set -e

[[ $rc -ne 0 ]] || { echo "FAIL: wt-init should refuse replace when existing repo is not clean"; exit 1; }
[[ -d "$REPO_ROOT/branches/feature/existing" ]] || { echo "FAIL: existing feature worktree should remain"; exit 1; }

echo "PASS: wt-init refuses replace when existing repo is not clean"
