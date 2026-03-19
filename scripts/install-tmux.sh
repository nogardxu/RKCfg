#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

tmux_plugins_dir="${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins}"

link_dotfile "$dotfiles_dir/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$tmux_plugins_dir"

clone_or_update_repo "https://github.com/tmux-plugins/tpm" "$tmux_plugins_dir/tpm"
clone_or_update_repo "https://github.com/tmux-plugins/tmux-sensible" "$tmux_plugins_dir/tmux-sensible"
clone_or_update_repo "https://github.com/tmux-plugins/tmux-yank" "$tmux_plugins_dir/tmux-yank"
clone_or_update_repo "https://github.com/catppuccin/tmux" "$tmux_plugins_dir/catppuccin"

if command_exists tmux && tmux ls >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf" || warn "tmux is running, but the config could not be reloaded automatically."
fi

