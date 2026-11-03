# Global Preferences

## 1. Direct & Brutally Honest
- No sycophancy, no softening, no false agreement. If you are uncertain or guessing, say so directly.
- If you made a mistake, name it immediately. Push back when you disagree — I would rather hear objections upfront than discover problems later.
- Prefer boring, stable, and simple solutions. If an approach demands hacks, workarounds, or contortions to work, push back and redirect rather than building around bad design.

## 2. Find the Root Cause First
- When something breaks, investigate before patching. State the verified root cause before proposing the fix.
- Do not paper over symptoms (no broad `try`/`except`, no retry loops masking races, no disabled tests, no suppressed lint or presubmit checks). If tempted to, flag it and ask for confirmation.
- If the root cause cannot be found with reasonable effort, state what was investigated before making assumptions.

## 3. Dependencies & Tools of Any Kind
- Solve problems with standard libraries and standard tools first. Only reach for new dependencies when stdlib would require disproportionate effort for the same outcome.
- **Always confirm before adding or installing any new dependency or tool**, including:
  - OS-level packages and binaries (`apt`, `brew`, `curl | sh`, etc.).
  - Language packages and libraries (`pip`, `uv add`, `npm`, `cargo`, `go get`, etc.).
  - Infrastructure and automation plugins (e.g., Terraform providers/modules, Ansible collections).
- When adding an approved dependency, use the latest stable version unless an explicit version constraint is given.

## 4. Version Control & Scoped Commits
- Follow Scoped Commits (https://scopedcommits.com/): `<scope>: <description>` — lowercase scope first, one-sentence imperative description, no trailing period.
- Avoid generic prefixes (`feat:`, `fix:`, `chore:`, `update:`). Use comma-separated scopes for multi-area changes; `treewide` or `all` for repo-wide changes.
- Keep commits concise and focused on the rationale. Never add advertisements or promotional trailers (no "Generated with...", "Co-authored by...").
- Before pushing, propose rebasing or squashing fixup commits; never rewrite shared history without confirmation.
- **Every commit must be cryptographically signed (`Verified` on GitHub):** Never pass `--no-gpg-sign` or `-c commit.gpgsign=false`. For local clones, use standard `git commit` (which signs via `commit.gpgsign=true`) and `git push` (which authenticates over HTTPS via `gh auth git-credential`). When creating commits via the GitHub API without a local clone, always use the GraphQL `createCommitOnBranch` mutation (which GitHub signs server-side) — never use REST `POST /repos/.../git/commits` or `PUT /repos/.../contents/...`, which create unsigned commits.

## 5. Sanitization, Secret Prevention & Local State Hygiene
- Never commit local workstation paths, internal hostnames, corporate identifiers/usernames, internal tool codenames, customer names, or credentials to any repository.
- **Synthetic-only fixtures in code, `tests/`, and docs:** Never copy verbatim strings, URLs, query parameters, headers, IPs, or tokens from runtime logs, terminal output, environment variables, or databases into source files, test fixtures, or documentation. Always construct synthetic values using reserved documentation ranges (RFC 5737: `192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`; RFC 3849: `2001:db8::/32`; RFC 2606: `example.com`) and unmistakable dummy literals (`SYNTHETIC_TEST_<NAME>_000000`).
- **Zero raw secret reads into context:** Never read, print, or dump raw secret stores (`.env*`, `*secret*`, `*vault*`, `~/.config/zsh/private.sh`, SSH private keys, cloud credential files) into stdout or conversation context.
- Keep `~/.config/agents/`, `~/.config/gemini/`, and `~/.claude/` strictly for static user instructions; store persistent runtime state in `~/.local/state/`.
