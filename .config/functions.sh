#!/usr/bin/env bash
# shell functions

function pingts() {
  # timestamped ping
  ping "$1" | xargs -L 1 -I '{}' date '+%H:%M:%S - {}'
}

function cheat() {
  # cheat.sh wrapper
  curl -s cheat.sh/"$1" | less -R
}

function git_branch() {
  branch=$(git branch --format='%(refname:short)' 2> /dev/null)
  if [[ $branch == "" ]]; then
    echo " "
  else
    echo ":$branch "
  fi
}
