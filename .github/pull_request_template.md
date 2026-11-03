## Description
<!-- Provide a brief, high-level summary of your changes. Explain WHY rather than WHAT. -->

## Related Issue / Context
<!-- Link to issue, reference, or ticket (e.g. Closes #12) -->

## Type of Change
- [ ] Shell & Terminal Config (`.config/zsh/`, `.config/tmux/`, `.config/oh-my-posh/`, `.zshenv`)
- [ ] Editor Config (`.config/vim/`)
- [ ] Git Config & Global Hooks (`.config/git/`)
- [ ] Global Agent Rules & Skills (`.config/agents/`, `.config/gemini/`, `.agents/`, `AGENTS.md`)
- [ ] Makefile & Symlink Installer (`Makefile`, `README.md`, `.github/`)

## Quality Checklist
- [ ] `make check` validates symlink targets and permissions cleanly.
- [ ] Zero private hostnames, corporate identifiers, or secrets committed (`private.sh` remains local-only).
- [ ] Static instructions only in `.config/agents/` and `.config/gemini/` (runtime state stays in `~/.local/state/`).
- [ ] Commit follows [Scoped Commits](https://scopedcommits.com/) convention (`<scope>: <description>`).
