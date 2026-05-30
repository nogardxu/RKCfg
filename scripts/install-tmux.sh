#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

config_home="$HOME/.config"
tmux_config_dir="$config_home/tmux"
tmux_plugins_dir="$HOME/.tmux/plugins"
tpm_dir="$tmux_plugins_dir/tpm"
catppuccin_dir="$tmux_config_dir/plugins/catppuccin/tmux"

mkdir -p "$config_home" "$tmux_config_dir" "$tmux_plugins_dir" "$HOME/.tmux"

link_dotfile "$dotfiles_dir/.config/tmux/tmux.conf" "$tmux_config_dir/tmux.conf"
link_dotfile "$dotfiles_dir/.config/tmux/tmux.conf" "$HOME/.tmux.conf"

clone_or_update_repo "https://github.com/tmux-plugins/tpm" "$tpm_dir"
clone_or_update_repo "https://github.com/catppuccin/tmux" "$catppuccin_dir" "v2.1.3"

if command_exists tmux; then
    tmux start-server \; source-file "$HOME/.tmux.conf" \; run-shell "$tpm_dir/bin/install_plugins"
fi

if command_exists tmux && tmux ls >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf" || warn "tmux is running, but the config could not be reloaded automatically."
fi
