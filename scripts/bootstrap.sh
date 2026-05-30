#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export RKCFG_BACKUP_DIR="${RKCFG_BACKUP_DIR:-$HOME/.rkcfg-backups/$(date +%Y%m%d%H%M%S)}"

if [[ "${EUID:-$(id -u)}" -eq 0 && -n "${SUDO_USER:-}" ]]; then
    printf '[rkcfg] ERROR: Run bootstrap without sudo. Only package-manager commands should elevate privileges.\n' >&2
    exit 1
fi

bash "$script_dir/install-deps.sh"
bash "$script_dir/install-fish.sh"
bash "$script_dir/install-tmux.sh"

