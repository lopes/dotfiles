# dotfiles
My personal, **minimalist** configuration files built on simplicity, security, and efficiency.


## Philosophy
1. **Layout**: Optimize screen space by removing superfluous elements.
2. **Colors**: Consistent GitHub Dark Dimmed colorscheme across all tools.
3. **Symbols**: Meaningful icons and glyphs via Nerd Fonts.
4. **Controls**: Streamlined shortcuts with vi-style navigation where it fits.
5. **Relevancy**: Only settings and tools that serve actual, practical usage.


## Packages
Install all dependencies before symlinking:

```sh
# cli tools
brew install bat eza fd fzf git-delta nano stow tmux vim zoxide \
  zsh-autosuggestions zsh-syntax-highlighting

# gui apps
brew install --cask aerospace ghostty obsidian raycast
```


## Quick Start
Create the required directory structure:

```sh
mkdir -p "$HOME/.cache/zsh" "$HOME/.local/bin" "$HOME/Projects"
```

Clone and symlink with [GNU Stow](https://www.gnu.org/software/stow/):

```sh
cd "$HOME/Projects"
git clone https://github.com/lopes/dotfiles
cd dotfiles
stow --verbose --adopt . --target="$HOME"
```


## Important Notes
- This process uses `stow --adopt`, which replaces existing files in your home directory with symlinks. Use `stow --simulate` first to preview changes.
- The `.gitignore` uses an allowlist: everything is ignored unless explicitly tracked with `git add -f`.

### Modern CLI Tools
These tools replace traditional Unix commands with faster, more ergonomic alternatives. All are themed with GitHub Dark Dimmed where applicable.

| Tool | Replaces | What it does | Configuration |
| :--- | :--- | :--- | :--- |
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax-highlighted file viewer with line numbers and git integration. | Theme set via `BAT_THEME` in `.zshenv`. Aliased as `cat` in `aliases.bsd.sh`. |
| [delta](https://github.com/dandavber/delta) | `git diff` | Syntax-highlighted diffs with line numbers. Automatically used by git as a pager. | Configured in `.config/git/config` under `[delta]`. |
| [eza](https://github.com/eza-community/eza) | `ls` | Modern file listing with icons, git status, and tree view. | Aliased as `ls`, `ll`, `la`, and `tree` in `aliases.bsd.sh`. |
| [fd](https://github.com/sharkdp/fd) | `find` | Faster file search with intuitive syntax. Respects `.gitignore` by default. | Aliased as `find` in `aliases.unix.sh`. |
| [fzf](https://github.com/junegunn/fzf) | `ctrl-r` | Fuzzy finder for shell history, files, and directories. | Initialized and themed in `.config/zsh/.zshrc`. Adds `ctrl-r` (history), `ctrl-t` (files), and `alt-c` (cd). |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Learns your most-used directories for instant jumping with `z`. | Initialized in `.config/zsh/.zshrc`. Use `z foo` to jump to the best match. |


## Shortcuts

### macOS
| Shortcut | Action |
| :--- | :--- |
| `cmd-space` | App launcher (Spotlight/Raycast) |
| `cmd-w/q` | Close/Quit application |
| `cmd-,` | Open application settings |
| `cmd-n` | New window, file, or tab |
| `cmd-shift-3/4/5` | Screenshots |
| `ctrl-1..0` | Move to Desktop 1-10 |
| `ctrl-left/right` | Move to previous/next Desktop |

### Zsh
| Shortcut | Action |
| :--- | :--- |
| `ctrl-c` | Kill foreground process |
| `ctrl-l` | Clear the screen |
| `ctrl-r` | Fuzzy search history (fzf) |
| `ctrl-t` | Fuzzy file finder (fzf) |
| `alt-c` | Fuzzy cd into subdirectory (fzf) |
| `ctrl-g` | Quits search history |
| `ctrl-u` | Clear the entire line |
| `ctrl-a` | Move to beginning of line |
| `ctrl-e` | Move to end of line |
| `alt-left` | Move to previous word |
| `alt-right` | Move to next word |
| `z <dir>` | Smart jump to directory (zoxide) |

### Ghostty
| Shortcut | Action |
| :--- | :--- |
| `cmd-alt-=` | Toggle quick terminal |
| `cmd-d` | Split horizontally |
| `cmd-shift-d` | Split vertically |

### Tmux
Prefix key: `ctrl-a`

| Shortcut | Action |
| :--- | :--- |
| `prefix r` | Reload configuration |
| `prefix c` | Create window |
| `prefix -` | Split pane vertically |
| `prefix \` | Split pane horizontally |
| `prefix tab` | Toggle last window |
| `prefix 1..9` | Select window |
| `prefix [hjkl]` | Navigate panes (vi-style) |
| `prefix [HJKL]` | Resize panes |
| `prefix x` | Kill pane |
| `prefix q` | Kill window |
| `prefix [` | Enter copy mode |
| `v` | Begin selection (copy mode) |
| `y` | Copy selection (copy mode) |
| `prefix ]` | Paste clipboard |

### Aerospace
| Shortcut | Action |
| :--- | :--- |
| `cmd-1..5` | Switch workspaces |
| `cmd-alt-1..5` | Move window to workspace |
| `cmd-alt-[hjkl]` | Move window left/down/up/right |
| `cmd-ctrl-[hjkl]` | Focus window left/down/up/right |
| `cmd-alt-enter` | Launch terminal |
| `cmd-alt-[-/=]` | Resize window |
| `cmd-ctrl-;` | Enter service mode |

### Obsidian
| Shortcut | Action |
| :--- | :--- |
| `cmd-p` | Open command palette |
| `cmd-e` | Toggle edit/reading view |
| `cmd-option-i` | Show console |
| `cmd-option-up` | Add cursor above |
| `cmd-option-down` | Add cursor below |
| `cmd-click` | Open file in a new tab |
| `cmd-\` | Split right |
| `cmd-[` | Toggle left sidebar |
| `cmd-]` | Toggle right sidebar |

### Nano
| Shortcut | Action |
| :--- | :--- |
| `ctrl-s` | Save |
| `ctrl-x` | Exit |
| `ctrl-k` | Cut the entire line |
| `ctrl-u` | Paste (uncut) |
| `alt-u` | Undo |
| `alt-e` | Redo |
| `ctrl-w` | Search |
| `ctrl-\` | Search and replace |

### Vim
| Shortcut | Action |
| :--- | :--- |
| `ctrl-s` | Save (normal/insert mode) |
| `leader-w` | Save |
| `leader-q` | Quit |
| `dd` | Cut the entire line |
| `yy` | Copy the entire line |
| `p` | Paste copied text |
| `u` | Undo |
| `ctrl-r` | Redo |
| `gg/G` | Beginning/End of file |
| `^/$` | Beginning/End of line |
| `/pattern` | Search |
| `esc` | Clear search highlight |
