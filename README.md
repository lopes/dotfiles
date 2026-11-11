# dotfiles

Minimalist Linux configuration files built around standard Unix tools, terminal-native transparent themes, and zero-copy symlink management.

## Philosophy
1. **Layout**: Remove superfluous UI elements to maximize screen space.
2. **Colors**: Terminal-native `base16` / `default` ANSI colors and transparent backgrounds (`transparent` / `bg=default` / `NONE`) across shell, prompt, multiplexer, pager, and editors—zero hardcoded hex palettes.
3. **Symbols**: Standard JetBrains Mono and Unicode only (no patched Nerd Fonts required).
4. **Controls**: Intentional keyboard shortcuts with modal navigation where it fits.
5. **Relevancy**: Only track tools and settings used daily.

## Workstation Scope & Recovery Model

| Pillar | What Lives There | How It Is Managed |
| :--- | :--- | :--- |
| **1. Configurations** (~90% tracked, ~10% local overrides) | Shell (`.zshenv`, `zsh`), multiplexer (`tmux`), editors (`helix`, `vim`), prompt (`oh-my-posh`), VCS/SSH (`git`, `ssh`), and global AI rules (`agents`, `gemini`). | Tracked in git and live-symlinked via `make install` (pre-existing conflicting files are backed up to `~/.local/state/dotfiles/backups/<timestamp>/`). Machine-specific ~10% lives in untracked local hooks (`~/.config/zsh/private.sh`, `~/.ssh/config.local`, `~/.config/git/config.local`, `~/.config/gemini/rules/`). |
| **2. Tools & Binaries** | System packages (`apt`), prompt (`oh-my-posh`), Python/LSP/linter stack (`uv` + `uv tool`), `markdown-oxide` (prebuilt GitHub release binary with `cargo` fallback), and compiled Helix Tree-sitter grammars (`.so`). | Never committed to git. Installed idempotently via `make deps` and upgraded across all layers via `make update` (`update-system`). |
| **3. Secrets & Credentials** | SSH auth & signing keys (`~/.ssh/github_ed25519*`, `~/.ssh/github_signing_ed25519*`, `~/.ssh/allowed_signers`), `gh` session (`~/.config/gh/hosts.yml`), and tokens/vars in `~/.config/zsh/private.sh` (`chmod 600`). | Never tracked (enforced by `.gitignore` `*` allowlist and global `gitleaks` hooks). Restored from an out-of-band vault; `make install` scaffolds `private.sh` and auto-derives `~/.ssh/allowed_signers` from `github_signing_ed25519.pub`, and `make doctor` audits readiness. |
| **4. Notes & Lessons Learned** | Hardware firmware modes, OS modifier remappings, and non-config troubleshooting tips. | Tracked as flat CommonMark files under [`notes/<slug>.md`](notes/), allowlisted via `make track FILE=notes/<slug>.md`, and verified by `make check`. |

---

## Install & Update

### 1. Bootstrap a New Machine
```sh
git clone https://github.com/lopes/dotfiles "$HOME/Projects/dotfiles"
cd "$HOME/Projects/dotfiles"
make bootstrap
exec zsh -l
```

### 2. Development Stack (Helix, LSPs, Linters & Formatters)
The development environment is terminal-native (`tmux` + `hx`) so it runs identically on local Debian and remote SSH hosts without port forwarding or web IDE servers. All packages, binaries, language servers, and Tree-sitter grammars below are installed automatically by `make deps` and upgraded by `make update` (`update-system`).

| Architectural Layer | Purpose | Tools in Stack |
| :--- | :--- | :--- |
| **Editor (`hx`)** | Modal project editor with built-in fuzzy/tree pickers, multi-cursor editing, focus-lost auto-save, and Git commit/rebase editing (`vim` remains `$EDITOR` for quick single-file shell edits). | `hx` (Helix), `ripgrep` (`rg`), `fd-find` (`fdfind` → `~/.local/bin/fd`) |
| **Tree-sitter** | Incremental AST parser compiled into Helix for syntax highlighting, structural indentation, and syntax-node selection (`alt-o`/`i`/`n`/`p`). | Bundled with Debian `hx` (`hx --grammar fetch && hx --grammar build`) |
| **Language Servers (LSP)** | Live code intelligence over stdio: autocompletion, go-to-definition (`gd`), references/backlinks (`gr`), hover docs (`space k`), and workspace rename (`space r`). | `pylsp` + `ruff server` (Python), `gopls` (Go), `rust-analyzer` (Rust), `clangd` (C/C++), `markdown-oxide` (Markdown), `tombi` (TOML) |
| **Linters** | Static analysis for bugs, security rules, and style both inside the editor and from the CLI / agent workflows. | `ruff` (Python), `tombi` (TOML), `shellcheck` (Shell), `ansible-lint` (Ansible), `yamllint` (YAML) |
| **Typecheckers** | Static type verification in editor diagnostics (`pylsp-mypy`) and CI/CLI gates. | `mypy` (Python), `gopls` / `rustc` / `clangd` |
| **Formatters** | Deterministic code formatting triggered automatically on save in Helix. | `ruff format` (Python), `shfmt` (Shell), `gofmt` (Go), `rustfmt` (Rust), `clang-format` (C/C++), `tombi format` (TOML) |

