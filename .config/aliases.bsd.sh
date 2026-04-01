# bsd-friendly aliases

source ${HOME}/.config/aliases.unix.sh

alias ls="eza -lh --group-directories-first --icons=auto --git"
alias ll="eza -lah --group-directories-first --icons=auto --git"
alias la="eza -a --group-directories-first --icons=auto"
alias tree="eza --tree --level=3 --icons=auto"

alias grep="grep --color=auto"

alias cat="bat --paging=never"
alias diff="diff --color"
alias wget="wget -c"
alias ps="ps aux"
alias free="vm_stat"
alias df="df -ah"
alias mount="mount | column -t"
alias du="du -ah"
alias vi="vim"

alias sudo="nocorrect sudo"

alias update-system="brew update && brew upgrade && brew upgrade --cask && brew cleanup"

alias myip="ipconfig getifaddr en0 && dig +short txt ch whoami.cloudflare @1.0.0.1"

alias missing="grep -v -F -x -f" # usage: missing f1 f2 -> lines in f2 and not in f1

alias sha="shasum -a 256"
alias sniff="sudo tcpdump -nn -i en0"

alias caffeinate="caffeinate -isud" # stay awake no matter what
