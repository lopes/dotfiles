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
export PROMPT='%F{red}%(?..%? )%f%n%F{240}@%f%m%F{240} %40<..<%2~%<< %#%f '

bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-up-line-or-history
bindkey -M menuselect 'k' vi-forward-char
bindkey -M menuselect 'l' vi-down-line-or-history
bindkey '^r' history-incremental-search-backward

# abnt2 keyboard mappings
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

case "$OSTYPE" in
    linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
    *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
    msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac
