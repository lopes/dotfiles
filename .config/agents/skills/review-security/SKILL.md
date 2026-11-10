---
name: review-security
description: >-
  Language-agnostic offensive-security and adversarial code review for pull
  requests, branches, or entire repositories, followed by a documentation and
  hygiene pass. Orchestrates parallel clean-context security-reviewer subagents
  so the active coding session never blocks or grades its own homework.
---

# Adversarial Security & Hygiene Review (`/review-security`)

Orchestrate a clean-context, adversarial offensive-security and hygiene review of a branch, pull request, or repository by delegating Phases 2–4 to parallel **`security-reviewer`** subagents (`invoke_subagent`).

> [!IMPORTANT]
> **Never execute Phases 2–4 inline in the main builder context when `invoke_subagent` is available.** Running the review inside isolated `security-reviewer` subagents guarantees zero author attachment to the code, keeps raw scanner/diff output out of the main conversation window, and executes all three review lenses concurrently with `commandExecutionPolicy: auto`.

---

## Hard Rules

1. **Never install new tools or dependencies:** Only run scanners and linters that are already installed on the workstation or defined in the project's toolchain. If a missing tool would cover an important gap for the repository's stack, recommend it in the report — never install it yourself.
2. **No scanner theatre:** Do not pad the report with theoretical nitpicks or generic advice. Every finding must name an exact `file:line`, a concrete failure or exploit mechanism, and a minimal fix.
3. **Never exclude `tests/` or docs from secret review:** AI coding agents routinely paste real runtime strings, URLs, IPs, and tokens into unit test fixtures and Markdown examples. Audit `tests/` and documentation with the same scrutiny as production code.

---

## Execution Phases

### Phase 1 — Discovery & Scope Resolution (Main Coordinator)

1. **Determine scope:**
   - **Branch / PR mode (default when on a feature branch or when a PR is open):** Run `git status -sb`, identify the base branch (`main` or `master`), and inspect `git log --oneline <base>..HEAD` and `git diff --stat <base>...HEAD` (plus uncommitted working-tree changes).
   - **Full-repository mode (when on the default branch with a clean tree or asked for a repo audit):** Map the repository layout, languages, entry points, external network/API boundaries, authentication and secret handling, CI workflows (`.github/workflows/`), and IaC/container definitions.
2. **Read repository guardrails:** Check `AGENTS.md`, `SECURITY.md`, and `Makefile` (or equivalent build config) to identify project-specific invariants and native verification commands (`make check`, `pytest`, `ruff`, `mypy`, `cargo test`, etc.).

### Phase 2–4 — Parallel Subagent Fan-Out (`invoke_subagent`)

In a **single turn**, launch **3 parallel `security-reviewer` subagents** via `invoke_subagent(TypeName="security-reviewer", ...)` (falling back to `TypeName="self"` only if `security-reviewer` is unavailable), passing each subagent the resolved repository path, target scope (branch diff vs. full repo), and its dedicated lens:

1. **Subagent 1 — `Role: "Security Scanner & CI Auditor"` (Phase 2 + CI/IAM):**
   - Check available local tools (`command -v gitleaks opengrep trivy shellcheck`) alongside the project's native test and lint gates (`make check`, `pytest`, `ruff`, `mypy`, etc.).
   - Run available deterministic scanners against the target scope (`gitleaks git --redact`, `opengrep scan`, `trivy fs --scanners vuln,misconfig`, plus the project's linter/test suite).
   - Audit CI/CD and IAM/container definitions (`.github/workflows/`, Dockerfiles, Quadlets, Ansible/Terraform) for missing least-privilege `permissions:` blocks, unpinned mutable third-party references, or excessive privileges.
   - Note any high-value missing scanner under **Suggested Tooling**.

2. **Subagent 2 — `Role: "Offsec Code & Secret Auditor"` (Phase 3.1–3.3):**
   - Read the target code, `tests/`, and documentation directly to hunt for semantic flaws that regex and AST rules miss:
     - **Secrets, Context Leaks & Test Fixtures:** Unprefixed API keys or tokens in URLs (`?key=`, `?token=`, `?api_key=`), headers, or error-message test fixtures; real IP addresses outside RFC 5737 (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`) and RFC 3849 (`2001:db8::/32`); non-RFC 2606 domains; local workstation paths (`/home/...`, `/Users/...`); internal hostnames or codenames; or raw secret files logged without redaction.
     - **Injection, Execution & Parsing Sinks:** Subprocess/shell execution (`subprocess`, `os.system`, `exec`, `eval`, backticks) with unvalidated input or `shell=True`; unsafe deserialization/parsing (`yaml.load` without `SafeLoader`, `pickle`, XML/JSON expansion, ReDoS, integer/buffer bounds); path traversal (unsanitized filenames, archive extraction, symlink following); and SSRF / open redirects.
     - **Authentication, Cryptography & Fail-Open Defaults:** Disabled TLS verification, weak/hardcoded crypto parameters, missing authz checks, or fail-open error handling (`except Exception: pass`).

3. **Subagent 3 — `Role: "Suppression & Hygiene Auditor"` (Phase 3.4 + Phase 4):**
   - **Suppression Audit:** Inspect every `# noqa`, `# nosemgrep`, `# type: ignore`, `.gitleaks.toml` allowlist, or `.opengrepignore` rule touched in the diff (or repo). Verify each suppression is narrow, intentional, and justified.
   - **Documentation Sync:** Verify that `README.md`, `AGENTS.md`, CLI `--help` output, docstrings, and configuration examples match current behavior and flags.
   - **Leftover Sweep:** Check for dead code, unused imports/variables, debug print statements, temporary `TODO`/`FIXME` hacks, stale references after a rename, or untracked scratch files in the working tree.

### Phase 5 — Report, Remediate, Verify & Commit (Main Coordinator)

1. **Merge, deduplicate & present findings concisely:**

   | Severity | Location | Category | Issue & Exploit / Failure Scenario | Proposed Fix |
   | :--- | :--- | :--- | :--- | :--- |
   | `CRITICAL` / `HIGH` / `MEDIUM` / `LOW` / `HYGIENE` | `path/to/file:line` | `Secret` / `SAST` / `Logic` / `Docs` / `Leftover` | Concrete 1-sentence explanation | Exact change required |

   Include a one-line **Suggested Tooling** note only if an uninstalled scanner would close a real blind spot.
2. **Remediate & verify:**
   - Once the user confirms which findings to fix (or immediately if instructed to fix all findings), implement the fixes directly in the main session.
   - Run the project's full test suite and local security checks (`L1` hooks, linters, type checks, unit tests) until every check passes with zero warnings.
   - Commit using [Scoped Commits](https://scopedcommits.com/) (`<scope>: <description>`) and pause for confirmation before pushing.
