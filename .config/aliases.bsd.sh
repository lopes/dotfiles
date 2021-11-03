# bsd-friendly aliases

alias sh="zsh"

alias ls="ls -GlhF"
alias ll="ls -alF"
alias la="ls -A"

alias p="pwd"
alias ..="cd .."
alias ...="cd ../.."

alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias fgrep="fgrep --colour=auto"

alias diff="git diff"
alias wget="wget -c"
alias ps="ps aux"
alias free="vm_stat"
alias df="df -ah"
alias mount="mount | column -t"
alias du="du -ach | sort -h"
alias vi="vim"

alias cd..="\cd .."
alias sl="\ls"
alias l="\ls"

alias sudo="nocorrect sudo"
alias shutdown="shutdown"
alias reboot="reboot"

alias pkgu="brew update && brew upgrade"  # update
alias pkgs="brew search"                  # search
alias pkgi="brew install"                 # install
alias pkgr="brew uninstall"               # remove

alias gs="git status"
alias gd="git diff"
alias gl="git log"
alias gc="git commit"
alias gp="git push"
