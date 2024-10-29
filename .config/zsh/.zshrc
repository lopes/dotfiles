# zsh configuration

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
setopt PROMPT_SUBST

stty stop undef
autoload -Uz compinit; compinit
zstyle ':completion:*' matcher-list \
  'm:{[:lower:]}={[:upper:]}' \
  '+r:|[._-]=* r:|=*' \
  '+l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zmodload zsh/complist
_comp_options+=(globdots)

export PROMPT='%n%F{245}@%f%B%M%b%F{245}:%20<..<%3~%<<$(git_branch)%f%B%#%b '

test -d $HOME/.local/bin && PATH="$_:$PATH"

# homebrew + zsh plugins
if [ -d "/opt/homebrew" ]; then  # ARM
  export BREW_PREFIX="/opt/homebrew"
  test -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$BREW_PREFIX/bin:$PATH"
elif [ -d "/usr/local/Homebrew" ]; then  # Intel
  export BREW_PREFIX="/usr/local/Homebrew"
  test -f $BREW_PREFIX/../share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/../share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$BREW_PREFIX/bin:$PATH"
fi

# extra functions and plugins for zsh
test -f $HOME/.config/functions.sh && source $HOME/.config/functions.sh

# sourcing private settings, if exist
# it's a place for private settings, like API keys
test -f $HOME/.config/zsh/private.sh && source $HOME/.config/zsh/private.sh

# mappings for macOS keyboard
# run `cat` and type your keys to get the sequences
bindkey -e  # no vi mode

bindkey '^r'   history-incremental-search-backward  # control-r
bindkey '^[[A' history-search-backward              # up
bindkey '^[[B' history-search-forward               # down

bindkey '^[^[[D' backward-word  # alt-left
bindkey '^[^[[C' forward-word   # alt-right

bindkey '^[[H'  beginning-of-line  # home
bindkey '^[[F'  end-of-line        # end
bindkey '^[[3~' delete-char        # del

bindkey '^[[1;9C' end-of-line        # cmd-right
bindkey '^[[1;9D' beginning-of-line  # cmd-left


case "$OSTYPE" in
  linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
  *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
  msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac
