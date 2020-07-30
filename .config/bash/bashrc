test -z "$PS1" && return

test -f /etc/bashrc && . "$_"
test -d $HOME/.local/bin && PATH="$_:$PATH"

stty -ixon
shopt -s checkwinsize
umask 027

export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE="&:[]*:exit:ls:bg:fg:history:clear:pwd"
shopt -s histappend

export PS1="\u@\h:\$?:\W\\$ "
export EDITOR="vim"
export VISUAL="vim"

TMOUT=600
readonly TMOUT
export TMOUT

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

alias diff="diff --color"
alias wget="wget -c"
alias ps="ps auxf"
alias free="free -mlt"
alias df="df -Tah --total"
alias mount="mount | column -t"
alias du="du -ach | sort -h"
alias aka="alias -p | sed -e 's/^alias //g' | sort"
alias netstat="netstat -tunalp"
alias hexdump="hexdump -C"
alias od="od -A x -t x1z -v"

alias cd..="/bin/cd .."
alias sl="/bin/ls"
alias l="/bin/ls"

alias shutdown="sudo /sbin/shutdown -h now"
alias reboot="sudo /sbin/shutdown -r now"
