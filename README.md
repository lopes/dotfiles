# dotfiles
My personal, **minimalist** configuration files built on simplicity, security, and efficiency.

---

## Philosophy
1. **Layout**: Optimize screen space by removing superfluous elements.
2. **Colors**: Consistent GitHub Dark Dimmed colorscheme across all tools.
3. **Symbols**: Meaningful icons and glyphs via Nerd Fonts.
4. **Controls**: Streamlined shortcuts with vi-style navigation where it fits.
5. **Relevancy**: Only settings and tools that serve actual, practical usage.

---

## Packages
Install all dependencies before symlinking:

```sh
# core
brew install bat eza fzf git-delta htop jq nano ripgrep shellcheck \
  tmux vim yq zoxide zsh-autosuggestions zsh-syntax-highlighting

# security & incident response
brew install binwalk exiftool gron lnav miller mitmproxy nmap p7zip \
  pv socat ssdeep yara

# gui apps
brew install --cask ghostty obsidian raycast rectangle wireshark
```

---

## Quick Start

### Clean install
```sh
# 1. install packages (see Packages above)
# 2. clone and link
cd "$HOME/Projects"
git clone https://github.com/lopes/dotfiles
cd dotfiles
make install
# 3. restart your shell
```

### How it works
`make install` creates **directory-level symlinks** from `~/.config/` into this repository. For example:

```
~/.config/tmux  ->  ~/Projects/dotfiles/.config/tmux
~/.config/vim   ->  ~/Projects/dotfiles/.config/vim
~/.zshenv       ->  ~/Projects/dotfiles/.zshenv
```

Because these are symlinks, **editing a file in either location is the same thing**. There is no copy — the repo IS the live config.

### Makefile targets
| Target | What it does |
| :--- | :--- |
| `make install` | Creates all symlinks. Safe to run repeatedly — skips existing links, warns on conflicts. |
| `make list` | Shows all managed symlinks and whether they're connected. |
| `make uninstall` | Removes all managed symlinks. Does not delete any config files. |

---

## Working with Dotfiles

### Day-to-day: edit files in the repo
Since `~/.config/` entries are symlinks, just edit files wherever is convenient — both paths point to the same file:

```sh
vim ~/Projects/dotfiles/.config/tmux/tmux.conf   # same file
vim ~/.config/tmux/tmux.conf                      # same file
```

Changes are live immediately. No commands needed.

### Adding a new config directory
Example: adding a `wezterm` config.

```sh
# 1. create the config in the repo
mkdir -p ~/Projects/dotfiles/.config/wezterm
vim ~/Projects/dotfiles/.config/wezterm/wezterm.lua

# 2. register it in the Makefile (add to the DIRS list)
DIRS := bash claude ghostty git nano oh-my-posh termux tmux vim wezterm zsh

# 3. track it in git (allowlist gitignore requires -f)
echo '!.config/wezterm/**' >> ~/Projects/dotfiles/.gitignore
git add -f .config/wezterm/

# 4. create the symlink
make install
```

### Adding a loose config file
Example: adding a `.config/starship.toml`.

```sh
# 1. create the file in the repo
vim ~/Projects/dotfiles/.config/starship.toml

# 2. register it in the Makefile (add to the FILES list)
FILES := aliases.bsd.sh aliases.linux.sh aliases.unix.sh aliases.windows.sh inputrc starship.toml

# 3. track it in git
echo '!.config/starship.toml' >> ~/Projects/dotfiles/.gitignore
git add -f .config/starship.toml

# 4. create the symlink
make install
```

### Important
- **Always create files in the repo first** (`~/Projects/dotfiles/`), then run `make install` to link them. Never create configs directly in `~/.config/` — they won't be tracked.
- The `.gitignore` uses an **allowlist**: everything is ignored by default. You must add `!.config/yourfile` and use `git add -f` to track new files.
- `make install` will **never overwrite** existing files or directories — it only creates missing symlinks. If something already exists, it warns you.

### Modern CLI Tools
These tools replace traditional Unix commands with faster, more ergonomic alternatives. All are themed with GitHub Dark Dimmed where applicable.

