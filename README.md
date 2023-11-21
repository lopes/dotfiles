# dotfiles
My personal **minimalist** configuration files.  The main focus is in security and simplicity, so only known softwares are used and hacks are avoided.

This setup puts the `~/.local/bin` directory in the system's path, thus the user is able to put scripts and programs there and call them anywhere.


## Installation
```sh
cd  # go $HOME
git clone https://github.com/lopes/dotfiles
\cp -rf dotfiles/.{config,screenrc,vimrc,zshenv} ~
mkdir -p .cache/zsh .local/bin
```

> The backslash disables any aliases when preceeds a command.


## Shortcuts
Just documenting some shortcuts of my daily use.

### Zsh
- `control-c`: Kill foreground process
- `control-l`: Clear the screen
- `control-r`: Search history
- `control-g`: Quits search history
- `control-u`: Clear the entire line
- `control-a`: Go to the begining of the line
- `control-e`: Go to the end of the line

### Micro
- `control-s`: Save
- `control-q`: Exit
- `control-k`: Cut the entire line
- `control-c`: Copy
- `control-v`: Paste
- `control-z`: Undo changes
- `control-y`: Redo changes

### Vim
- `:wq`: Save and exit
- `:q!`: Exit without save
- `dd`: Cut the entire line
- `yy`: Copy the entire line
- `yw`: Copy the word under the cursor
- `p`: Paste copied text
- `u`: Undo changes
- `control-r`: Redo changes
- `shift-g`: Go to the end of file
- `gg`: Go to the begining of file
- `$`: Go to the end of line
- `^`: Go to the begining of line
- `g~w`: Toggle the case for word under cursor
- `control-v`: Go to visual mode - `esc` to exit

> Some Vim commands can be combined to alter their behavior, for instance `d$` cut all characters from the cursor to the end of line.

### Less, man
- `/sentence`: Search for `sentence`

### i3
- `$mod-shift-q`: Kill the current window
- `$mod-shift-e`: Exit i3
- `$mod-shift-r`: Reloads i3
- `$mod-enter`: Open a new terminal
- `$mod-space`: Open app launcher


## Termux
Install basic packages, make sure that `zsh` is the default shell, and then follow the instructions above to install dotfiles.

```sh
pkg install zsh git man
chsh -s zsh
```

### Shortcuts
- `Vol.Up-k`: shows or hides extra keys
- `Vol.Up-q`: just like `Vol.Up-k`
- `Vol.Up-t`: tab key
- `Vol.Up-e`: escape key
- `Vol.Up-w`: up arrow key
- `Vol.Up-a`: left arrow key
- `Vol.Up-s`: down arrow key
- `Vol.Up-d`: right arrow key
- `Vol.Up-h`: tilde key
