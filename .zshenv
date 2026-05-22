# zsh configuration

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Projects"
export XDG_PUBLICSHARE_DIR="$HOME/Shares"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# default file mode: owner rwx, group rx, others nothing
umask 027

export EDITOR="vim"
export VISUAL="vim"
export VIMINIT="source $HOME/.config/vim/vimrc"

# tool themes
export BAT_THEME="base16-256"

# tells zsh where to look for .zshrc; must be set before zsh searches for it
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LESSHISTFILE="-"  # no history for less command
export LESS="-R"         # color, wrap long lines
export PAGER="less"

# rust
export RUSTUP_HOME="$XDG_CACHE_HOME/rustup"
export CARGO_HOME="$XDG_CACHE_HOME/cargo"
if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
fi

export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

export LEDGER_FILE="$HOME/Documents/hledger/journal/main.journal"

