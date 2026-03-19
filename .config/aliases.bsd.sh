# bsd-friendly aliases

source ${HOME}/.config/aliases.unix.sh

alias ls="ls --color=auto -lhF"
alias ll="ls -alF"
alias la="ls -A"

alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias diff="diff --color"
alias gdiff="git diff"
alias wget="wget -c"
alias ps="ps aux"
alias free="vm_stat"
alias df="df -ah"
alias mount="mount | column -t"
alias du="du -ach | sort -h"
alias vi="vim"

alias sudo="nocorrect sudo"

alias pkg="brew"
alias pkgi="brew install"
alias pkgr="brew uninstall"
alias pkgs="brew search"
alias pkgu="brew update && brew upgrade && brew upgrade --cask && brew cleanup"

alias myip="ipconfig getifaddr en0 && dig +short txt ch whoami.cloudflare @1.0.0.1"

alias pwgen="openssl rand -base64 256 | tr -d '\n' | head -c"
alias missing="grep -v -F -x -f" # usage: missing f1 f2 -> lines in f2 and not in f1

alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"  # docker on macOS

alias caffeinate="caffeinate -isud" # stay awake no matter what
