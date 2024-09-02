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

alias zas="brew"
alias zasi="brew install"
alias zasr="brew uninstall"
alias zass="brew search"
alias zasu="brew update && brew upgrade && brew upgrade --cask && brew cleanup"

alias myip="ipconfig getifaddr en0 && dig +short txt ch whoami.cloudflare @1.0.0.1"

alias pwgen="openssl rand -base64 256 | tr -d '\n' | head -c"
alias pyvenv="{[ ! -d "venv" ] && python3 -m venv venv}; source venv/bin/activate"

alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"  # docker on macOS
