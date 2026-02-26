#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

resolve_repo_root() {
  local explicit="${1:-}"
  if [[ -n "$explicit" ]]; then
    [[ -d "$explicit/bare.git" ]] || die "Not a repo container (missing bare.git): $explicit"
    (cd "$explicit" && pwd)
    return
  fi

  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/bare.git" ]]; then
      echo "$dir"
      return
    fi
    dir="$(dirname "$dir")"
  done

  die "Could not resolve repo container root. Use --repo <path> or run from inside a repo container."
}

bare_repo_dir() { echo "$1/bare.git"; }
main_worktree_dir() { echo "$1/main"; }
branches_dir() { echo "$1/branches"; }
