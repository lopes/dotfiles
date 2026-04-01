# zsh configuration

# improved history settings
setopt EXTENDED_HISTORY       # record timestamp and duration
setopt SHARE_HISTORY          # share history across sessions (implies APPEND_HISTORY)
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS       # ignore consecutive duplicates
setopt HIST_FIND_NO_DUPS      # don't show duplicates in search
setopt HIST_REDUCE_BLANKS     # remove superfluous blanks
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt CORRECT                # correct typos
setopt HIST_VERIFY            # show before executing history
setopt PROMPT_SUBST           # enable prompt substitution
setopt AUTO_CD                # change directory without cd
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shell

# disable control-s/control-q flow control
stty stop undef
stty start undef

# improved completion
autoload -Uz compinit; compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' matcher-list \
  'm:{[:lower:]}={[:upper:]}' \
  '+r:|[._-]=* r:|=*' \
  '+l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true  # auto-update PATH completions
zmodload zsh/complist
_comp_options+=(globdots)  # include hidden files

# homebrew + zsh plugins
if [ -d "/opt/homebrew" ]; then  # arm
  export BREW_PREFIX="/opt/homebrew"
  test -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$BREW_PREFIX/bin:$PATH"
elif [ -d "/usr/local/Homebrew" ]; then  # intel mac
  export BREW_PREFIX="/usr/local/Homebrew"
  test -f $BREW_PREFIX/../share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/../share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$BREW_PREFIX/bin:$PATH"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then  # linux
  export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  test -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source $_
  test -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $_
  PATH="$BREW_PREFIX/bin:$PATH"
fi

test -d $HOME/.local/bin && PATH="$HOME/.local/bin:$PATH"  # local binaries to PATH

# prompt
export PROMPT='%F{#768390}%n@%m❯%f%F{#539bf5}%3~%f%(?.%F{#adbac7}.%F{#f47067})❯%f '
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/sable.toml")"
fi


# modern tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
  --color=fg:#adbac7,bg:#22272e,hl:#539bf5
  --color=fg+:#adbac7,bg+:#2d333b,hl+:#539bf5
  --color=info:#daaa3f,prompt:#57ab5a,pointer:#b083f0
  --color=marker:#57ab5a,spinner:#b083f0,header:#539bf5
  --color=border:#444c56,gutter:#22272e
  --border=rounded --height=40% --layout=reverse"

# extra functions for zsh
test -f $HOME/.config/zsh/functions.sh && source $HOME/.config/zsh/functions.sh

# private settings, like API keys and sensitive functions
if [ -f "$HOME/.config/zsh/private.sh" ]; then
  [ "$(stat -f %Lp "$HOME/.config/zsh/private.sh")" != "600" ] && chmod 600 "$HOME/.config/zsh/private.sh"
  source "$HOME/.config/zsh/private.sh"
fi

# key bindings
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

bindkey '^U' backward-kill-line  # control+U
bindkey '^K' kill-line           # control+K

# os-specific aliases
case "$OSTYPE" in
  linux*)          source "$ZDOTDIR/../aliases.linux.sh"   ;;
  *bsd* | darwin*) source "$ZDOTDIR/../aliases.bsd.sh"     ;;
  msys  | cygwin)  source "$ZDOTDIR/../aliases.windows.sh" ;;
esac
