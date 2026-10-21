# zsh environment configuration

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# default file mode: owner rwx, group rx, others nothing
umask 027

# local environment overrides (untracked)
if [ -f "$HOME/.config/zsh/private.sh" ]; then
  chmod 600 "$HOME/.config/zsh/private.sh"
  . "$HOME/.config/zsh/private.sh"
fi

# keep PATH unique across nested shells and prepend user-local binaries
typeset -U path PATH
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

export EDITOR="vim"
export VISUAL="vim"
export VIMINIT="source $HOME/.config/vim/vimrc"

# tells zsh where to look for .zshrc; must be set before zsh searches for it
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export LESSHISTFILE="-"  # no history for less command
export LESS="-R"         # color, wrap long lines
export PAGER="less"

export LEDGER_FILE="$HOME/Documents/finances/journal/main.journal"
