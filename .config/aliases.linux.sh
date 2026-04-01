# linux-friendly aliases

source ${HOME}/.config/aliases.unix.sh

alias ls="ls --color=auto -lhF"
alias ll="ls -alF"
alias la="ls -A"

alias grep="grep --color=auto"

alias ifconfig="ip address"
alias route="ip route"
alias arp="ip neighbor"
alias netstat="ss"
alias mtr="mtr -ny 0"
alias httptest="curl -Lso /dev/null -w 'status-code: %{http_code}\n'"
alias httping="httping --timestamp -zlY --threshold-red 900 --threshold-yellow 400"
alias ufwlogs="journalctl --follow | grep -i -e \"ufw\" -e \"src=[0-9A-Fa-f:.]\+\" -e \"dpt=[0-9]\+\""
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"

alias diff="diff --color"
alias wget="wget -c"
alias ps="ps auxf"
alias free="free -mlt"
alias df="df -Tah --total"
alias mount="mount | column -t"
alias du="du -ah"
alias sha="sha256sum"
alias sniff="sudo tcpdump -nn -i eth0"
alias od="od -A x -t x1z -v"
alias vi="vim"

alias sudo="nocorrect sudo"
alias shutdown="sudo shutdown"
alias reboot="sudo reboot"

alias update-system="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"


