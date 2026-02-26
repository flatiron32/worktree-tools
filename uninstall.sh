#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${1:-$HOME/.local/bin}"

for cmd in "$SCRIPT_DIR"/bin/wt-*; do
  name="$(basename "$cmd")"
  target="$BIN_DIR/$name"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$cmd" ]]; then
    rm "$target"
    echo "removed $target"
  fi
done
