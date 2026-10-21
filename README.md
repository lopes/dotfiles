# dotfiles

Minimalist Linux configuration files built around standard Unix tools, a consistent GitHub Dark Dimmed palette, and zero-copy symlink management.

## Philosophy
1. **Layout**: Remove superfluous UI elements to maximize screen space.
2. **Colors**: Consistent GitHub Dark Dimmed palette across shell, prompt, multiplexer, and editor.
3. **Symbols**: Standard JetBrains Mono and Unicode only (no patched Nerd Fonts required).
4. **Controls**: Intentional keyboard shortcuts with vi-style navigation where it fits.
5. **Relevancy**: Only track tools and settings used daily.

---

## Install & Update

### 1. Prerequisites (Debian / Linux)
```sh
sudo apt update && sudo apt install -y \
  zsh tmux vim fzf git-delta zsh-autosuggestions zsh-syntax-highlighting fonts-jetbrains-mono

# prompt binary (~/.local/bin/oh-my-posh)
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
```

### 2. Link Configurations
```sh
git clone https://github.com/lopes/dotfiles "$HOME/Projects/dotfiles"
cd "$HOME/Projects/dotfiles"
make install
make check
exec zsh -l
```

### 3. Managing the Repo
`make install` creates symlinks from `~/.config/<tool>` (plus `~/.zshenv`, `~/.ssh/config`, and `~/.gemini/config/`) directly into this repo. Editing either path edits the same file.

| Command | Action |
| :--- | :--- |
| `make install` | Create missing symlinks (skips existing links, warns on conflicts). |
| `make uninstall` | Remove managed symlinks without deleting repo files. |
| `make list` | Display all managed symlinks and their targets. |
| `make check` | Validate shell/git syntax, symlinks, SSH permissions, `.gitignore` parity, and sanitization. |

> [!IMPORTANT]
> `.gitignore` uses an **allowlist** (`*` ignores everything by default). When adding a new file, add a `!path` rule to `.gitignore`, stage it with `git add -f`, and run `make check`.

---

## Tool Notes & Non-Elementary Shortcuts

### Zsh & `fzf`
- **Startup split**: `.zshenv` sets environment variables for all processes (`XDG_*`, `PATH`, `EDITOR`, `ZDOTDIR`, `umask 027`, `LEDGER_FILE`). `.zshrc` runs only in interactive terminals.
- **Local secrets**: Untracked machine-specific overrides live in `~/.config/zsh/private.sh` (`chmod 600` enforced automatically).
- **Notable aliases**: `tmux0` (`tmux new -As0`), `psa` (`ps auxf` — avoids aliasing `ps` directly so system pre-exec hooks don't break), `ports` (listening TCP sockets), `reload` (`exec $SHELL -l`), `aka` (`alias | grep`).

| Shortcut | Action |
| :--- | :--- |
| `ctrl-r` | Fuzzy search command history (`fzf` — type words in any order) |
| `ctrl-t` | Fuzzy find file under current directory and insert path at cursor (`fzf`) |
| `alt-c` | Fuzzy find subdirectory and `cd` into it (`fzf`) |
| `**<tab>` | Trigger fuzzy completion for paths (`vim **<tab>`, `cd **<tab>`) |
| `ctrl-u` / `ctrl-k` | Kill line backward / forward |
| `alt-left` / `alt-right` | Jump word backward / forward |

### Tmux
Prefix key: **`ctrl-space`**

| Shortcut | Action |
| :--- | :--- |
| `alt-h/j/k/l` | Navigate panes left/down/up/right (no prefix needed) |
| `alt-1..5` | Jump to window 1–5 (no prefix needed) |
| `alt-n` / `alt-p` | Next / previous window (no prefix needed) |
| `prefix -` / `prefix \` | Split pane vertically / horizontally (in current path) |
| `prefix H/J/K/L` | Resize active pane (repeatable) |
| `prefix tab` | Toggle last active window |
| `prefix r` | Reload `tmux.conf` |
| `prefix [` | Enter vi copy mode (`v` select, `ctrl-v` block toggle, `y` copy, `prefix ]` paste) |

### Vim
- **State & Undo**: Persistent undo in `$XDG_CACHE_HOME/vim/undodir`; `viminfo` in `$XDG_STATE_HOME/vim/viminfo` (no swap/backup files).
- **Ledger completion**: In `*.journal` files, `:` is part of `iskeyword` so `ctrl-n` / `ctrl-p` autocompletes full `hledger` account paths (`expenses:food:groceries`).

| Shortcut | Action |
| :--- | :--- |
| `ctrl-s` / `leader-w` | Save buffer |
| `leader-q` | Quit window |
| `esc` | Clear search highlight (`:noh`) |

### Git & SSH
- **Dual Ed25519 SSH keys**:
  - `~/.ssh/github_ed25519` (*passphrase-protected*): Authentication key for `github.com`.
  - `~/.ssh/github_signing_ed25519` (*passphrase-free*): Dedicated commit and tag signing key (`gpg.format = ssh`, `commit.gpgsign = true`, `tag.gpgsign = true`).
- **Configured defaults**: `git push` automatically pushes the current branch and sets upstream (`push.autoSetupRemote = true`), `git pull` rebases by default (`pull.rebase = true`), and `git commit` signs and shows the verbose diff (`commit.verbose = true`).

| Alias | Expands to | Alias | Expands to |
| :--- | :--- | :--- | :--- |
| `git st` | `status -sb` | `git sw` / `mk` / `main` | `switch` / `switch -c` / `switch main` |
| `git df` / `dc` | `diff` / `diff --cached` | `git br` / `del` | `branch` / `branch --delete` |
| `git lg` / `lo` | `log --oneline --graph` (current / `--all`) | `git undo` | `reset HEAD~1 --mixed` |
| `git a` / `cm` | `add --all` / `commit -m` | `git cleanall` | `clean --force --directory` |
| `git amend` | `commit --amend --no-edit` | `git aka` / `conf` | List aliases / list config with origin |
| `git ps` / `psf` / `pl` | `push` / `push --force-with-lease` / `pull` | | |

### Web Terminal (`hterm` / ChromeOS Secure Shell)
Web terminals cannot read local OS fonts. To load standard **JetBrains Mono** in ChromeOS Secure Shell, open DevTools (`ctrl-shift-j`) and run:

```javascript
term_.prefs_.set('font-family', '"JetBrains Mono", monospace');
term_.prefs_.set('user-css-text', '@import url("https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&display=swap"); x-row { font-family: "JetBrains Mono", monospace !important; text-rendering: optimizeLegibility; }');
```
