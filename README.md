# dotfiles
My personal **minimalist** configuration files.  The main focus is in security and simplicity, so only known softwares are used and hacks are avoided.

This setup puts the `~/.local/bin` directory in the system's path, thus the user is able to put scripts and programs there and call them anywhere.


## Installation
```sh
cd  # go $HOME
git clone https://github.com/lopes/dotfiles
\cp -rf dotfiles/.{config,screenrc,vimrc,zshenv} ~
mkdir -p .cache/zsh .local/bin ~/Projects
```

> Backslash disables any aliases when preceeds a command.

## Requirements
Zsh requires the auto-suggestion and syntax-highlighting packages:

```sh
brew install zsh-autosuggestions zsh-syntax-highlighting
```


## Shortcuts
Some shortcuts of my daily use.

### macOS
| Shortcut | Action |
|---|---|
| `cmd-space` | App launcher |
| `cmd-w/q` | Close/Quit application |
| `cmd-n` | New window/file/... |
| `cmd-shift-3/4/5` | Screenshots |
| `control-1..0` | Move to Desktop 1-10 |
| `control-left/right` | Move to previous/next Desktop |

### Zsh
| Shortcut | Action |
|---|---|
| `control-c` | Kill foreground process |
| `control-l` | Clear the screen |
| `control-r` | Search history |
| `control-g` | Quits search history |
| `control-u` | Clear the entire line |
| `control-a`: | Beginning of line |
| `control-e` | End of line |
| `alt-left` | Previous word |
| `alt-right` | Next word |

### Yabai (Skhd)
See `.config/skhd/skhdrc` for the full list.
| Shortcut | Action |
|---|---|
| `control-alt-o` | Rotate layout |
| `control-alt-b` | Rebalance layout |
| `control-alt-\` | Toggle window float |
| `control-alt-1..0` | Move window to space 1-10 |
| `control-alt-r` | Restart Yabai |

### Micro
| Shortcut | Action |
|---|---|
| `control-s` | Save |
| `control-q` | Exit |
| `control-k` | Cut the entire line |
| `control-c` | Copy |
| `control-v` | Paste |
| `control-z` | Undo changes |
| `control-y` | Redo changes |

### Vim
| Shortcut | Action |
|---|---|
| `:wq` | Save and exit |
| `:q!` | Exit without save |
| `dd` | Cut the entire line |
| `yy` | Copy the entire line |
| `yw` | Copy the word under the cursor |
| `p` | Paste copied text |
| `u` | Undo changes |
| `control-r` | Redo changes |
| `shift-g` | End of file |
| `gg` | Begining of file |
| `$` | End of line |
| `^` | Begining of line |
| `g~w` | Toggle the case for word under cursor |
| `control-v` | Go to visual mode - `esc` to exit |
| `/sentence` | Search for `sentence` - works in other tools, like `less` and `man` |

> Some Vim commands can be combined to alter their behavior, for instance `d$` cut all characters from the cursor to the end of line.


## Termux (Android)
Install basic packages, make sure that `zsh` is the default shell, and then follow the instructions above to install dotfiles.

```sh
pkg install zsh git man
chsh -s zsh
```

### Shortcuts
| Shortcut | Action |
|---|---|
| `Vol.Up-k` | Shows/Hides extra keys |
| `Vol.Up-q` | Just like `Vol.Up-k` |
| `Vol.Up-t` | Tab |
| `Vol.Up-e` | Escape |
| `Vol.Up-w` | Up arrow |
| `Vol.Up-a` | Left arrow |
| `Vol.Up-s` | Down arrow |
| `Vol.Up-d` | Right arrow |
| `Vol.Up-h` | Tilde |
