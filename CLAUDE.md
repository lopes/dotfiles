# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for a security engineer who works on macOS (Apple Silicon, Homebrew-first) and SSHes to Debian. The repo doubles as (a) a sync mechanism between his work mac and personal computer and (b) a bootstrap helper that installs his daily toolchain. He is the only user.

Configs live under `.config/` in the repo and are exposed to the system via **symlinks** managed by a `Makefile`. The repo IS the live config — editing a file here and editing the symlinked target in `~/.config/` modify the same file. There is no build, no copy step, no "sync."

## Style and taste

- **Minimalist, useful, no hacks.** Plain config lines over clever ones. No plugin managers, no shell rewrites, no workarounds when a boring solution exists. If a config grows abstractions for one use site, simplify it.
- **GitHub Dark Dimmed everywhere.** Palette is defined in `.config/tmux/tmux.conf` and `.config/oh-my-posh/sable.toml`; reuse those hex values when theming a new tool. Don't introduce a second palette.
- **Known, safe tooling.** Prefer Homebrew formulae (mac) and Debian-packaged tools (Linux). Avoid curl-piped installers, vendored binaries, or anything experimental.
- **Cross-OS friendliness.** Anything OS-specific belongs in `aliases.{bsd,linux,windows}.sh`. Anything that works on both belongs in `aliases.unix.sh` (sourced by the OS-specific files).

## Common commands

```sh
make bootstrap   # new-machine setup: brew bundle + symlinks + macos-defaults.sh
make install     # create symlinks only (idempotent; skips existing, warns on conflicts)
make uninstall   # remove the symlinks only (config files in the repo are untouched)
make list        # show every managed symlink and whether it resolves
make brew        # brew bundle install (apply Brewfile)
make brew-check  # report drift between Brewfile and installed packages
make brew-dump   # regenerate Brewfile from current state (review diff before committing)
```

Restart the shell after `make install` to pick up `.zshenv` / `.zshrc` changes.

## Packages: Brewfile, not README

Brew packages (formulae, casks, taps, VSCode extensions) are declared in `Brewfile` at the repo root and applied via `brew bundle install`. The Brewfile is the source of truth — don't add packages by hand-editing the README. When the user installs or removes a brew package they actually want to keep, run `make brew-dump` and commit the resulting diff.

## Three coordinated places when adding a new config

The Makefile, the gitignore, and the file itself must agree. Miss one and either the symlink won't be created or the file won't be tracked.

1. **Create the file under `.config/<tool>/` in this repo** (never directly in `~/.config/`).
2. **Register it in the `Makefile`:**
   - Whole directory → add to `DIRS` (symlinked as `~/.config/<name>` → repo dir).
   - Single loose file → add to `FILES` (symlinked into `~/.config/`).
   - Special cases (`.zshenv`) are handled by their own block at the bottom of the `install` target.
3. **Allow it in `.gitignore`.** The gitignore is an **allowlist** — `*` ignores everything, then `!path/...` lines re-include specific paths. New files must be added with both an allowlist entry AND `git add -f` (force, because the parent pattern still matches at add time).
4. Run `make install` to materialize the symlink.

Mirror this in reverse when removing a config: drop the Makefile entry, drop the `.gitignore` allowlist line, `make uninstall` (or `rm` the specific symlink), then remove the repo files.

## Architecture notes that aren't obvious from the tree

- **OS-specific aliases dispatch.** `.config/zsh/.zshrc` sources one of `aliases.{bsd,linux,windows}.sh` based on `$OSTYPE`. `aliases.unix.sh` is the shared baseline and is sourced *from within* `aliases.bsd.sh` (and the others where applicable) — don't assume it loads automatically; check the OS-specific file when adding a cross-platform alias.
- **`.zshenv` is the env layer, `.zshrc` is the interactive layer.** XDG vars, `EDITOR`, `BAT_THEME`, `CLAUDE_CONFIG_DIR`, history file location all live in `.zshenv` so they apply to non-interactive shells too. Don't move them into `.zshrc`.
- **`CLAUDE_CONFIG_DIR` is redirected** to `~/.config/claude` in `.zshenv`. That directory exists under `.config/claude/` in this repo but only `claude/skills/**` and `claude/settings.json`-adjacent files are tracked (see `.gitignore`). Runtime state (`sessions/`, `history.jsonl`, `projects/`, `tasks/`, etc.) is intentionally untracked.
- **`.config/macos/macos-defaults.sh` is NOT symlinked.** It is a one-shot `defaults write` script run manually on a new machine. It lives in the repo for tracking only.
- **Private secrets** are sourced from `~/.config/zsh/private.sh` (untracked, chmod 600 enforced by `.zshrc`). Never commit anything to that path.
- **Git signing uses SSH keys**, not GPG, despite the `[gpg] program = ...` line — `[gpg] format = ssh` is the active setting. Commits are signed by `~/.ssh/id_ed25519.pub`.

## Claude skills live in this repo

`.config/claude/skills/` contains custom skills (one folder per skill, each with `SKILL.md` and optional `references/` and `scripts/`). They are tracked, and the symlinked `~/.config/claude/skills/` makes them available as `/skill-name` slash commands. Editing a skill here updates it live for future Claude Code sessions. See `.config/claude/skills/README.md` for the catalog.

## Things to leave alone

- Don't "fix" the `.gitignore` allowlist style — it's deliberate and prevents committing untracked runtime state from `~/.config/`.
- Don't introduce a copy-based install (e.g. `cp` instead of `ln -s`). The whole model depends on the repo being the live config.
- Don't add `make install` steps that overwrite existing non-symlink files. The current behavior is to warn and skip; preserve that.
