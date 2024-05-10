# bsd-friendly aliases

alias sh="zsh"

alias ls="ls -GlhF"
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

alias ga="git add"
alias gb="git branch"
alias gc="git commit --verbose"
alias gcf="git config --list"
alias gd="git diff"
alias glo="git log --oneline --decorate --graph --all"
alias gls="git ls-files"
alias gs="git status"

alias myippub="dig +short myip.opendns.com @resolver1.opendns.com"
alias myippri="ipconfig getifaddr en0"

alias pwgen="openssl rand -base64 256 | tr -d '\n' | head -c"
alias pyvenv="{[ ! -d "venv" ] && python3 -m venv venv}; source venv/bin/activate"
alias aka="alias | grep"
