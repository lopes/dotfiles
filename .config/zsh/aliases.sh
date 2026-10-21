#!/bin/sh
# shell aliases

alias aka="alias | grep"

alias ..="cd .."
alias ...="cd ../.."

alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

alias cd..="\cd .."
alias dc="\cd"
alias sl="\ls"
alias l="ls"
alias ls="ls --color=auto -lhF --group-directories-first"
alias ll="ls --color=auto -lAhF --group-directories-first"
alias la="ls --color=auto -A"

alias path='echo $PATH | tr ":" "\n"'
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias reload="exec $SHELL -l"

alias grep="grep --color=auto"
alias diff="diff --color"
alias wget="wget -c"
alias psa="ps auxf"
alias free="free -mlt"
alias df="df -Tah --total"
alias mount="mount | column -t"
alias du="du -ah"
alias sha="sha256sum"
alias vi="vim"
alias tmux0="tmux new -As0"

[ -n "$ZSH_VERSION" ] && alias sudo="nocorrect sudo"

alias update-system="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
