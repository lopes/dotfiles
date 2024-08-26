# dotfiles
My personal **minimalist** configuration files.  The main focus is in security and simplicity, so only known softwares are used and hacks are avoided.


## Requirements
I use the following directories to better organize my work:

- `$HOME/Projects`: Ongoing project files and folders
- `$HOME/.local/bin`: Standalone binaries, sourced by `$PATH`

>[!NOTE]
>See `.zshenv` for more information on directories.

Besides the directories, I configure Zsh to source [auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) for a better experience.  But if these packages are not installed, nothing should happen.

Finally, I use and recommend [GNU Stow](https://www.gnu.org/software/stow/) for managing dotfiles and it can be easily installed with most package managers around there.


## Installation
First, make sure the needed directories are in place:

```sh
cd
mkdir -p .cache/zsh .local/bin Projects
```
Now, proceed with installation:

```sh
cd  Projects
git clone https://github.com/lopes/dotfiles
cd dotfiles
stow --verbose --adopt . --target=$HOME
```

>[!WARNING]
>The previous snippet considers a fresh install.  If you have any configurations in place, use it with caution because the `--adopt` will replace these files by your current ones.

>[!NOTE]
>GNU Stow allows you to simulate an installation with the `--simulate` option.

>[!IMPORTANT]
>Git ignores all files but the ones explicitly declared in `.gitignore` file.  To track new files, they must be added with: `git add -f PATH`.


## Shortcuts
Some shortcuts of my daily use.

### macOS
| Shortcut | Action |
|---|---|
| `cmd-space` | App launcher |
| `cmd-w/q` | Close/Quit application |
| `cmd-,` | Open settings |
| `cmd-n` | New window/file/... |
| `cmd-shift-3/4/5` | Screenshots |
| `control-1..0` | Move to Desktop 1-10 |
| `control-left/right` | Move to previous/next Desktop |

>[!NOTE]
>A comprehensive list of macOS shortcuts can be found [here](https://support.apple.com/en-us/102650).

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

### Alacritty
| Shortcut | Action |
|---|---|
| `control-shift-space` | Toggle Vi mode |

### Aerospace
See `.config/aerospace/aerospace.toml` for the full list.
| Shortcut | Action |
|---|---|
| `cmd-1..5` | Switch workspaces |
| `cmd-alt-1..5` | Move windows to workspace |
| `cmd-alt-[hjkl]` | Move windows to left/down/up/right |
| `cmd-control-[hjkl]` | Change windows focus to left/down/up/right |
| `cmd-alt-enter` | Launch terminal |

### Obsidian
| Shortcut | Action |
|---|---|
| `cmd-p` | Open command palette |
| `cmd-e` | Toggle edit/reading view |
| `cmd-option-i` | Show console |
| `cmd-option-up` | Add cursor above |
| `cmd-option-down` | Add cursor below |
| `cmd-click` | Open file in a new tab |
| `cmd-\` |  Split right |
| `cmd-[` | Toggle left sidebar |
| `cmd-]` | Toggle right sidebar |


### VSCode
| Shortcut | Action |
|---|---|
| `cmd-p` | Open the Command Palette |
| `cmd-b` | Toggle Sidebar |
| `cmd-\` |  Split right |
| `control-tab` | Show active tabs |

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

>[!INFO]
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
