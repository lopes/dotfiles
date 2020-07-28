# dotfiles
My personal [minimalist] configuration files.


## Installation

```sh
cd $HOME
git clone https://github.com/lopes/dotfiles
cd dotfiles

DOTFILES=".config .local .zshrc .bashrc .gitconfig .inputrc .screenrc .vimrc"
BKP="$HOME/.dotfiles.bkp"

mkdir -p "$BKP"
for f in $FILES; do
    test -f "$HOME/$f" && mv -fv "$_" "$BKP"
done
test -z "$(ls $BKP)" && rm -rf "$BKP"

for f in $FILES; do
    cp "./$f" "$HOME/$f"
done
cd .. && rm -rf dotfiles
```


## Fonts
This repository comes with some fonts I like to use.  You can install them by moving the `.local` directory to your HOME and running the command below.

```sh
fc-cache -f -v
```

You may need to reload your terminal for the changes make effect.  To test the font use the command below.

```sh
echo "The quick brown fox jumps over the lazy dog" | pango-view --font="Cascadia Code" /dev/stdin
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
