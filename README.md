# dotfiles
My personal, **minimalist** configuration files. These dotfiles are built on a core philosophy of simplicity, security, and efficiency to enhance the user experience without unnecessary bloat.


## Philosophy
This project is guided by the following principles:

1. **Layout**: Optimize screen space and accessibility by removing superfluous elements.
2. **Colors**: Apply consistent, visually appealing color schemes for clarity.
3. **Symbols**: Use meaningful icons and glyphs for better readability and quick recognition.
4. **Controls**: Streamline shortcuts and inputs to maximize efficiency.
5. **Relevancy**: Only include settings and tools that align with actual, practical usage.


## Quick Start
Before installing, ensure the following directory structure exists. This is crucial for the configurations to function correctly.

```sh
mkdir -p "$HOME/.cache/zsh" "$HOME/.local/bin" "$HOME/Projects"
```

The configurations here require [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks. If you don't have it, you can install it via your system's package manager.

```sh
# macOS
brew install stow

# Linux (Arch)
sudo pacman -S stow
```

With Stow installed, clone the repository into your `$HOME/Projects` directory and run the install command.

```sh
cd "$HOME/Projects"
git clone https://github.com/lopes/dotfiles
cd dotfiles
stow --verbose --adopt . --target="$HOME"
```


## Important Notes
- This process uses `stow --adopt`, which will replace existing configuration files in your home directory with symlinks to the files in this repository. Use `stow --simulate` first to preview the changes and avoid data loss.
- The `.gitignore` file is configured to ignore all files unless they are explicitly added with git add `-f`. This ensures you only track the exact files you want to manage.


## Shortcuts
This is a quick reference for the most important shortcuts and keybindings. Tables are organized by application or environment for quick lookups.

### macOS
A list of essential macOS shortcuts that are either defined here or are highly used.

| Shortcut | Action |
| :---- | :---- |
| `cmd-space` | App launcher (Spotlight/Raycast) |
| `cmd-w/q` | Close/Quit application |
| `cmd-,` | Open application settings |
| `cmd-n` | New window, file, or tab |
| `cmd-shift-3/4/5` | Screenshots |
| `ctrl-1..0` | Move to Desktop 1-10 |
| `ctrl-left/right` | Move to previous/next Desktop |

### Zsh
Shortcuts for the Zsh shell to improve command-line efficiency.

| Shortcut | Action |
| :---- | :---- |
| `ctrl-c` | Kill foreground process |
| `ctrl-l` | Clear the screen |
| `ctrl-r` | Search history |
| `ctrl-g` | Quits search history |
| `ctrl-u` | Clear the entire line |
| `ctrl-a` | Move to beginning of line |
| `ctrl-e` | Move to end of line |
| `alt-left` | Move to previous word |
| `alt-right` | Move to next word |

### Ghostty
A modern, fast, and minimalist terminal emulator.

| Shortcut | Action |
| :---- | :---- |
| `cmd-d` | Split horizontally |
| `cmd-shift-d` | Split vertically |

### Tmux
A terminal multiplexer that allows for multiple sessions, windows, and panes within a single terminal window.

| Shortcut | Action |
| :---- | :---- |
| `ctrl-a` | Prefix key |
| `ctrl-a r` | Reload configuration |
| `ctrl-a s` | Split horizontally |
| `ctrl-a f` | Split vertically |
| `ctrl-a 1..0` | Select window |
| `ctrl-a n` | Next window |
| `ctrl-a p` | Previous window |
| `ctrl-a c` | Create window |
| `ctrl-a x` | Kill pane |
| `ctrl-a k` | Kill window |

### Aerospace
A powerful and user-friendly macOS window manager.

| Shortcut | Action |
| :---- | :---- |
| `cmd-1..5` | Switch workspaces |
| `cmd-alt-1..5` | Move windows to workspace |
| `cmd-alt-[hjkl]` | Move windows to left/down/up/right |
| `cmd-ctrl-[hjkl]` | Change windows focus to left/down/up/right |
| `cmd-alt-enter` | Launch terminal |

### Obsidian
A powerful and flexible knowledge base for notes.

| Shortcut | Action |
| :---- | :---- |
| `cmd-p` | Open command palette |
| `cmd-e` | Toggle edit/reading view |
| `cmd-option-i` | Show console |
| `cmd-option-up` | Add cursor above |
| `cmd-option-down` | Add cursor below |
| `cmd-click` | Open file in a new tab |
| `cmd-\` | Split right |
| `cmd-[` | Toggle left sidebar |
| `cmd-]` | Toggle right sidebar |

### Micro
A terminal-based text editor with intuitive keybindings and mouse support.

| Shortcut | Action |
| :---- | :---- |
| `ctrl-s` | Save |
| `ctrl-q` | Exit |
| `ctrl-k` | Cut the entire line |
| `ctrl-c` | Copy |
| `ctrl-v` | Paste |
| `ctrl-z` | Undo changes |
| `ctrl-y` | Redo changes |

### Vim
A highly configurable text editor for efficient text editing.

| Shortcut | Action |
| :---- | :---- |
| `:wq` | Save and exit |
| `:q!` | Exit without saving |
| `dd` | Cut the entire line |
| `yy` | Copy the entire line |
| `yw` | Copy the word under the cursor |
| `p` | Paste copied text |
| `u` | Undo changes |
| `ctrl-r` | Redo changes |
| `shift-g` | End of file |
| `gg` | Beginning of file |
| `$` | End of line |
| `^` | Beginning of line |
| `g~w` | Toggle case of the word under the cursor |
| `ctrl-v` | Enter visual mode |
| `/sentence` | Search for sentence |
