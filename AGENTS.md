# AGENTS.md

Guidance for AI coding agents working in this repository.

## Overview
Personal, minimalist Linux dotfiles (`agents`, `gemini`, `git`, `helix`, `oh-my-posh`, `ssh`, `tmux`, `vim`, `zsh`). Configs under `.config/` are exposed to `~/.config/` via directory symlinks managed by [`Makefile`](Makefile), alongside standalone symlinks for `~/.zshenv`, `~/.ssh/config`, and cross-harness global agent instructions (`~/.config/gemini/AGENTS.md`, `~/.gemini/config/AGENTS.md`, and `~/.claude/CLAUDE.md` all pointing to `.config/agents/AGENTS.md`). Because they are symlinks, the repo **is** the live configuration.

For repository maintenance (adding/removing configs, auditing, and committing), use the companion skill at [`.agents/skills/manage-dotfiles/SKILL.md`](.agents/skills/manage-dotfiles/SKILL.md) and run `make check`.

## Key Guardrails
- **Three coordinated places when adding/removing files**: [`Makefile`](Makefile) (`DIRS` plus standalone links), [`.gitignore`](.gitignore) (`!path` allowlist + `git add -f`), and `.config/<tool>/`. Always run `make check` after changes to verify parity.
- **Global git hooks (`L1`)**: `.config/git/config` sets `core.hooksPath = ~/.config/git/hooks`; `pre-commit` and `pre-push` run `gitleaks` against `.config/git/gitleaks.toml` (or a repo's `.gitleaks.toml`) and chain any executable repo-local `.git/hooks/*`.
- **`.zshenv` vs `.zshrc` boundary**: [`.zshenv`](.zshenv) holds environment variables needed by all shells and child processes (XDG paths, `PATH`, `EDITOR`, `PAGER`, `ZDOTDIR`, `umask`, `LEDGER_FILE`, and sourcing `~/.config/zsh/private.sh`). Interactive settings (history, completions, plugins, prompt, keybindings, aliases) live in [`.config/zsh/.zshrc`](.config/zsh/.zshrc).
- **Untracked local overrides**: Never track or allowlist `~/.config/zsh/private.sh` (secrets/local env, `chmod 600`), `~/.config/gemini/rules/` (local workstation rules), `~/.config/helix/runtime/` (compiled Tree-sitter `.so` grammars), or `~/.ssh/config.local` (included first in `.config/ssh/config` so local overrides win).
- **SSH permissions**: `.config/ssh/config` must remain mode `600` (`make install` enforces this and `make check` verifies it).
- **Theme consistency**: Always use terminal-native `default` / `base16` / `base16_transparent` ANSI colors and transparent backgrounds (`transparent` / `bg=default` / `NONE`) so every tool respects the terminal emulator's palette without hardcoded hex values.
