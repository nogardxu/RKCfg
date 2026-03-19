#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
dotfiles_dir="$repo_root/dotfiles"
backup_root="${RKCFG_BACKUP_DIR:-$HOME/.rkcfg-backups/$(date +%Y%m%d%H%M%S)}"

log() {
    printf '[rkcfg] %s\n' "$*"
}

warn() {
    printf '[rkcfg] WARN: %s\n' "$*" >&2
}

die() {
    printf '[rkcfg] ERROR: %s\n' "$*" >&2
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_backup_dir() {
    mkdir -p "$backup_root"
}

backup_path() {
    local target="$1"
    local relative_target
    local backup_target

    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return
    fi

    ensure_backup_dir

    if [[ "$target" == "$HOME/"* ]]; then
        relative_target="${target#$HOME/}"
    else
        relative_target="$(basename "$target")"
    fi

    backup_target="$backup_root/$relative_target"
    mkdir -p "$(dirname "$backup_target")"
    mv "$target" "$backup_target"
    log "Backed up $target -> $backup_target"
}

link_dotfile() {
    local source="$1"
    local target="$2"
    local current_target

    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]]; then
        current_target="$(readlink "$target")"
        if [[ "$current_target" == "$source" ]]; then
            log "Link already up to date: $target"
            return
        fi
    fi

    backup_path "$target"
    ln -s "$source" "$target"
    log "Linked $target -> $source"
}

clone_or_update_repo() {
    local repo_url="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -d "$target/.git" ]]; then
        log "Updating $target"
        git -C "$target" pull --ff-only
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        backup_path "$target"
    fi

    log "Cloning $repo_url -> $target"
    git clone --depth 1 "$repo_url" "$target"
}
