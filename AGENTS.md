# AGENTS.md

Guidance for AI coding agents working in this repository.

## Overview
Personal, minimalist Linux dotfiles (`zsh`, `tmux`, `vim`, `git`, `ssh`, `oh-my-posh`, `gemini`). Configs under `.config/` are exposed to `~/.config/` via directory symlinks managed by [`Makefile`](Makefile). Because they are symlinks, the repo **is** the live configuration.

For repository maintenance (adding/removing configs, auditing, and committing), use the companion skill at [`.agents/skills/manage-dotfiles/SKILL.md`](.agents/skills/manage-dotfiles/SKILL.md) and run `make check`.

## Key Guardrails
- **Three coordinated places when adding/removing files**: [`Makefile`](Makefile) (`DIRS`), [`.gitignore`](.gitignore) (`!path` allowlist + `git add -f`), and `.config/<tool>/`. Always run `make check` after changes to verify parity.
- **`.zshenv` vs `.zshrc` boundary**: [`.zshenv`](.zshenv) holds environment variables needed by all shells and child processes (XDG paths, `PATH`, `EDITOR`, `PAGER`, `ZDOTDIR`, `umask`, `LEDGER_FILE`). Interactive settings (history, completions, plugins, prompt, keybindings, aliases) live in [`.config/zsh/.zshrc`](.config/zsh/.zshrc).
- **Untracked local overrides**: Never track or allowlist `~/.config/zsh/private.sh` (secrets/local env, `chmod 600`), `~/.config/gemini/rules/` (local workstation rules), or `~/.ssh/config.local`.
- **SSH permissions**: `.config/ssh/config` must remain mode `600` (`make install` enforces this and `make check` verifies it).
- **Theme consistency**: Reuse the GitHub Dark Dimmed hex palette from [`.config/tmux/tmux.conf`](.config/tmux/tmux.conf) and [`.config/oh-my-posh/sable.toml`](.config/oh-my-posh/sable.toml).
