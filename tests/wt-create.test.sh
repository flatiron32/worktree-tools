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

set +e
out="$($ROOT/bin/wt-create feature-123 --repo "$REPO_ROOT" 2>/dev/null)"
rc=$?
set -e

if [[ $rc -ne 0 ]]; then
  echo "FAIL: wt-create should succeed"
  exit 1
fi

expected="$REPO_ROOT/branches/feature-123"
[[ "$out" == "$expected" ]] || { echo "FAIL: wt-create should output $expected, got: $out"; exit 1; }
[[ -d "$expected" ]] || { echo "FAIL: missing branch worktree dir"; exit 1; }

branch="$(git -C "$expected" rev-parse --abbrev-ref HEAD)"
[[ "$branch" == "feature-123" ]] || { echo "FAIL: expected branch feature-123, got: $branch"; exit 1; }

echo "PASS: wt-create created branch worktree"
