---
name: manage-dotfiles
description: >
  Audit, update, and maintain this dotfiles repository. Use when adding or
  removing a tool configuration, running sanity checks (`make check`),
  reconciling the `.gitignore` allowlist and `Makefile` symlinks, or preparing
  a verified, sanitized Scoped Commit.
---

# Manage Dotfiles

You are maintaining a minimalist, Linux-only dotfiles repository where `~/.config/<tool>` entries are live symlinks into `~/Projects/dotfiles/.config/<tool>`.

---

## Core Invariants

1. **Three-Way Lockstep (`Makefile` + `.gitignore` + Git index)**:
   - `.gitignore` uses a strict allowlist (`*` ignores everything; `!path` re-includes tracked paths).
   - Every new file requires an explicit `!path` entry in `.gitignore` **and** `git add -f <path>` (automated via `make track FILE=<relative-path>` and `make untrack FILE=<relative-path>`).
   - Every managed directory under `.config/` (except `ssh`, which links specifically to `~/.ssh/config`) must be listed in `DIRS` in `Makefile`. `Makefile` also manages standalone symlinks for `~/.zshenv`, `~/.config/zsh/.zshenv`, `~/.local/bin/fd`, `~/.config/gemini/AGENTS.md`, and `~/.gemini/config/{AGENTS.md,agents,rules,skills}`, plus full bootstrap/lifecycle targets (`make bootstrap`, `make deps`, `make update`, `make doctor`, `make check`).
2. **Untracked Local Escape Hatches**:
   - `~/.config/zsh/private.sh` (local env/secrets including `DEFAULT_USER` and `HOST_PREFIX`, `chmod 600`)
   - `~/.config/git/config.local` (local Git overrides, included last in `.config/git/config`)
   - `~/.config/gemini/rules/` (local workstation rules)
   - `~/.config/helix/runtime/` (compiled Tree-sitter `.so` grammars)
   - `~/.ssh/config.local` (local SSH host overrides, included first in `.config/ssh/config`)
   Never allowlist or stage these paths.
3. **Theme & Transparency Consistency**:
   - Always use terminal-native `default` / `base16` / `base16_transparent` ANSI colors and transparent backgrounds (`transparent` / `bg=default` / `NONE`) so every tool respects the terminal emulator's palette without hardcoded hex values.
4. **Public Repo Sanitization**:
   - Never commit internal hostnames, corporate usernames/LDAPs, workstation paths, or internal tool names.
5. **Reference Notes (`notes/<slug>.md`)**:
   - Standalone workstation, OS, and hardware setup notes live in `notes/<slug>.md` (flat directory, multi-word lowercase kebab-case ≤ `64` chars, YAML frontmatter with `title` ≤ `64` chars and inline `tags: [<domain>:<subtopic>]`, `## Sources` section, standard `[text](slug.md)` links, no word-count floor). Track with `make track FILE=notes/<slug>.md`.

---

## Workflows

### 1. Audit / Verify (`check` & `doctor`)
Run the repository sanity suite and 10% local readiness check, and report any drift:
```sh
make check
make doctor
make list
git status -sb
```
Also verify that `README.md` accurately reflects any non-elementary shortcuts or aliases changed in `.config/`.

### 2. Add a New Tool Config (`add <tool>`)
1. Create the config under `.config/<tool>/` in this repository (never directly in `~/.config/`).
2. Add `<tool>` alphabetically to `DIRS` in `Makefile`.
3. Run `make track FILE=.config/<tool>/<file>` to update `.gitignore` and stage the file.
4. Run `make install` and `make check`.
5. If the config introduces non-elementary shortcuts, opinionated behavior, or a new tool binary, update `Makefile` (`APT_PKGS` / `UV_TOOLS` in `make deps`) and `README.md`.

### 3. Remove a Tool Config (`remove <tool>`)
1. Remove the symlink first (`rm -v ~/.config/<tool>`).
2. Remove `<tool>` from `DIRS` in `Makefile` and untrack its files (`make untrack FILE=.config/<tool>/<file>`), then remove `!.config/<tool>/` from `.gitignore` and delete the directory (`rm -rf .config/<tool>`).
3. Remove any corresponding section from `README.md`.
4. Run `make check`.

### 4. Prepare & Commit (`commit`)
1. Check `git status -sb` and `git diff` across all modified files.
2. If any new files exist inside managed `.config/` or `.agents/` directories, confirm with the user whether they should be tracked via `make track FILE=<path>`.
3. Run `make check` as a mandatory pre-commit gate. Do not commit if `make check` fails.
4. Commit using Scoped Commits (`<scope>: <description>`, e.g., `zsh,git: refine aliases and enable pull rebase`). Never add attribution trailers.
