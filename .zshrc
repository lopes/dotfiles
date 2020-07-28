## SHELL OPTIONS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt CORRECT
setopt CORRECT_ALL

HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTSIZE=2000

TMOUT=600
readonly TMOUT
export TMOUT

export EDITOR="vim"
export VISUAL="vim"

test -d $HOME/.local/bin && PATH="$_:$PATH"


## OPTIONS

# autocompletion and case insensitive
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

PROMPT='%F{red}%(?..%? )%f%n%F{240}@%f%m%F{240} %40<..<%2~%<< %#%f '


## ALIASES
alias ls="ls --color=auto -lhF"
alias ll="ls -alF"
alias la="ls -A"

alias p="pwd"
alias ..="cd .."
alias ...="cd ../.."

alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias ifconfig="ip address"
alias route="ip route"
alias arp="ip neighbor"
alias netstat="ss"

alias diff="diff --color"
alias wget="wget -c"
alias ps="ps auxf"
alias free="free -mlt"
alias df="df -Tah --total"
alias mount="mount | column -t"
alias du="du -ach | sort -h"
alias hexdump="hexdump -C"
alias od="od -A x -t x1z -v"
alias vi="vim"

alias cd..="/bin/cd .."
alias sl="/bin/ls"
alias l="/bin/ls"

alias sudo="nocorrect sudo"

