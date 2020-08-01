export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Laboratory"
export XDG_PUBLICSHARE_DIR="$HOME/Shares"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export XINITRC="$XDG_CONFIG_HOME/X11"

TMOUT=600
readonly TMOUT
export TMOUT

export KEYTIMEOUT=1  # used in zsh vi mode

export EDITOR="vim"
export VISUAL="vim"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_CACHE_HOME/zsh/zhistory"
export SAVEHIST=15000
export HISTSIZE=2000
export PROMPT='%F{red}%(?..%? )%f%n%F{240}@%f%m%F{240} %40<..<%2~%<< %#%f '

