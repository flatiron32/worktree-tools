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
printf "change\n" >> "$REPO_ROOT/branches/feature/auth/README.md"

set +e
json="$($ROOT/bin/wt-status --repo "$REPO_ROOT" --json 2>/dev/null)"
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-status --json should succeed"
  exit 1
fi

echo "$json" | grep -q '"branch":"feature/auth"' || { echo "FAIL: wt-status json missing feature/auth"; exit 1; }
echo "$json" | grep -q '"dirty":true' || { echo "FAIL: wt-status json missing dirty=true"; exit 1; }

echo "PASS: wt-status outputs json with dirty state"
