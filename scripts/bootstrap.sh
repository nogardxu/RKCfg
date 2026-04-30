#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export RKCFG_BACKUP_DIR="${RKCFG_BACKUP_DIR:-$HOME/.rkcfg-backups/$(date +%Y%m%d%H%M%S)}"

sudo bash "$script_dir/install-deps.sh"
sudo bash "$script_dir/install-fish.sh"
sudo bash "$script_dir/install-tmux.sh"

curl -sS https://starship.rs/install.sh | sh
starship init fish | source

