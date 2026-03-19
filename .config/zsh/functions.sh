# shell functions

function pingts() {
  # timestamped ping
  ping "$1" | xargs -I '{}' date '+%H:%M:%S - {}'
}

function cheat() {
  # cheat.sh wrapper
  curl -s cheat.sh/"$1" | less -R
}
