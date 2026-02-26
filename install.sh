#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="${1:-}"
if [[ -z "$BIN_DIR" ]]; then
  if [[ -d "$HOME/.local/bin" || ! -d "$HOME/bin" ]]; then
    BIN_DIR="$HOME/.local/bin"
  else
    BIN_DIR="$HOME/bin"
  fi
fi

mkdir -p "$BIN_DIR"
for cmd in "$SCRIPT_DIR"/bin/wt-*; do
  name="$(basename "$cmd")"
  ln -sfn "$cmd" "$BIN_DIR/$name"
  echo "linked $name -> $BIN_DIR/$name"
done

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "warning: $BIN_DIR is not on PATH" ;;
esac
