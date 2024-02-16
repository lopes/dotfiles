# shell configuration and command execution

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt CORRECT

stty stop undef
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zmodload zsh/complist
_comp_options+=(globdots)

test -d $HOME/.local/bin && PATH="$_:$PATH"
export PROMPT='%F{240}[%?] %f%n@%B%M%b %F{240}%20<..<%3~%<<%f %B%#%b '

bindkey -e  # no vi mode
bindkey '^r' history-incremental-search-backward

# mappings for macOS keyboard
# run `cat` and type your keys to get the sequences
bindkey '^[[1;5D' backward-word      # control-left
bindkey '^[[1;5C' forward-word       # control-right
bindkey '^[[D'    beginning-of-line  # command-left
bindkey '^[[C'    end-of-line        # command-right

case "$OSTYPE" in
    linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
    *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
    msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac

source ~/.config/functions.sh
