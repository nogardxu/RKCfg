#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/common.sh"

load_homebrew_env() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

install_starship() {
    mkdir -p "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"

    if [[ -x "$HOME/.local/bin/starship" ]] || command_exists starship; then
        log "Installing or updating starship via the official install script"
    else
        log "Installing starship via the official install script"
    fi

    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_homebrew() {
    if command_exists brew; then
        return
    fi

    log "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_homebrew_env

    if ! command_exists brew; then
        die "Homebrew installation completed but brew is not available in PATH."
    fi
}

install_macos_deps() {
    load_homebrew_env
    install_homebrew

    local packages=(fish tmux git curl)
    local missing_packages=()

    for package in "${packages[@]}"; do
        if ! brew list --formula "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done

    if ((${#missing_packages[@]} > 0)); then
        log "Installing packages with Homebrew: ${missing_packages[*]}"
        brew install "${missing_packages[@]}"
    else
        log "Homebrew packages already installed"
    fi

    install_starship
}

install_linux_deps() {
    local missing_packages=()

    for package in fish tmux git curl; do
        if ! command_exists "$package"; then
            missing_packages+=("$package")
        fi
    done

    if ((${#missing_packages[@]} > 0)); then
        if ! command_exists apt-get; then
            die "Unsupported Linux distribution. Please install fish, tmux, starship, git, and curl manually."
        fi

        log "Installing packages with apt-get: ${missing_packages[*]}"
        sudo apt-get update
        sudo apt-get install -y "${missing_packages[@]}"
    else
        log "System packages already installed"
    fi

    install_starship
}

main() {
    case "$(uname -s)" in
        Darwin)
            install_macos_deps
            ;;
        Linux)
            install_linux_deps
            ;;
        *)
            die "Unsupported operating system: $(uname -s)"
            ;;
    esac
}

main "$@"
