# general unix aliases

alias aka="alias | grep"

alias p="pwd"
alias g="git"
alias ..="cd .."
alias ...="cd ../.."

alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

alias cd..="\cd .."
alias sl="\ls"
alias l="ls"

alias path='echo $PATH | tr ":" "\n"'
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias reload="exec $SHELL -l"

alias tx="tmux new -As "󰁞""

# security & file analysis
alias hexdump="hexdump -C"
alias strings="strings -a"
alias classify="file -b"
alias headers="curl -sI"
alias b64e="base64"
alias b64d="base64 -d"
alias urldecode='python3 -c "import sys,urllib.parse;print(urllib.parse.unquote(sys.argv[1]))"'
alias tcpdump="sudo tcpdump -nn"
alias fhash="ssdeep"
alias metadata="exiftool"
alias extract="binwalk -e"
alias 7z="7za"

# log & data analysis
alias less="less -RNS"
alias jl="jq -C . | less -R"
alias gj="gron"
alias csv="mlr --csv"
alias tsv="mlr --tsv"
