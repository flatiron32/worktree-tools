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
"$ROOT/bin/wt-create" feature/rebase-me --repo "$REPO_ROOT" >/dev/null

set +e
"$ROOT/bin/wt-sync" --repo "$REPO_ROOT" --rebase </dev/null >/dev/null 2>&1
rc=$?
set -e
[[ $rc -ne 0 ]] || { echo "FAIL: wt-sync --rebase should require --yes in non-interactive mode"; exit 1; }

"$ROOT/bin/wt-sync" --repo "$REPO_ROOT" --rebase --dry-run --yes >/dev/null
"$ROOT/bin/wt-sync" --repo "$REPO_ROOT" --rebase --yes >/dev/null

echo "PASS: wt-sync destructive flags work"
