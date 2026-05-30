if status is-interactive
    if type -q starship
        starship init fish | source
    end
end

set fish_greeting "Welcome, "(whoami)"!"

set -gx NVM_DIR "$HOME/.nvm"
if test -s "$NVM_DIR/nvm.sh"
    if type -q bass
        bass source "$NVM_DIR/nvm.sh"
    end
end

for path_entry in $HOME/.npm-global/bin $HOME/.local/bin
    if test -d "$path_entry"
        fish_add_path --global --move "$path_entry"
    end
end

switch (uname)
case Darwin
    set -gx PNPM_HOME "$HOME/Library/pnpm"
case '*'
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
if test -d "$PNPM_HOME"
    fish_add_path --global --move "$PNPM_HOME"
end

alias ccusage-codex 'npx @ccusage/codex@latest'

if test -d "$HOME/.opencode/bin"
    fish_add_path --global --move "$HOME/.opencode/bin"
end

if test -d "$HOME/.bun"
    set --export BUN_INSTALL "$HOME/.bun"
    fish_add_path --global --move "$BUN_INSTALL/bin"
end

