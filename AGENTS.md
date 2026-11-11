# AGENTS.md

Guidance for AI coding agents working in this repository.

## Overview
Personal, minimalist Linux dotfiles (`agents`, `gemini`, `git`, `helix`, `oh-my-posh`, `ssh`, `tmux`, `vim`, `zsh`). Configs under `.config/` are exposed to `~/.config/` via directory symlinks managed by [`Makefile`](Makefile), alongside standalone symlinks for `~/.zshenv`, `~/.config/zsh/.zshenv`, `~/.ssh/config`, `~/.local/bin/fd`, and global agent customizations (`~/.config/gemini/AGENTS.md` and `~/.gemini/config/{AGENTS.md,agents,rules,skills}` pointing to `.config/agents/` and `.config/gemini/`). Because they are symlinks, the repo **is** the live configuration.

Workstation state is partitioned into four pillars:
1. **Configurations** (~90% tracked in `.config/` + `.zshenv` and linked via `make install`, which auto-backs up conflicting non-symlink files to `~/.local/state/dotfiles/backups/<timestamp>/`; ~10% machine-specific overrides in untracked `~/.config/zsh/private.sh`, `~/.ssh/config.local`, `~/.config/git/config.local`, and `~/.config/gemini/rules/`).
2. **Tools & Binaries** (never committed; documented in [`README.md`](README.md), installed idempotently via `make deps`, and upgraded via `make update`).
3. **Secrets & Credentials** (never tracked; SSH keys `~/.ssh/github_*`, `~/.ssh/allowed_signers`, `gh` auth, and `~/.config/zsh/private.sh` secrets live in an out-of-band vault; `make install` scaffolds `private.sh` and derives `~/.ssh/allowed_signers`, and `make doctor` audits readiness).
4. **Notes & Lessons Learned** (standalone hardware, OS, and troubleshooting notes under [`notes/<slug>.md`](notes/)).

For repository maintenance (adding/removing configs, auditing, and committing), use the companion skill at [`.agents/skills/manage-dotfiles/SKILL.md`](.agents/skills/manage-dotfiles/SKILL.md) and run `make check`.

## Key Guardrails
- **Three coordinated places when adding/removing files**: [`Makefile`](Makefile) (`DIRS` plus standalone links), [`.gitignore`](.gitignore) (`!path` allowlist + `git add -f`, automated via `make track FILE=<path>` / `make untrack FILE=<path>`), and `.config/<tool>/`. Always run `make check` after changes to verify parity.
- **Global git hooks (`L1`)**: `.config/git/config` sets `core.hooksPath = ~/.config/git/hooks`; `pre-commit` and `pre-push` run `gitleaks` against `.config/git/gitleaks.toml` (or a repo's `.gitleaks.toml`) and chain any executable repo-local `.git/hooks/*`.
- **`.zshenv` vs `.zshrc` boundary**: [`.zshenv`](.zshenv) holds environment variables needed by all shells and child processes (XDG paths, `PATH`, `EDITOR`, `PAGER`, `ZDOTDIR`, `umask`, `LEDGER_FILE`, and sourcing `~/.config/zsh/private.sh`). Interactive settings (history, completions, plugins, prompt, keybindings, aliases) live in [`.config/zsh/.zshrc`](.config/zsh/.zshrc).
- **Untracked local overrides**: Never track or allowlist `~/.config/zsh/private.sh` (secrets/local env including `DEFAULT_USER` and `HOST_PREFIX`, `chmod 600`), `~/.config/git/config.local` (included last in `.config/git/config` so local overrides win), `~/.config/gemini/rules/` (local workstation rules), `~/.config/helix/runtime/` (compiled Tree-sitter `.so` grammars), or `~/.ssh/config.local` (included first in `.config/ssh/config` so local overrides win).
- **SSH permissions**: `.config/ssh/config` must remain mode `600` (`make install` enforces this and `make check` verifies it).
- **Theme consistency**: Always use terminal-native `default` / `base16` / `base16_transparent` ANSI colors and transparent backgrounds (`transparent` / `bg=default` / `NONE`) so every tool respects the terminal emulator's palette without hardcoded hex values.
- **Reference notes (`notes/<slug>.md`)**: While `README.md` documents the CLI toolchain under `.config/`, `notes/` holds standalone workstation, OS, and hardware setup notes (peripheral firmware modes, ChromeOS key remappings, and device-specific procedures). Keep `notes/` flat (zero subdirectories), use multi-word lowercase kebab-case filenames (`<slug>.md`, ≤ `64` chars), include `title` (≤ `64` chars) and inline `tags: [<domain>:<subtopic>]` YAML frontmatter, end with `## Sources`, and use standard relative Markdown links `[text](slug.md)` (never `[[wikilinks]]`). No word-count floor applies; track new notes via `make track FILE=notes/<slug>.md`.