| Tool | Replaces | What it does | Configuration | Examples |
| :--- | :--- | :--- | :--- | :--- |
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax-highlighted file viewer with line numbers and git integration. | Theme set via `BAT_THEME=base16-256` in `.zshenv` (inherits terminal colors). Aliased as `cat` in `aliases.bsd.sh`. | `cat script.py`, `cat -A log.txt` |
| [delta](https://github.com/dandavber/delta) | `git diff` | Syntax-highlighted diffs with line numbers. Automatically used by git as a pager. | Configured in `.config/git/config` under `[delta]`. | `git diff`, `git log -p` |
| [eza](https://github.com/eza-community/eza) | `ls` | Modern file listing with icons, git status, and tree view. | Aliased as `ls`, `ll`, `la`, and `tree` in `aliases.bsd.sh`. | `ls`, `ll`, `tree ~/Projects` |
| [fzf](https://github.com/junegunn/fzf) | `ctrl-r` | Fuzzy finder for shell history, files, and directories. | Initialized and themed in `.config/zsh/.zshrc`. Adds `ctrl-r` (history), `ctrl-t` (files), and `alt-c` (cd). | `ctrl-r` then type, `vim ctrl-t` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Faster recursive search, respects `.gitignore`, regex by default. | No config needed. Use as `rg pattern`. | `rg "error" /var/log`, `rg -i "password" -t py` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Learns your most-used directories for instant jumping with `z`. | Initialized in `.config/zsh/.zshrc`. Use `z foo` to jump to the best match. | `z dotfiles`, `z proj` |

### Security & IR Tools
Tools for file analysis, log investigation, and incident response. Aliased in `aliases.unix.sh`.

| Tool | What it does | Alias | Examples |
| :--- | :--- | :--- | :--- |
| [ssdeep](https://ssdeep-project.github.io/ssdeep/) | Fuzzy hashing — compare file similarity. | `fhash` | `fhash malware.bin`, `fhash -bcr ./samples/` |
| [yara](https://virustotal.github.io/yara/) | Pattern matching for malware classification. | — | `yara rules.yar suspect.exe`, `yara -r rules/ ./disk_image/` |
| [binwalk](https://github.com/ReFirmLabs/binwalk) | Scan and extract embedded files from binaries/firmware. | `extract` | `binwalk firmware.bin`, `extract firmware.bin` |
| [exiftool](https://exiftool.org/) | Read/write metadata from files (images, PDFs, docs). | `metadata` | `metadata photo.jpg`, `metadata -All= leaked.pdf` |
| [tshark](https://www.wireshark.org/) | CLI packet capture and analysis (Wireshark engine). | — | `tshark -r capture.pcap`, `tshark -i en0 -f "port 443"` |
| [mitmproxy](https://mitmproxy.org/) | Interactive HTTP/S proxy for inspecting web traffic. | — | `mitmproxy -p 8080`, `mitmdump -w traffic.flow` |
| [socat](http://www.dest-unreach.org/socat/) | Multipurpose network relay (netcat on steroids). | — | `socat TCP-LISTEN:4444 STDOUT`, `socat - TCP:host:port` |
| [nmap](https://nmap.org/) | Port scanning and service detection. | — | `nmap -sV host`, `nmap -sn 192.168.1.0/24` |
| [lnav](https://lnav.org/) | Log file navigator with syntax highlighting and SQL queries. | — | `lnav /var/log/system.log`, `lnav access.log error.log` |
| [gron](https://github.com/tomnomnom/gron) | Make JSON greppable — flatten then grep then unflatten. | `gj` | `gj api.json \| grep name`, `curl -s url \| gj` |
| [miller](https://github.com/johnkerl/miller) | Like awk/sed for structured data (CSV, JSON, tabular). | `csv`, `tsv` | `csv filter '$status != 200' access.csv`, `tsv head -n 5 data.tsv` |
| [pv](https://www.ivarch.com/programs/pv.shtml) | Pipe viewer — monitor data flow with progress bars. | — | `pv bigfile.img > /dev/disk2`, `cat dump.sql \| pv \| mysql` |
| [p7zip](https://github.com/p7zip-project/p7zip) | Handle every archive format (7z, zip, rar, tar, gz...). | `7z` | `7z x archive.7z`, `7z l suspect.zip` |

Common aliases for built-in tools:

| Alias | Expands to | Use case | Examples |
| :--- | :--- | :--- | :--- |
| `hexdump` | `hexdump -C` | Canonical hex+ASCII dump | `hexdump malware.bin \| head -50` |
| `strings` | `strings -a` | Extract printable strings from entire binary | `strings trojan.exe \| grep http` |
| `classify` | `file -b` | File type without filename noise | `classify unknown_attachment` |
| `sha` | `shasum -a 256` / `sha256sum` | Quick file hash | `sha malware.bin`, `sha *.log` |
| `headers` | `curl -sI` | Grab HTTP response headers | `headers https://suspicious-site.com` |
| `b64e` / `b64d` | `base64` / `base64 -d` | Encode/decode base64 payloads | `echo "payload" \| b64e`, `b64d <<< "dGVzdA=="` |
| `urldecode` | python3 one-liner | Decode percent-encoded URLs | `urldecode "https%3A%2F%2Fevil.com%2F%3Fq%3D1"` |
| `tcpdump` | `sudo tcpdump -nn` | No DNS/port resolution | `tcpdump -i en0 port 53` |
| `sniff` | `sudo tcpdump -nn -i en0` | Quick capture on primary interface | `sniff -w capture.pcap`, `sniff host 10.0.0.1` |
| `jl` | `jq -C . \| less -R` | Pretty-print JSON with pager | `jl cloudtrail.json`, `curl -s api \| jl` |
| `less` | `less -RNS` | Color, line numbers, no wrap | `less /var/log/system.log` |

---

## Shortcuts

### macOS
| Shortcut | Action |
| :--- | :--- |
| `cmd-space` | App launcher (Spotlight/Raycast) |
| `cmd-w/q` | Close/Quit application |
| `cmd-,` | Open application settings |
| `cmd-n` | New window, file, or tab |
| `ctrl-1..5` | Move to Desktop 1-5 |
| `ctrl-left/right` | Move to previous/next Desktop |
| `ctrl-up` | Mission Control |

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
Prefix key: `ctrl-a` (secondary: `ctrl-b`)

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
| `ctrl-v` | Toggle rectangle selection (copy mode) |
| `y` | Copy selection (copy mode) |
| `q` / `esc` | Exit copy mode |
| `prefix ]` | Paste clipboard |

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

