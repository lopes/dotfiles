# zsh configuration

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
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

# Homebrew — brew is a system package manager (like dpkg or rpm), so brew and the
# tools it installs belong on PATH for *every* shell: non-interactive scripts,
# editors, and `make` all need them, not only interactive sessions. This used to
# live in .zshrc (interactive-only), which meant a broken .zshrc silently took
# brew and all its binaries off PATH — and then `make bootstrap` couldn't even
# find brew to repair the machine. PATH belongs here; only the interactive zsh
# plugins (autosuggestions, syntax-highlighting) stay in .zshrc.
typeset -U path PATH  # keep PATH unique — .zshenv also runs for nested shells
if [ -d "/opt/homebrew" ]; then                  # apple silicon
  export BREW_PREFIX="/opt/homebrew"
elif [ -d "/usr/local/Homebrew" ]; then          # intel mac
  export BREW_PREFIX="/usr/local"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then   # linux
  export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi
[ -n "$BREW_PREFIX" ] && PATH="$BREW_PREFIX/bin:$PATH"

# user-local binaries
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

export EDITOR="vim"
export VISUAL="vim"
export VIMINIT="source $HOME/.config/vim/vimrc"

# tells zsh where to look for .zshrc; must be set before zsh searches for it
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LESSHISTFILE="-"  # no history for less command
export LESS="-R"         # color, wrap long lines
export PAGER="less"

export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

export LEDGER_FILE="$HOME/Documents/finances/journal/main.journal"

