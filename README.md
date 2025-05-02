# dotfiles
My personal **minimalist** configuration files. The main focus is on security and simplicity, so only trusted software is used, and hacks are avoided.

These configurations enhance the user experience through a minimalist approach in the following aspects:

1. **Layout**: Optimize space and accessibility by removing unnecessary elements.
2. **Colors**: Apply consistent, visually appealing color schemes.
3. **Symbols**: Use meaningful icons/glyphs for better readability.
4. **Controls**: Streamline shortcuts and inputs for efficiency.
5. **Relevancy**: Only include settings that align with actual usage.


## Requirements
Configurations here require the following directories:
- `$HOME/Projects`: Ongoing project files and folders
- `$HOME/.local/bin`: Standalone binaries, sourced by `$PATH`

>[!NOTE]
>See `.zshenv` for more information on directories.

Zsh plugins for a better experience--optional but recommended:
- [auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)


## Installation
Start by creating the necessary directories:

```sh
cd
mkdir -p .cache/zsh .local/bin Projects
```

Use [GNU Stow](https://www.gnu.org/software/stow/) to install--files will be kept under `~/Projects/dotfiles` and links will be created in your home directory.

```sh
cd  Projects
git clone https://github.com/lopes/dotfiles
cd dotfiles
stow --verbose --adopt . --target=$HOME
```

>[!WARNING]
>The previous snippet considers a fresh install.  If you have any configurations in place, use it with caution because the `--adopt` will replace these files by your current ones.  If in doubt, use `--simulate` to preview the changes.

>[!IMPORTANT]
>The configuration here will make Git ignore all files but the ones explicitly declared in `.gitignore` file.  To track new files, they must be added with: `git add -f PATH`.


## Shortcuts
Important shortcuts defined here or highly used.  Some of them are macOS specific.

### macOS
| Shortcut | Action |
|---|---|
| `cmd-space` | App launcher |
| `cmd-w/q` | Close/Quit application |
| `cmd-,` | Open settings |
| `cmd-n` | New window/file/... |
| `cmd-shift-3/4/5` | Screenshots |
| `ctrl-1..0` | Move to Desktop 1-10 |
| `ctrl-left/right` | Move to previous/next Desktop |

>[!NOTE]
>A comprehensive list of macOS shortcuts can be found [here](https://support.apple.com/en-us/102650).

### Zsh
| Shortcut | Action |
|---|---|
| `ctrl-c` | Kill foreground process |
| `ctrl-l` | Clear the screen |
| `ctrl-r` | Search history |
| `ctrl-g` | Quits search history |
| `ctrl-u` | Clear the entire line |
| `ctrl-a`: | Beginning of line |
| `ctrl-e` | End of line |
| `alt-left` | Previous word |
| `alt-right` | Next word |

### Ghostty
| Shortcut | Action |
|---|---|
| `cmd-d` | Split horizontally |
| `cmd-shift-d` | Split vertically |

>[!NOTE]
>Run `ghostty +show-config --default --docs` for a comprehensive list of default configuration.

### Tmux
| Shortcut | Action |
|---|---|
| `ctrl-a` | Prefix key |
| `ctrl-a r` | Reload configuration |
| `ctrl-a s` | Split horizontally |
| `ctrl-a f` | Split vertically |
| `ctrl-a 1..0` | Select window |
| `ctrl-a n` | Next window |
| `ctrl-a p` | Previous window |
| `ctrl-a c` | Create window |
| `ctrl-a x` | Kill pane |
| `ctrl-a x` | Kill window |

### Aerospace
See `.config/aerospace/aerospace.toml` for the full list.
| Shortcut | Action |
|---|---|
| `cmd-1..5` | Switch workspaces |
| `cmd-alt-1..5` | Move windows to workspace |
| `cmd-alt-[hjkl]` | Move windows to left/down/up/right |
| `cmd-ctrl-[hjkl]` | Change windows focus to left/down/up/right |
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

### Micro
| Shortcut | Action |
|---|---|
| `ctrl-s` | Save |
| `ctrl-q` | Exit |
| `ctrl-k` | Cut the entire line |
| `ctrl-c` | Copy |
| `ctrl-v` | Paste |
| `ctrl-z` | Undo changes |
| `ctrl-y` | Redo changes |

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
| `ctrl-r` | Redo changes |
| `shift-g` | End of file |
| `gg` | Begining of file |
| `$` | End of line |
| `^` | Begining of line |
| `g~w` | Toggle the case for word under cursor |
| `ctrl-v` | Go to visual mode - `esc` to exit |
| `/sentence` | Search for `sentence` - works in other tools, like `less` and `man` |

>[!INFO]
> Some Vim commands can be combined to alter their behavior, for instance `d$` cut all characters from the cursor to the end of line.

### Termux (Android)
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