### 3. Managing the Repo
`make install` creates symlinks from `~/.config/<tool>` (plus `~/.zshenv`, `~/.ssh/config`, `~/.gemini/config/`, and `~/.local/bin/fd`) directly into this repo. Editing either path edits the same file.

| Command | Action |
| :--- | :--- |
| `make bootstrap` | Full fresh-machine convergence (`install` → `deps` → `check` → `doctor`). |
| `make install` | Create symlinks (auto-backing up conflicts to `~/.local/state/dotfiles/backups/`), scaffold `private.sh`, and derive `~/.ssh/allowed_signers`. |
| `make deps` | Install missing `apt` packages, `oh-my-posh`, `uv` tools, prebuilt `markdown-oxide`, and Helix grammars idempotently. |
| `make update` | Upgrade `apt` packages, `uv` + `uv` tools, `oh-my-posh`, `markdown-oxide`, and Helix grammars (`update-system` alias). |
| `make doctor` | Audit readiness of the 10% local layer (`private.sh`, `config.local`, SSH/signing keys, `allowed_signers`, `gh` auth, and login shell). |
| `make check` | Validate shell/TOML/git/editor syntax and linters, symlinks, SSH permissions, `notes/` conventions, `.gitignore` parity, and `gitleaks` sanitization. |
| `make track FILE=<path>` | Allowlist `<path>` (and parent dirs) in `.gitignore` and stage it with `git add -f`. |
| `make untrack FILE=<path>` | Remove `<path>` from `.gitignore` allowlist and untrack it from the git index. |
| `make list` | Display all managed symlinks and their targets. |
| `make uninstall` | Remove managed symlinks without deleting repo files. |

> [!IMPORTANT]
> `.gitignore` uses a strict 1:1 file **allowlist** (`*` ignores everything by default). When adding a new tracked file, run `make track FILE=<relative-path>` and verify with `make check`.

---

## Tool Notes & Non-Elementary Shortcuts

