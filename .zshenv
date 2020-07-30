ZDOTDIR="$HOME/.config/zsh"
HISTFILE="$HOME/.local/cache/zsh/history"
SAVEHIST=15000
HISTSIZE=2000
PROMPT='%F{red}%(?..%? )%f%n%F{240}@%f%m%F{240} %40<..<%2~%<< %#%f '

TMOUT=600
readonly TMOUT
export TMOUT

export EDITOR="vim"
export VISUAL="vim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOADS_DIR="$HOME/Downloads"
export XDG_MOVIES_DIR="$HOME/Movies"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"

