#!/usr/bin/env bash
set -euo pipefail

use_colors() {
  [[ "${NO_COLOR:-}" == "1" || "${NO_COLOR:-}" == "true" ]] && return 1
  [[ -t 2 ]] || return 1
  case "${TERM:-}" in
    *color*|xterm*|rxvt*|screen*|tmux*|vt100*) return 0 ;;
  esac
  return 1
}

if use_colors; then
  RED='\033[0;31m'; YELLOW='\033[0;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
  RED=''; YELLOW=''; GREEN=''; CYAN=''; BOLD=''; RESET=''
fi

log_info() { printf "${CYAN}ℹ ${RESET}%s\n" "$*" >&2; }
log_success() { printf "${GREEN}✔ ${RESET}%s\n" "$*" >&2; }
log_warn() { printf "${YELLOW}⚠ ${RESET}%s\n" "$*" >&2; }
log_error() { printf "${RED}✖ ${RESET}%s\n" "$*" >&2; }

die() { log_error "$*"; exit 1; }

require_command() { command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"; }

confirm_or_exit() {
  local prompt="$1"
  local yes_flag="$2"
  if [[ "$yes_flag" == true ]]; then
    return 0
  fi
  if [[ ! -t 0 ]]; then
    die "$prompt (requires --yes in non-interactive mode)"
  fi
  local answer
  read -r -p "$prompt [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || die "Aborted."
}
