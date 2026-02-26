#!/usr/bin/env bash
set -euo pipefail

emit_json_error() {
  local msg="$1"
  printf '{"error":"%s"}\n' "$msg"
}
