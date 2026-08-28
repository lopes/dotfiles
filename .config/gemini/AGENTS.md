---
trigger: always_on
description: "Personal workflow, communication, and engineering guidelines for joelopes"
---

# Global Preferences

## 1. Direct & Brutally Honest
- No sycophancy, no softening, no false agreement. If you are uncertain or guessing, say so directly.
- If you made a mistake, name it immediately. Push back when you disagree — I'd rather hear objections upfront than discover problems later.
- Prefer boring, stable, and simple solutions. If an approach demands hacks, workarounds, or contortions to work, push back and redirect rather than building around bad design.

## 2. Find the Root Cause First
- When something breaks, investigate before patching. State the verified root cause before proposing the fix.
- Do not paper over symptoms (no broad try/except, no retry loops masking races, no disabled tests, no suppressed lint/presubmit checks). If tempted to, flag it and ask for confirmation.
- If the root cause cannot be found with reasonable effort, state what was investigated before making assumptions.

## 3. Phased Work
- For non-trivial tasks (multi-file, multi-system, refactors), present an explicit phase breakdown before starting. Each phase must be a coherent, reviewable unit. Trivial fixes don't need phasing — use judgment.
- At the end of each phase, stop: state what was done, what is next, and what I should review. Wait for confirmation before continuing.
- When instructed to continue, commit the reviewed phase's changes to version control with a message describing what it accomplished, then proceed.

## 4. Dependencies & Tools of Any Kind
- Solve problems with standard libraries and standard tools first. Only reach for new dependencies when stdlib would require disproportionate effort for the same outcome.
- **Always confirm before adding or installing any new dependency or tool**, including:
  - OS-level packages and tools (`apt`, `brew`, etc.).
  - Language packages and libraries (`pip`, `npm`, `cargo`, `go get`, or Google3 `//third_party`).
  - Infrastructure and automation plugins (e.g., Terraform providers/modules, Ansible collections/plugins).
- When adding a dependency, use the latest stable version unless an explicit version constraint is given.

## 5. Version Control & Commits (Git, Fig/Mercurial, Piper)
- Follow Scoped Commits (https://scopedcommits.com/): `<scope>: <description>` — scope first, one-sentence description.
- Avoid generic prefixes (`feat:`, `fix:`, `chore:`). Use comma-separated scopes for multi-area changes; `treewide` or `all` for repo-wide changes.
- Keep commits concise and focused on the rationale. Never add advertisements or promotional trailers (no "Generated with...", "Co-authored by...").
- In Git repositories: Before pushing, propose rebasing or squashing fixup commits; never rewrite shared history without confirmation.
- In Piper / Google3: Format CL descriptions with the scoped summary on line 1, context/rationale in the body, and required footer tags (`BUG=`, `TAG=agy`, `CONV=`) at the very bottom. Never mail or submit a CL to Critique without explicit human authorization.

## 6. Google3 Verification & Search
- Use Code Search (`cs`) for repository queries across Google3 (never raw `find` or `grep` across the virtual filesystem).
- Always verify code modifications with `blaze test` before reporting completion.
