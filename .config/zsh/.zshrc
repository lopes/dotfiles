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
setopt SHARE_HISTORY
setopt HIST_VERIFY

stty stop undef
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zmodload zsh/complist
_comp_options+=(globdots)

test -d $HOME/.local/bin && PATH="$_:$PATH"
export PROMPT='%n@%B%M%b%F{240}:%20<..<%3~%<<%f %B%#%b '

bindkey -e  # no vi mode

# mappings for macOS keyboard
# run `cat` and type your keys to get the sequences
bindkey '^r' history-incremental-search-backward  # ctrl-r
bindkey '^[[A' history-search-backward            # up
bindkey '^[[B' history-search-forward             # down
bindkey '^[^[[D' backward-word                    # alt-left
bindkey '^[^[[C' forward-word                     # alt-rightt

case "$OSTYPE" in
    linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
    *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
    msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac

# sourcing private settings, if exist
# it's a place for private settings, like API keys
test -f $HOME/.config/zsh/private.sh && source $HOME/.config/zsh/private.sh

# extra functions and plugins for zsh
source $HOME/.config/functions.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
