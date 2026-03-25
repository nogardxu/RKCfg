#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

config_home="$HOME/.config"
mkdir -p "$config_home" "$config_home/fish/conf.d"

link_dotfile "$dotfiles_dir/.config/fish/config.fish" "$config_home/fish/config.fish"
link_dotfile "$dotfiles_dir/.config/fish/fish_plugins" "$config_home/fish/fish_plugins"
link_dotfile "$dotfiles_dir/.config/fish/conf.d/rustup.fish" "$config_home/fish/conf.d/rustup.fish"
link_dotfile "$dotfiles_dir/.config/starship.toml" "$config_home/starship.toml"

if ! command_exists fish; then
    die "fish is not installed. Run scripts/install-deps.sh first."
fi

if ! command_exists curl; then
    die "curl is not installed. Run scripts/install-deps.sh first."
fi

log "Installing Fisher and Fish plugins"
export FISHER_URL="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"

fish -c '
    if not functions -q fisher
        curl -fsSL $FISHER_URL | source
        fisher install jorgebucaran/fisher
    end

    if test -f $__fish_config_dir/fish_plugins
        fisher update
    end
'
