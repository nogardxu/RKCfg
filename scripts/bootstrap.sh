#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export RKCFG_BACKUP_DIR="${RKCFG_BACKUP_DIR:-$HOME/.rkcfg-backups/$(date +%Y%m%d%H%M%S)}"

"$script_dir/install-deps.sh"
"$script_dir/install-fish.sh"
"$script_dir/install-tmux.sh"

