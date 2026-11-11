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
   - Every new file requires an explicit `!path` entry in `.gitignore` **and** `git add -f <path>`.
   - Every managed directory under `.config/` (except `ssh`, which links specifically to `~/.ssh/config`) must be listed in `DIRS` in `Makefile`. `Makefile` also manages standalone symlinks for `~/.zshenv`, `~/.config/zsh/.zshenv`, `~/.local/bin/fd`, and `~/.gemini/config/{AGENTS.md,agents,rules,skills}`, plus idempotent tool installation via `make deps`.
2. **Untracked Local Escape Hatches**:
   - `~/.config/zsh/private.sh` (local env/secrets, `chmod 600`)
   - `~/.config/gemini/rules/` (local workstation rules)
   - `~/.config/helix/runtime/` (compiled Tree-sitter `.so` grammars)
   - `~/.ssh/config.local` (local SSH host overrides)
   Never allowlist or stage these paths.
3. **Theme & Transparency Consistency**:
   - Always use terminal-native `default` / `base16` / `base16_transparent` ANSI colors and transparent backgrounds (`transparent` / `bg=default` / `NONE`) so every tool respects the terminal emulator's palette without hardcoded hex values.
4. **Public Repo Sanitization**:
   - Never commit internal hostnames, corporate usernames/LDAPs, workstation paths, or internal tool names.
5. **Reference Notes (`notes/<slug>.md`)**:
   - Standalone workstation, OS, and hardware setup notes live in `notes/<slug>.md` (flat directory, multi-word lowercase kebab-case ≤ `64` chars, YAML frontmatter with `title` ≤ `64` chars and inline `tags: [<domain>:<subtopic>]`, `## Sources` section, standard `[text](slug.md)` links, no word-count floor). Allowlist in `.gitignore` (`!notes/<slug>.md`) and stage with `git add -f`.

---

## Workflows

### 1. Audit / Verify (`check`)
Run the repository sanity suite and report any drift:
```sh
make check
make list
git status -sb
```
Also verify that `README.md` accurately reflects any non-elementary shortcuts or aliases changed in `.config/`.

### 2. Add a New Tool Config (`add <tool>`)
1. Create the config under `.config/<tool>/` in this repository (never directly in `~/.config/`).
2. Add `<tool>` alphabetically to `DIRS` in `Makefile`.
3. Add `!.config/<tool>/` and `!.config/<tool>/<file>` to `.gitignore`, then stage with `git add -f`.
4. Run `make install` and `make check`.
5. If the config introduces non-elementary shortcuts, opinionated behavior, or a new tool binary, update `Makefile` (`APT_PKGS` / `UV_TOOLS` in `make deps`) and `README.md`.

### 3. Remove a Tool Config (`remove <tool>`)
1. Remove the symlink first (`rm -v ~/.config/<tool>`).
2. Remove `<tool>` from `DIRS` in `Makefile` and drop its `!.config/<tool>*` lines from `.gitignore`.
3. Remove the files from git and disk (`git rm -rf .config/<tool>`).
4. Remove any corresponding section from `README.md`.
5. Run `make check`.

### 4. Prepare & Commit (`commit`)
1. Check `git status -sb` and `git diff` across all modified files.
2. If any new files exist inside managed `.config/` or `.agents/` directories, confirm with the user whether they should be allowlisted in `.gitignore` and staged with `git add -f`.
3. Run `make check` as a mandatory pre-commit gate. Do not commit if `make check` fails.
4. Commit using Scoped Commits (`<scope>: <description>`, e.g., `zsh,git: refine aliases and enable pull rebase`). Never add attribution trailers.