### Zsh & `fzf`
- **Startup split**: `.zshenv` sets environment variables for all processes (`XDG_*`, `PATH`, `EDITOR`, `ZDOTDIR`, `umask 027`, `LEDGER_FILE`, and `~/.config/zsh/private.sh`). `.zshrc` runs only in interactive terminals.
- **Local overrides (`private.sh`)**: Untracked machine-specific overrides live in `~/.config/zsh/private.sh` (`chmod 600` enforced automatically in `.zshenv` and scaffolded by `make install`), including `DEFAULT_USER` (to hide the normal login prefix in the prompt) and `HOST_PREFIX` (to strip a common hostname prefix in `oh-my-posh`, `zsh`, and `tmux`).
- **Notable aliases**: `tmux0` (`tmux new -As0`), `psa` (`ps auxf` — avoids aliasing `ps` directly so system pre-exec hooks don't break), `ports` (listening TCP sockets), `reload` (`exec "$SHELL" -l`), `update-system` (`make -C "$HOME/Projects/dotfiles" update`), `aka` (`alias | grep`).

| Shortcut | Action |
| :--- | :--- |
| `ctrl-r` | Fuzzy search command history (`fzf` — type words in any order) |
| `ctrl-t` | Fuzzy find file under current directory and insert path at cursor (`fzf`) |
| `alt-c` | Fuzzy find subdirectory and `cd` into it (`fzf`) |
| `**<tab>` | Trigger fuzzy completion for paths (`vim **<tab>`, `cd **<tab>`) |
| `ctrl-u` / `ctrl-k` | Kill line backward / forward |
| `ctrl-a` / `ctrl-e` | Jump to start (`Home`) / end (`End`) of line |
| `ctrl-left` / `ctrl-right` | Jump word backward / forward (`alt-left` / `alt-right` also supported) |

### Tmux
- **Prefix key**: **`ctrl-space`** (all `alt-*` chords are left unbound so terminal apps like Helix receive them directly).
- **Terminal & UI**: 24-bit `RGB`, `usstyle` undercurls, `extended-keys` (`CSI u`), and OSC-52 clipboard passthrough enabled. Top status bar and pane dividers use transparent backgrounds (`bg=default`) and terminal-native `base16` ANSI colors (`brightblack` / `white` split borders, and a solid `green` session badge that flips to `red` when `ctrl-space` is active) matching Helix's `base16_transparent` statusline.

| Shortcut | Action |
| :--- | :--- |
| `prefix c` | New window in current path |
| `prefix ,` | Rename current window |
| `prefix -` / `prefix \` | Split pane vertically / horizontally (in current path) |
| `prefix h/j/k/l` | Navigate panes left/down/up/right |
| `prefix H/J/K/L` | Resize active pane (repeatable) |
| `prefix x` / `prefix &` | Confirm before killing active pane / window |
| `prefix z` | Toggle active pane zoom (`+` indicator on window tab) |
| `prefix tab` | Toggle last active window |
| `prefix r` | Reload `tmux.conf` |
| `prefix [` | Enter vi copy mode (`v` select, `ctrl-v` block toggle, `y` copy, `prefix ]` paste) |

### Helix (`hx`) — Migration Quick Guide (from Vim & VSCode)
- **Core Mindset (`selection → action`)**:
  - In Vim, you type `action + motion` (`dw` = delete word, `dd` = delete line, `ci"` = change inside quotes).
  - In Helix, **every movement selects first**, then you act on the visible selection (`wd` = select word → delete, `xd` = select line → delete, `mi"c` = match inside `"` → change).
  - Because selections are always live, press `v` (`select` mode) whenever you want subsequent movements (`w`, `j`, `f`, etc.) to **extend** the current selection instead of moving it.

| Workflow | Shortcut | How It Works (The Helix Way) |
| :--- | :--- | :--- |
| **File Explorer (Tree)** | `space e` | Open hierarchical directory explorer (`enter` open/toggle dir, `a` new file/dir, `r` rename, `d` delete) |
| **Fuzzy File Picker** | `space f` | Fuzzy find file in repo (`ctrl-v` open in vertical split, `ctrl-s` horizontal split) |
| **Buffers & Splits** | `space b` / `gn` / `gp` | Fuzzy switch open buffers / next buffer / previous buffer (`:bc` close buffer, `ctrl-w w` cycle splits) |
| **Vertical Cursors** | `C` (`shift-c`) / `alt-c` | Duplicate cursor/selection onto the next / previous line; press `,` to collapse back to a single cursor |
| **Word & Line Jumps** | `ctrl-left`/`right`, `gh`/`gl` (`ctrl-a`/`e`) | Jump words in any mode; `gh`/`gl` jump to start/end of line in Normal mode (`ctrl-a`/`ctrl-e` in Insert mode) |
| **Split Lines to Cursors** | `x` (repeat) → `alt-s` | Select multiple lines with `x`, then press `alt-s` to place an independent cursor on every line |
| **Tree-sitter Selection** | `alt-o` / `alt-i` / `alt-n` / `alt-p` | Expand selection to parent AST node / shrink to child / jump to next or previous sibling node |
| **Find in File** | `/` then `n` / `N` | Regex search in current buffer (`*` uses current selection as search pattern) |
| **Find & Replace (File)** | `%` → `s` → `<regex><enter>` → `c` | Select file (`%`), select all regex matches (`s`), and type replacement live (`c`) across all matches at once |
| **Search Workspace** | `space /` | Live project-wide `ripgrep` search with preview |
| **Rename Symbol (LSP)** | `space r` | Semantic rename of variable/function/class across the entire project |
| **Block Indent** | `x` (repeat) → `>` or `<` | Select lines and indent/unindent (selection stays active, so press `>` or `<` repeatedly) |
| **Git Hunks & Status** | `]g` / `[g` / `space g` | Jump to next / prev git diff hunk / open picker of modified files in repo |
| **LSP Navigation** | `gd` / `gr` / `space k` / `space a` | Go to definition / find references / hover documentation / apply code action |
| **Open File / Link & Jumplist** | `gf` / `ctrl-o` / `ctrl-i` | Open file path or Markdown relative link (`[text](slug.md)`) under cursor / jump backward or forward in jumplist |
| **Diagnostics** | `]d` / `[d` / `space d` / `space D` | Next / prev diagnostic / buffer diagnostics picker / workspace diagnostics picker |
| **Word Suggestion** | Automatic / `ctrl-x` | LSP & path completions pop up automatically as you type; `ctrl-x` triggers buffer/LSP completion manually (`ctrl-n`/`ctrl-p` or `tab` to cycle) |
| **System Clipboard** | `space y` / `space p` | Yank / paste directly to/from the ChromeOS system clipboard over SSH (via OSC-52) |

### Vim
- **Role**: Standard `$EDITOR` / `$VISUAL` for quick single-file shell edits and `vi` (`git commit` and interactive rebases use Helix via `core.editor = hx`).
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
  - `~/.ssh/github_signing_ed25519` (*passphrase-free*): Dedicated commit and tag signing key (`gpg.format = ssh`, `commit.gpgsign = true`, `tag.gpgsign = true`; `make install` derives `~/.ssh/allowed_signers` automatically when `github_signing_ed25519.pub` is present).
- **Local escape hatches**: `~/.ssh/config.local` is included at the top of `.config/ssh/config` (OpenSSH first-match-wins), and `~/.config/git/config.local` is included at the bottom of `.config/git/config` (Git last-match-wins).
- **Configured defaults**: `git push` automatically pushes the current branch and sets upstream (`push.autoSetupRemote = true`), `git pull` rebases by default (`pull.rebase = true`), and `git commit` opens `hx`, signs, and shows the verbose diff (`commit.verbose = true`).

| Alias | Expands to | Alias | Expands to |
| :--- | :--- | :--- | :--- |
| `git st` | `status -sb` | `git sw` / `swc` / `main` | `switch` / `switch --create` / `switch main` |
| `git df` / `dfs` | `diff` / `diff --staged` | `git br` / `del` | `branch` / `branch --delete` |
| `git lg` / `lga` | `log --oneline --graph --decorate` (current / `--all`) | `git undo` | `reset HEAD~1 --mixed` |
| `git a` / `aa` / `cm` | `add` / `add --all` / `commit -m` | `git cleanall` | `clean --force --directory` |
| `git amend` | `commit --amend --no-edit` | `git aka` / `conf` | List aliases / list config with origin |
| `git ps` / `psf` / `pl` | `push` / `push --force-with-lease --force-if-includes` / `pull` | | |

### Web Terminal (`hterm` / ChromeOS Secure Shell) & Remote Development Topology
- **Local Workstation ↔ Remote Development Workstation**:
  - **Terminal & Multiplexer**: Connect from the local workstation's web terminal over SSH into `tmux0` (`tmux` + `hx`) on the remote development workstation.
  - **Clipboard Bridge (OSC-52)**: `set-clipboard on` in `tmux.conf` and `space y` in Helix copy selections directly from the remote development workstation to the local workstation clipboard over SSH.
  - **Browser Preview & Transfer Bridge (`localhost:1313`)**: Forwarding local TCP port `1313` over SSH (`-L 1313:127.0.0.1:1313` in `~/.ssh/config.local` or ChromeOS Secure Shell SSH arguments) exposes `127.0.0.1:1313` on the remote development workstation to `http://localhost:1313` in the local workstation browser—used for local Hugo site previews (`make serve`) and rendered Markdown/JSON/YAML/CSV workspace previews and bidirectional file transfer (`make preview`).

Web terminals cannot read local OS fonts. To load standard **JetBrains Mono** in ChromeOS Secure Shell, open DevTools (`ctrl-shift-j`) and run:

```javascript
term_.prefs_.set('font-family', '"JetBrains Mono", monospace');
term_.prefs_.set('user-css-text', '@import url("https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&display=swap"); x-row { font-family: "JetBrains Mono", monospace !important; text-rendering: optimizeLegibility; }');
```

---

## Reference Notes ([`notes/`](notes/))

While `README.md` documents the daily CLI toolchain under `.config/`, [`notes/`](notes/) holds standalone workstation, OS, and hardware setup notes (such as peripheral firmware modes, ChromeOS key remappings, and device-specific procedures that live outside dotfile symlinks):

- [`notes/logitech-keyboard-on-chromeos-configuration.md`](notes/logitech-keyboard-on-chromeos-configuration.md) — Logitech MX Keys Mini dual-mode firmware (`fn-O` Mac / `fn-P` Windows) and ChromeOS modifier remapping.

### Note Conventions (`notes/<slug>.md`)
- **Flat directory & slug:** Zero subdirectories inside `notes/`; multi-word lowercase kebab-case filenames (`^[a-z0-9]+(-[a-z0-9]+)+\.md$`, max `64` characters).
- **YAML Frontmatter:** `title` (≤ `64` chars) and `tags` (inline array with 1–3 `<domain>:<subtopic>` tags, e.g., `tags: [hardware:keyboard, os:chromeos]`).
- **Structure & Links:** Plain CommonMark with a `## Sources` section at the bottom and standard relative Markdown links `[text](slug.md)` (never `[[wikilinks]]`). No minimum word-count floor applies.
- **Tracking:** Track every new note with `make track FILE=notes/<slug>.md` and verify with `make check`.
