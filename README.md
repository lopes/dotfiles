# dotfiles
My personal **minimalist** configuration files.  The main focus is in security and simplicity, so only known softwares are used hacks are avoided.

This setup puts the `~/.local/bin` directory in the system's path, thus the user is able to put scripts and programs there and call them anywhere.


## Installation

```sh
cd  # go $HOME
git clone https://github.com/lopes/dotfiles
\cp -rf dotfiles/.{config,screenrc,vimrc,zshenv} .
mkdir -p .cache/zsh .local/bin
```

> The backslash disables any aliases when preceeds a command.


## Shortcuts
Just documenting some shortcuts of my daily use.

### Zsh
- `control-c`: kill foreground process
- `control-l`: clear the screen
- `control-r`: search history
- `control-g`: quits search history
- `control-u`: clear the entire line
- `control-a`: go to the begining of the line
- `control-e`: go to the end of the line

### Micro
- `control-s`: save
- `control-q`: exit
- `control-k`: cut the entire line
- `control-c`: copy
- `control-v`: paste
- `control-z`: undo changes
- `control-y`: redo changes

### Vim
- `:wq`: save and exit
- `:q!`: exit without save
- `dd`: cut the entire line
- `yy`: copy the entire line
- `yw`: copy the word under the cursor
- `p`: paste copied text
- `u`: undo changes
- `control-r`: redo changes
- `shift-g`: go to the end of file
- `gg`: go to the begining of file
- `$`: go to the end of line
- `^`: go to the begining of line
- `g~w`: toggle the case for word under cursor
- `control-v`: go to visual mode - `esc` to exit

> Some Vim commands can be combined to alter their behavior, for instance `d$` cut all characters from the cursor to the end of line.

### Less, man
- `/sentence`: search for `sentence`

### i3
- `$mod-shift-q`: kill the current window
- `$mod-shift-e`: exit i3
- `$mod-shift-r`: reloads i3
- `$mod-enter`: open a new terminal
- `$mod-space`: open app launcher


## Termux
Install basic packages, make sure that `zsh` is the default shell, and then follow the instructions above to install dotfiles.

```sh
pkg install zsh git man
chsh -s zsh
```

### Shortcuts
- `Vol.Up-k`: shows or hides extra keys
- `Vol.Up-q`: just like `Vol.Up-k``
- `Vol.Up-t`: tab key
- `Vol.Up-e`: escape key
- `Vol.Up-w`: up arrow key
- `Vol.Up-a`: left arrow key
- `Vol.Up-s`: down arrow key
- `Vol.Up-d`: right arrow key
- `Vol.Up-h`: tilde key
