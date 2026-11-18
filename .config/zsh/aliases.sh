#!/bin/sh
# shell aliases

alias aka="alias | grep"

alias ..="cd .."
alias ...="cd ../.."

alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -pv"

alias cd..="\cd .."
alias dc="\cd"
alias sl="\ls"
alias l="ls"
alias ls="ls --color=auto -lhF --group-directories-first"
alias ll="ls --color=auto -lAhF --group-directories-first"
alias la="ls --color=auto -A"

alias path='echo $PATH | tr ":" "\n"'
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias serve="python3 -u -c 'import argparse, functools, http.server as s; ap = argparse.ArgumentParser(prog=\"serve\"); ap.add_argument(\"port\", nargs=\"?\", type=int, default=1313); ap.add_argument(\"-d\", \"--directory\", default=\".\"); ap.add_argument(\"-b\", \"--bind\", default=\"127.0.0.1\"); a = ap.parse_args(); h = s.SimpleHTTPRequestHandler; h.extensions_map.update({\".md\": \"text/markdown\", \".markdown\": \"text/markdown\", **{e: \"text/plain\" for e in (\".yaml\", \".yml\", \".toml\", \".log\", \".sh\")}}); _gt = h.guess_type; h.guess_type = lambda self, p: (t := _gt(self, p)) + (\"; charset=utf-8\" if \"charset=\" not in t and (t.startswith(\"text/\") or t == \"application/json\") else \"\"); h.end_headers = lambda self: (self.send_header(\"Cache-Control\", \"no-store\"), s.BaseHTTPRequestHandler.end_headers(self)); s.test(HandlerClass=functools.partial(h, directory=a.directory), port=a.port, bind=a.bind)'"
alias reload='exec "$SHELL" -l'

alias grep="grep --color=auto"
alias diff="diff --color"
alias wget="wget -c"
alias psa="ps auxf"
alias free="free -mlt"
alias df="df -Tah --total"
alias mount="mount | column -t"
alias du="du -ah"
alias sha="sha256sum"
alias vi="vim"
alias tmux0="tmux new -As0"

[ -n "$ZSH_VERSION" ] && alias sudo="nocorrect sudo"

alias update-system='make -C "$HOME/Projects/dotfiles" update'
