#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

export RKCFG_BACKUP_DIR="${RKCFG_BACKUP_DIR:-$HOME/.rkcfg-backups/$(date +%Y%m%d%H%M%S)}"

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    die "Run bootstrap as a regular user. Only package-manager commands should elevate privileges."
fi

declare -a selected_components=()

usage() {
    cat <<'EOF'
Usage: ./scripts/bootstrap.sh [component...]

Components:
  fish   Install fish, fisher plugins, and starship config
  tmux   Install tmux config, TPM, and Catppuccin theme
  herdr  Install Herdr, its config, and selected integrations

Examples:
  ./scripts/bootstrap.sh
  ./scripts/bootstrap.sh fish tmux
  ./scripts/bootstrap.sh herdr
EOF
}

append_component() {
    local component="$1"
    local existing

    for existing in "${selected_components[@]:-}"; do
        if [[ "$existing" == "$component" ]]; then
            return
        fi
    done

    selected_components+=("$component")
}

component_status() {
    local component="$1"

    case "$component" in
        fish)
            if [[ -L "$HOME/.config/fish/config.fish" || -f "$HOME/.config/fish/config.fish" ]] \
                || command_exists fish; then
                printf 'installed'
            else
                printf 'not installed'
            fi
            ;;
        tmux)
            if [[ -L "$HOME/.tmux.conf" || -f "$HOME/.tmux.conf" ]] \
                || command_exists tmux; then
                printf 'installed'
            else
                printf 'not installed'
            fi
            ;;
        herdr)
            if [[ -L "$HOME/.config/herdr/config.toml" || -f "$HOME/.config/herdr/config.toml" ]] \
                || command_exists herdr; then
                printf 'installed'
            else
                printf 'not installed'
            fi
            ;;
        *)
            die "Unknown component: $component"
            ;;
    esac
}

prompt_yes_no() {
    local prompt="$1"
    local reply

    while true; do
        printf '%s [y/N]: ' "$prompt"
        read -r reply

        case "$reply" in
            y|Y|yes|YES)
                return 0
                ;;
            ''|n|N|no|NO)
                return 1
                ;;
            *)
                warn "Please answer y or n."
                ;;
        esac
    done
}

prompt_for_components() {
    local component
    local label
    local description
    local status

    cat <<'EOF'
Select components to configure. Existing installs are skipped unless you explicitly answer y.
EOF

    for component in fish tmux herdr; do
        case "$component" in
            fish)
                label="fish"
                description="shell, fisher, starship"
                ;;
            tmux)
                label="tmux"
                description="tmux config, TPM, Catppuccin"
                ;;
            herdr)
                label="herdr"
                description="Herdr config and integrations"
                ;;
        esac

        status="$(component_status "$component")"
        if prompt_yes_no "$label ($description) [$status]"; then
            append_component "$component"
        fi
    done
}

resolve_components() {
    local arg

    if (($# == 0)); then
        prompt_for_components
        return
    fi

    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                usage
                exit 0
                ;;
            fish|tmux|herdr)
                append_component "$arg"
                ;;
            all)
                append_component fish
                append_component tmux
                append_component herdr
                ;;
            *)
                die "Unknown component: $arg"
                ;;
        esac
    done
}

run_component() {
    local component="$1"
    local script=""

    case "$component" in
        fish)
            script="$script_dir/install-fish.sh"
            ;;
        tmux)
            script="$script_dir/install-tmux.sh"
            ;;
        herdr)
            script="$script_dir/install-herdr.sh"
            ;;
    esac

    [[ -n "$script" ]] || die "No installer registered for component: $component"
    log "Applying component: $component"
    bash "$script"
}

main() {
    local component

    resolve_components "$@"

    if ((${#selected_components[@]} == 0)); then
        log "No components selected. Nothing to do."
        exit 0
    fi

    bash "$script_dir/install-deps.sh"

    for component in "${selected_components[@]}"; do
        run_component "$component"
    done
}

main "$@"
