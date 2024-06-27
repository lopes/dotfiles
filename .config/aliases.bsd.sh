# bsd-friendly aliases

source ${HOME}/.config/aliases.unix.sh

alias ls="ls -GlhF"
alias ll="ls -alF"
alias la="ls -A"

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

alias sudo="nocorrect sudo"
alias shutdown="shutdown"
alias reboot="reboot"

alias pkg_update="brew update && brew upgrade && brew upgrade --cask && brew cleanup"  # update
alias pkg_search="brew search"                  # search
alias pkg_install="brew install"                 # install
alias pkg_uninstall="brew uninstall"               # remove

alias myippub="dig +short myip.opendns.com @resolver1.opendns.com"
alias myippri="ipconfig getifaddr en0"

alias pwgen="openssl rand -base64 256 | tr -d '\n' | head -c"
alias pyvenv="{[ ! -d "venv" ] && python3 -m venv venv}; source venv/bin/activate"
