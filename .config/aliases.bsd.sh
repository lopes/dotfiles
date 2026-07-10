# bsd-friendly aliases

source ${HOME}/.config/aliases.unix.sh

alias ls="gls --color=auto -lhF --group-directories-first"
alias ll="gls --color=auto -lAhF --group-directories-first"
alias la="gls --color=auto -A"

alias diff="diff --color"
alias wget="wget -c"
alias ps="ps aux"
alias free="vm_stat"
alias df="df -ah"
alias mount="mount | column -t"
alias du="du -ah"
alias vi="vim"

alias update-system="brew update && brew upgrade && brew upgrade --cask && brew cleanup"

alias myip="ipconfig getifaddr en0 && dig +short txt ch whoami.cloudflare @1.0.0.1"

alias missing="grep -v -F -x -f" # usage: missing f1 f2 -> lines in f2 and not in f1

alias sha="shasum -a 256"
alias sniff="sudo tcpdump -nn -i en0"

alias caffeinate="caffeinate -isd" # stay awake while running
