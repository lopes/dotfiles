# linux-friendly aliases

alias sh="zsh"

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
alias mtr="mtr -ny 0"
alias httptest="curl -Lso /dev/null -w 'status-code: %{http_code}\n'"
alias httping="httping --timestamp -zlY --threshold-red 900 --threshold-yellow 400 "

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

alias cd..="\cd .."
alias sl="\ls"
alias l="\ls"

alias sudo="nocorrect sudo"
alias shutdown="sudo shutdown"
alias reboot="sudo reboot"

alias gs="git status"
alias gd="git diff"
alias gl="git log"
alias gc="git commit"
alias gp="git push"
