#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

config_home="$HOME/.config"
herdr_config_dir="$config_home/herdr"
herdr_config="$herdr_config_dir/config.toml"

mkdir -p "$config_home" "$herdr_config_dir"

install_herdr() {
    if command_exists herdr; then
        log "Herdr already installed"
        return
    fi

    log "Installing Herdr"
    curl -fsSL https://herdr.dev/install.sh | sh

    if ! command_exists herdr; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    command_exists herdr || die "Herdr installation completed but herdr is not available in PATH."
}

ensure_integration_dirs() {
    mkdir -p \
        "$HOME/.omp/agent/extensions" \
        "$HOME/.codex" \
        "$HOME/.config/opencode/plugins"
}

install_integrations() {
    local integrations=(omp codex opencode)
    local integration

    for integration in "${integrations[@]}"; do
        log "Installing Herdr integration: $integration"
        herdr integration install "$integration"
    done
}

install_herdr
link_dotfile "$dotfiles_dir/.config/herdr/config.toml" "$herdr_config"
ensure_integration_dirs
install_integrations

if herdr status >/dev/null 2>&1; then
    herdr server reload-config >/dev/null
fi
