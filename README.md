# dotfiles
My personal [minimalist] configuration files.  The main focus is in security and simplicity, so only known softwares are used hacks are avoided.


## Installation

```sh
cd  # go $HOME now
git clone https://github.com/lopes/dotfiles

cp -r dotifiles/.{bashrc,config,git,inputrc,local,screenrc,vimrc,xinitrc,zshrc} .
```


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

### Less, man
- `/sentence`: search for `sentence`

### i3
- `$mod-shift-q`: kill the current window
- `$mod-shift-e`: exit i3
- `$mod-shift-r`: reloads i3
- `$mod-enter`: open a new terminal
- `$mod-space`: open app launcher

> Some Vim commands can be combined to alter their behavior, for instance `d$` cut all characters from the cursor to the end of line.
