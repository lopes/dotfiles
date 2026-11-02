# zsh interactive configuration

# abort immediately if not running in an interactive terminal (headless/subshell safety)
[[ -t 0 ]] || return 0

# history — shell history is state, not disposable cache
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
HISTSIZE=2000
SAVEHIST=15000
HISTORY_IGNORE="(ls(| *)|pwd|exit|cd(| *)|bg(| *)|fg(| *)|history)"

# zsh line editor
KEYTIMEOUT=1

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

# zsh plugins — interactive only
test -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" && source "$_"
test -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source "$_"

# prompt — layout: host:path (git) [venv] +❯                               5s
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/sable.toml")"
else
  autoload -Uz vcs_info add-zsh-hook
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:git:*' unstagedstr '*'
  zstyle ':vcs_info:git:*' stagedstr '+'
  zstyle ':vcs_info:git:*' formats ' %F{#545d68}(%f%F{#57ab5a}%b%f%F{#c69026}%u%c%f%F{#545d68})%f'
  zstyle ':vcs_info:git:*' actionformats ' %F{#545d68}(%f%F{#daaa3f}%b|%a%u%c%f%F{#545d68})%f'

  _prompt_short_pwd() {
    local p="${PWD/#$HOME/~}"
    local -a parts=("${(@s:/:)p}")
    local i seg
    for (( i = 1; i < ${#parts[@]}; i++ )); do
      seg="${parts[$i]}"
      [[ -z "$seg" || "$seg" == "~" ]] && continue
      if [[ "$seg" == .* ]]; then
        parts[$i]="${seg[1,4]}"
      else
        parts[$i]="${seg[1,3]}"
      fi
    done
    _short_pwd="${(j:/:)parts}"
    [[ -z "$_short_pwd" ]] && _short_pwd="/"
  }

  _prompt_preexec() { _cmd_start=$SECONDS }
  _prompt_precmd() {
    vcs_info
    _prompt_short_pwd
    _user_seg=""
    if (( EUID == 0 )); then
      _user_seg="%F{#f47067}root%f%F{#545d68}@%f"
    elif [[ "$USER" != "$DEFAULT_USER" ]]; then
      _user_seg="%F{#daaa3f}%n%f%F{#545d68}@%f"
    fi
    _venv_seg=""
    [[ -n "$VIRTUAL_ENV" ]] && _venv_seg=" %F{#545d68}[%f%F{#b083f0}${VIRTUAL_ENV:t}%f%F{#545d68}]%f"
    RPROMPT=""
    if [[ -n "$_cmd_start" ]]; then
      local elapsed=$(( SECONDS - _cmd_start ))
      unset _cmd_start
      (( elapsed >= 5 )) && RPROMPT="%F{#545d68}${elapsed}s%f"
    fi
  }
  add-zsh-hook preexec _prompt_preexec
  add-zsh-hook precmd _prompt_precmd

  export PROMPT='${_user_seg}%F{#768390}${${HOST%%.*}#lopes-}%f%F{#545d68}:%f%F{#539bf5}${_short_pwd}%f${vcs_info_msg_0_}${_venv_seg} %(1j.%F{#daaa3f}+%f.)%(!.%F{#f47067}#%f.%(?.%F{#adbac7}.%F{#f47067})❯%f) '
fi

# key bindings
# run `cat` and type your keys to get the sequences
bindkey -e  # emacs mode

bindkey '^r'   history-incremental-search-backward  # control-r fallback when fzf is absent
bindkey '^[[A' history-search-backward              # up
bindkey '^[[B' history-search-forward               # down

bindkey '^[^[[D' backward-word  # alt-left
bindkey '^[^[[C' forward-word   # alt-right

bindkey '^[[H'  beginning-of-line  # home
bindkey '^[[F'  end-of-line        # end
bindkey '^[[3~' delete-char        # del

bindkey '^U' backward-kill-line  # control-u
bindkey '^K' kill-line           # control-k

# fzf — loaded after bindkey so fzf binds ctrl-r, ctrl-t, and alt-c when installed
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  export FZF_DEFAULT_OPTS="
    --color=fg:#adbac7,bg:#22272e,hl:#539bf5
    --color=fg+:#adbac7,bg+:#2d333b,hl+:#539bf5
    --color=info:#daaa3f,prompt:#57ab5a,pointer:#b083f0
    --color=marker:#57ab5a,spinner:#b083f0,header:#539bf5
    --color=border:#444c56,gutter:#22272e
    --border=rounded --height=40% --layout=reverse"
fi

# aliases
test -f "$ZDOTDIR/aliases.sh" && source "$ZDOTDIR/aliases.sh"
