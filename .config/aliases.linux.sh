# linux-friendly aliases

alias sh="zsh"

alias ls="ls --color=auto -lhF"
alias ll="ls -alF"
alias la="ls -A"

alias p="pwd"
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."
alias .6="cd ../../../../../.."

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
alias httping="httping --timestamp -zlY --threshold-red 900 --threshold-yellow 400"
alias ufwlogs="journalctl --follow | grep -i -e  \"ufw\" -e \"src=[0-9]\.A-F:]\+\" -e \"dpt=[0-9]\+\""
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"

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

alias pkgu="sudo pacman -Syu"  # update
alias pkgs="sudo pacman -Ss"   # search
alias pkgi="sudo pacman -S"    # install
alias pkgr="sudo pacman -Rs"   # remove

alias ga="git add"
alias gb="git branch"
alias gc="git commit --verbose"
alias gcf="git config --list"
alias gd="git diff"
alias glo="git log --oneline --decorate --graph --all"
alias gls="git ls-files"
alias gs="git status"

alias pwgen="openssl rand -base64 256 | tr -d '\n' | head -c"
alias pyvenv="{[ ! -d "venv" ] && python3 -m venv venv}; source venv/bin/activate"
alias aka="alias | grep"
