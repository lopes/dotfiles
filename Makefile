DOTFILES := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
CONFIG   := $(HOME)/.config
STATE    := $(HOME)/.local/state/dotfiles
BACKUP   := $(STATE)/backups/$(shell date +%Y%m%d-%H%M%S)
export PATH := $(HOME)/.local/bin:$(PATH)

# directories symlinked entirely into ~/.config/
DIRS := agents gemini git helix oh-my-posh tmux vim zsh

APT_PKGS := zsh tmux vim hx git gh git-delta gitleaks fzf ripgrep fd-find jq lsof curl \
            zsh-autosuggestions zsh-syntax-highlighting fonts-jetbrains-mono \
            python3 ansible shellcheck shfmt golang-go gopls \
            rustc cargo rust-analyzer rustfmt build-essential clangd clang-format hledger

UV_TOOLS := ruff mypy pytest tombi ansible-lint yamllint

.PHONY: bootstrap install uninstall deps update track untrack list doctor check

bootstrap:
	@$(MAKE) install
	@$(MAKE) deps
	@$(MAKE) check
	@$(MAKE) doctor

install:
	@mkdir -p "$(HOME)/.cache/zsh" "$(HOME)/.local/state/zsh" "$(HOME)/.local/bin" \
		"$(HOME)/.local/state/gemini" "$(DOTFILES)/.config/gemini/rules" \
		"$(HOME)/.gemini/config" "$(HOME)/.ssh"
	@chmod 700 "$(HOME)/.ssh"
	@chmod 600 "$(DOTFILES)/.config/ssh/config"
	@chmod +x "$(DOTFILES)/.config/git/hooks/pre-commit" "$(DOTFILES)/.config/git/hooks/pre-push"
	@link_item() { \
		src="$$1"; dst="$$2"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			echo "skip  $$dst (already linked)"; \
		else \
			if [ -e "$$dst" ] || [ -L "$$dst" ]; then \
				rel="$${dst#$(HOME)/}"; \
				mkdir -p "$$(dirname "$(BACKUP)/$$rel")"; \
				mv -v "$$dst" "$(BACKUP)/$$rel"; \
			fi; \
			ln -sv "$$src" "$$dst"; \
		fi; \
	}; \
	for d in $(DIRS); do \
		link_item "$(DOTFILES)/.config/$$d" "$(CONFIG)/$$d"; \
	done; \
	link_item "$(DOTFILES)/.zshenv" "$(HOME)/.zshenv"; \
	link_item "$(DOTFILES)/.zshenv" "$(CONFIG)/zsh/.zshenv"; \
	link_item "$(DOTFILES)/.config/ssh/config" "$(HOME)/.ssh/config"; \
	link_item "$(CONFIG)/agents/AGENTS.md" "$(CONFIG)/gemini/AGENTS.md"; \
	link_item "$(CONFIG)/agents/AGENTS.md" "$(HOME)/.gemini/config/AGENTS.md"; \
	link_item "$(CONFIG)/gemini/rules" "$(HOME)/.gemini/config/rules"; \
	link_item "$(CONFIG)/agents/skills" "$(HOME)/.gemini/config/skills"; \
	link_item "$(CONFIG)/agents/agents" "$(HOME)/.gemini/config/agents"; \
	if [ -x /usr/bin/fdfind ]; then \
		link_item "/usr/bin/fdfind" "$(HOME)/.local/bin/fd"; \
	fi
	@if [ ! -f "$(DOTFILES)/.config/zsh/private.sh" ]; then \
		umask 077; \
		printf '%s\n' \
			'# untracked machine-specific environment overrides & secrets (chmod 600)' \
			'export DEFAULT_USER="$${USER}"' \
			'export HOST_PREFIX=""' \
			> "$(DOTFILES)/.config/zsh/private.sh"; \
		chmod 600 "$(DOTFILES)/.config/zsh/private.sh"; \
		echo "init  $(CONFIG)/zsh/private.sh (created chmod 600 skeleton)"; \
	fi
	@if [ -f "$(HOME)/.ssh/github_signing_ed25519.pub" ] && [ ! -s "$(HOME)/.ssh/allowed_signers" ]; then \
		email="$$(git config --file "$(DOTFILES)/.config/git/config" user.email)"; \
		pubkey="$$(cat "$(HOME)/.ssh/github_signing_ed25519.pub")"; \
		printf '%s namespaces="git" %s\n' "$$email" "$$pubkey" > "$(HOME)/.ssh/allowed_signers"; \
		chmod 644 "$(HOME)/.ssh/allowed_signers"; \
		echo "init  $(HOME)/.ssh/allowed_signers (derived from github_signing_ed25519.pub)"; \
	fi
	@printf "\ndone. restart your shell to apply changes.\n"

uninstall:
	@for d in $(DIRS); do \
		[ -L "$(CONFIG)/$$d" ] && rm -v "$(CONFIG)/$$d" || true; \
	done
	@[ -L "$(HOME)/.zshenv" ] && rm -v "$(HOME)/.zshenv" || true
	@[ -L "$(CONFIG)/zsh/.zshenv" ] && rm -v "$(CONFIG)/zsh/.zshenv" || true
	@[ -L "$(HOME)/.ssh/config" ] && rm -v "$(HOME)/.ssh/config" || true
	@[ -L "$(CONFIG)/gemini/AGENTS.md" ] && rm -v "$(CONFIG)/gemini/AGENTS.md" || true
	@for item in rules skills agents AGENTS.md; do \
		[ -L "$(HOME)/.gemini/config/$$item" ] && rm -v "$(HOME)/.gemini/config/$$item" || true; \
	done
	@[ -L "$(HOME)/.local/bin/fd" ] && rm -v "$(HOME)/.local/bin/fd" || true
	@printf "\ndone. all symlinks removed.\n"

deps:
	@mkdir -p "$(HOME)/.local/bin"
	sudo apt update && sudo apt install -y $(APT_PKGS)
	@if [ -x /usr/bin/fdfind ] && [ ! -e "$(HOME)/.local/bin/fd" ]; then \
		ln -sv /usr/bin/fdfind "$(HOME)/.local/bin/fd"; \
	fi
	@command -v oh-my-posh >/dev/null 2>&1 || \
		(curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$(HOME)/.local/bin")
	@command -v uv >/dev/null 2>&1 || \
		(curl -LsSf https://astral.sh/uv/install.sh | sh)
	@command -v pylsp >/dev/null 2>&1 || uv tool install --with pylsp-mypy python-lsp-server
	@for tool in $(UV_TOOLS); do \
		command -v "$$tool" >/dev/null 2>&1 || uv tool install "$$tool"; \
	done
	@if ! command -v markdown-oxide >/dev/null 2>&1; then \
		arch="$$(uname -m)"; \
		url="$$(curl -fsSL https://api.github.com/repos/Feel-ix-343/markdown-oxide/releases/latest 2>/dev/null | jq -r --arg a "markdown-oxide-.*-$${arch}-unknown-linux-gnu$$" '.assets[] | select(.name | test($$a)) | .browser_download_url' | head -n1)"; \
		if [ -n "$$url" ] && [ "$$url" != "null" ]; then \
			echo "downloading prebuilt markdown-oxide ($$arch)..."; \
			curl -fsSL "$$url" -o "$(HOME)/.local/bin/markdown-oxide" && chmod +x "$(HOME)/.local/bin/markdown-oxide"; \
		else \
			CARGO_HOME="$(HOME)/.local/share/cargo" cargo install --root "$(HOME)/.local" --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide && \
			rm -rf "$(HOME)/.local/share/cargo" "$(HOME)/.cargo" "$(HOME)/.local/.crates.toml" "$(HOME)/.local/.crates2.json"; \
		fi; \
	fi
	@hx --grammar fetch && hx --grammar build && rm -rf "$(HOME)/.config/helix/runtime/grammars/sources"

update:
	@mkdir -p "$(HOME)/.local/bin"
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	@if command -v uv >/dev/null 2>&1; then \
		uv self update 2>/dev/null || true; \
		uv tool upgrade --all; \
	fi
	@if command -v oh-my-posh >/dev/null 2>&1; then \
		oh-my-posh upgrade --force || (curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$(HOME)/.local/bin"); \
	fi
	@arch="$$(uname -m)"; \
	url="$$(curl -fsSL https://api.github.com/repos/Feel-ix-343/markdown-oxide/releases/latest 2>/dev/null | jq -r --arg a "markdown-oxide-.*-$${arch}-unknown-linux-gnu$$" '.assets[] | select(.name | test($$a)) | .browser_download_url' | head -n1)"; \
	if [ -n "$$url" ] && [ "$$url" != "null" ]; then \
		echo "updating markdown-oxide ($$arch)..."; \
		curl -fsSL "$$url" -o "$(HOME)/.local/bin/markdown-oxide.tmp" && chmod +x "$(HOME)/.local/bin/markdown-oxide.tmp" && mv "$(HOME)/.local/bin/markdown-oxide.tmp" "$(HOME)/.local/bin/markdown-oxide"; \
	fi
	@! command -v hx >/dev/null 2>&1 || (hx --grammar fetch && hx --grammar build && rm -rf "$(HOME)/.config/helix/runtime/grammars/sources")

track:
	@if [ -z "$(FILE)" ]; then echo "usage: make track FILE=<relative-path>"; exit 1; fi; \
	rel="$(FILE)"; rel="$${rel#./}"; \
	if [ ! -f "$(DOTFILES)/$$rel" ]; then \
		echo "FAIL: $(DOTFILES)/$$rel does not exist or is not a regular file"; exit 1; \
	fi; \
	case "$$rel" in \
		.config/zsh/private.sh|.config/zsh/.zshenv|.config/git/config.local|.config/gemini/rules/*|.config/helix/runtime/*) \
			echo "FAIL: $$rel is an untracked local override and must never be tracked"; exit 1 ;; \
	esac; \
	dir="$$(dirname "$$rel")"; \
	if [ "$$dir" != "." ]; then \
		cur=""; \
		IFS=/; for seg in $$dir; do \
			cur="$${cur}$${seg}/"; \
			grep -qxF "!$$cur" "$(DOTFILES)/.gitignore" || printf '!%s\n' "$$cur" >> "$(DOTFILES)/.gitignore"; \
		done; unset IFS; \
	fi; \
	grep -qxF "!$$rel" "$(DOTFILES)/.gitignore" || printf '!%s\n' "$$rel" >> "$(DOTFILES)/.gitignore"; \
	git -C "$(DOTFILES)" add -f -- "$$rel" ".gitignore"; \
	echo "tracked $$rel (updated .gitignore and staged in git)"

untrack:
	@if [ -z "$(FILE)" ]; then echo "usage: make untrack FILE=<relative-path>"; exit 1; fi; \
	rel="$(FILE)"; rel="$${rel#./}"; \
	grep -vxF "!$$rel" "$(DOTFILES)/.gitignore" > "$(DOTFILES)/.gitignore.tmp" && mv "$(DOTFILES)/.gitignore.tmp" "$(DOTFILES)/.gitignore"; \
	git -C "$(DOTFILES)" rm --cached --ignore-unmatch -- "$$rel"; \
	git -C "$(DOTFILES)" add -f -- ".gitignore"; \
	echo "untracked $$rel (removed from .gitignore allowlist and git index)"

list:
	@echo "managed symlinks:"
	@for d in $(DIRS); do \
		printf "  %-28s -> %s\n" "$(CONFIG)/$$d" "$$(readlink "$(CONFIG)/$$d" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-28s -> %s\n" "$(HOME)/.zshenv" "$$(readlink "$(HOME)/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(CONFIG)/zsh/.zshenv" "$$(readlink "$(CONFIG)/zsh/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(HOME)/.ssh/config" "$$(readlink "$(HOME)/.ssh/config" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(CONFIG)/gemini/AGENTS.md" "$$(readlink "$(CONFIG)/gemini/AGENTS.md" 2>/dev/null || echo 'NOT LINKED')"
	@for item in rules skills agents AGENTS.md; do \
		printf "  %-28s -> %s\n" "$(HOME)/.gemini/config/$$item" "$$(readlink "$(HOME)/.gemini/config/$$item" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-28s -> %s\n" "$(HOME)/.local/bin/fd" "$$(readlink "$(HOME)/.local/bin/fd" 2>/dev/null || echo 'NOT LINKED')"

doctor:
	@echo "workstation readiness (10% local overrides & secrets):"
	@if [ -f "$(CONFIG)/zsh/private.sh" ]; then \
		mode="$$(stat -c '%a' "$(CONFIG)/zsh/private.sh")"; \
		has_user="$$(grep -q 'DEFAULT_USER' "$(CONFIG)/zsh/private.sh" && echo 'yes' || echo 'no')"; \
		has_prefix="$$(grep -q 'HOST_PREFIX' "$(CONFIG)/zsh/private.sh" && echo 'yes' || echo 'no')"; \
		if [ "$$mode" = "600" ] && [ "$$has_user" = "yes" ] && [ "$$has_prefix" = "yes" ]; then \
			tag="[OK]  "; \
		else \
			tag="[WARN]"; \
		fi; \
		printf "  %s %-34s (mode %s, DEFAULT_USER=%s, HOST_PREFIX=%s)\n" "$$tag" "~/.config/zsh/private.sh" "$$mode" "$$has_user" "$$has_prefix"; \
	else \
		printf "  [WARN] %-34s (missing — run 'make install' to scaffold)\n" "~/.config/zsh/private.sh"; \
	fi
	@if [ -f "$(HOME)/.ssh/config.local" ]; then \
		printf "  [OK]   %-34s (mode %s)\n" "~/.ssh/config.local" "$$(stat -c '%a' "$(HOME)/.ssh/config.local")"; \
	else \
		printf "  [INFO] %-34s (optional local SSH overrides not present)\n" "~/.ssh/config.local"; \
	fi
	@if [ -f "$(CONFIG)/git/config.local" ]; then \
		printf "  [OK]   %-34s (present)\n" "~/.config/git/config.local"; \
	else \
		printf "  [INFO] %-34s (optional local Git overrides not present)\n" "~/.config/git/config.local"; \
	fi
	@rules_count="$$(find "$(CONFIG)/gemini/rules" -maxdepth 1 -type f 2>/dev/null | wc -l)"; \
	printf "  [OK]   %-34s (%s local rule file(s))\n" "~/.config/gemini/rules/" "$$rules_count"
	@for key in github_ed25519 github_signing_ed25519; do \
		if [ -f "$(HOME)/.ssh/$$key" ]; then \
			printf "  [OK]   %-34s (mode %s)\n" "~/.ssh/$$key" "$$(stat -c '%a' "$(HOME)/.ssh/$$key")"; \
		else \
			printf "  [WARN] %-34s (missing — restore from vault)\n" "~/.ssh/$$key"; \
		fi; \
	done
	@if [ -s "$(HOME)/.ssh/allowed_signers" ]; then \
		printf "  [OK]   %-34s (configured)\n" "~/.ssh/allowed_signers"; \
	else \
		printf "  [WARN] %-34s (missing — restore github_signing_ed25519.pub and run 'make install')\n" "~/.ssh/allowed_signers"; \
	fi
	@if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then \
		printf "  [OK]   %-34s (authenticated)\n" "gh auth status"; \
	else \
		printf "  [WARN] %-34s (not authenticated — run 'gh auth login')\n" "gh auth status"; \
	fi
	@login_shell="$$(getent passwd "$(USER)" 2>/dev/null | cut -d: -f7)"; \
	if [ "$$login_shell" = "/usr/bin/zsh" ] || [ "$$login_shell" = "/bin/zsh" ]; then \
		printf "  [OK]   %-34s (%s)\n" "login shell" "$$login_shell"; \
	else \
		printf "  [WARN] %-34s (%s — run 'chsh -s /usr/bin/zsh')\n" "login shell" "$${login_shell:-unknown}"; \
	fi

check:
	@echo "1. syntax & linters..."
	@zsh -n "$(DOTFILES)/.zshenv" "$(DOTFILES)/.config/zsh/.zshrc" "$(DOTFILES)/.config/zsh/aliases.sh"
	@sh -n "$(DOTFILES)/.config/git/hooks/pre-commit" "$(DOTFILES)/.config/git/hooks/pre-push"
	@! command -v shellcheck >/dev/null 2>&1 || shellcheck "$(DOTFILES)/.config/git/hooks/pre-commit" "$(DOTFILES)/.config/git/hooks/pre-push" "$(DOTFILES)/.config/zsh/aliases.sh"
	@! command -v tombi >/dev/null 2>&1 || tombi lint "$(DOTFILES)/.config/helix/config.toml" "$(DOTFILES)/.config/helix/languages.toml" "$(DOTFILES)/.config/oh-my-posh/vigil.toml" "$(DOTFILES)/.config/git/gitleaks.toml" >/dev/null 2>&1
	@git config --file "$(DOTFILES)/.config/git/config" --list >/dev/null
	@ssh -F "$(DOTFILES)/.config/ssh/config" -G github.com >/dev/null
	@tmux -L dotfiles-check -f "$(DOTFILES)/.config/tmux/tmux.conf" start-server \; source-file "$(DOTFILES)/.config/tmux/tmux.conf" \; kill-server
	@vim --not-a-term -es -u "$(DOTFILES)/.config/vim/vimrc" -c 'q!'
	@! command -v hx >/dev/null 2>&1 || hx --health >/dev/null
	@! command -v oh-my-posh >/dev/null 2>&1 || oh-my-posh print primary --config "$(DOTFILES)/.config/oh-my-posh/vigil.toml" >/dev/null
	@echo "2. symlinks & permissions..."
	@for d in $(DIRS); do \
		if [ "$$(readlink "$(CONFIG)/$$d" 2>/dev/null)" != "$(DOTFILES)/.config/$$d" ]; then \
			echo "FAIL: $(CONFIG)/$$d is not linked to $(DOTFILES)/.config/$$d"; exit 1; \
		fi; \
	done
	@if [ "$$(readlink "$(HOME)/.zshenv" 2>/dev/null)" != "$(DOTFILES)/.zshenv" ]; then \
		echo "FAIL: $(HOME)/.zshenv is not linked"; exit 1; \
	fi
	@if [ "$$(readlink "$(CONFIG)/zsh/.zshenv" 2>/dev/null)" != "$(DOTFILES)/.zshenv" ]; then \
		echo "FAIL: $(CONFIG)/zsh/.zshenv is not linked to $(DOTFILES)/.zshenv"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.ssh/config" 2>/dev/null)" != "$(DOTFILES)/.config/ssh/config" ]; then \
		echo "FAIL: $(HOME)/.ssh/config is not linked"; exit 1; \
	fi
	@if [ "$$(readlink "$(CONFIG)/gemini/AGENTS.md" 2>/dev/null)" != "$(CONFIG)/agents/AGENTS.md" ]; then \
		echo "FAIL: $(CONFIG)/gemini/AGENTS.md is not linked to $(CONFIG)/agents/AGENTS.md"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.gemini/config/AGENTS.md" 2>/dev/null)" != "$(CONFIG)/agents/AGENTS.md" ]; then \
		echo "FAIL: $(HOME)/.gemini/config/AGENTS.md is not linked to $(CONFIG)/agents/AGENTS.md"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.gemini/config/skills" 2>/dev/null)" != "$(CONFIG)/agents/skills" ]; then \
		echo "FAIL: $(HOME)/.gemini/config/skills is not linked to $(CONFIG)/agents/skills"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.gemini/config/agents" 2>/dev/null)" != "$(CONFIG)/agents/agents" ]; then \
		echo "FAIL: $(HOME)/.gemini/config/agents is not linked to $(CONFIG)/agents/agents"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.gemini/config/rules" 2>/dev/null)" != "$(CONFIG)/gemini/rules" ]; then \
		echo "FAIL: $(HOME)/.gemini/config/rules is not linked to $(CONFIG)/gemini/rules"; exit 1; \
	fi
	@for link in "$(CONFIG)"/* "$(HOME)/.gemini/config"/* "$(HOME)/.local/bin/fd"; do \
		if [ -L "$$link" ] && [ ! -e "$$link" ]; then \
			echo "FAIL: dangling symlink $$link -> $$(readlink "$$link")"; exit 1; \
		fi; \
	done
	@if [ "$$(stat -c '%a' "$(DOTFILES)/.config/ssh/config")" != "600" ]; then \
		echo "FAIL: .config/ssh/config must be mode 600"; exit 1; \
	fi
	@for hook in pre-commit pre-push; do \
		if [ ! -x "$(DOTFILES)/.config/git/hooks/$$hook" ]; then \
			echo "FAIL: .config/git/hooks/$$hook must be executable"; exit 1; \
		fi; \
	done
	@echo "3. gitignore allowlist & tracking parity..."
	@for p in $$(sed -n 's/^!//p' "$(DOTFILES)/.gitignore"); do \
		if [ ! -e "$(DOTFILES)/$$p" ]; then \
			echo "FAIL: .gitignore allowlists missing path: $$p"; exit 1; \
		fi; \
	done
	@for f in $$(git -C "$(DOTFILES)" ls-files); do \
		if ! grep -qxF "!$$f" "$(DOTFILES)/.gitignore"; then \
			echo "FAIL: tracked file missing from .gitignore allowlist: $$f"; exit 1; \
		fi; \
	done
	@for d in "$(DOTFILES)/.config"/*; do \
		[ -d "$$d" ] || continue; \
		name=$$(basename "$$d"); \
		case " $(DIRS) ssh " in *" $$name "*) ;; *) \
			echo "FAIL: unexpected directory in .config/: $$name"; exit 1 ;; \
		esac; \
	done
	@untracked=$$(find "$(DOTFILES)/.config" "$(DOTFILES)/.agents" -type f \
		! -path "$(DOTFILES)/.config/zsh/private.sh" \
		! -path "$(DOTFILES)/.config/git/config.local" \
		! -path "$(DOTFILES)/.config/gemini/rules/*" \
		! -path "$(DOTFILES)/.config/helix/runtime/*" \
		-printf '%P\n' | while read -r rel; do \
			parent=$$(echo "$$rel" | cut -d/ -f1); \
			case " $(DIRS) ssh skills " in *" $$parent "*) ;; *) continue ;; esac; \
			git -C "$(DOTFILES)" ls-files --error-unmatch ".config/$$rel" >/dev/null 2>&1 || \
			git -C "$(DOTFILES)" ls-files --error-unmatch ".agents/$$rel" >/dev/null 2>&1 || \
			echo "$$rel"; \
		done); \
	if [ -n "$$untracked" ]; then \
		echo "FAIL: untracked files in managed dirs (run 'make track FILE=...' or remove):"; \
		echo "$$untracked"; exit 1; \
	fi
	@if [ -d "$(DOTFILES)/notes" ]; then \
		if [ -n "$$(find "$(DOTFILES)/notes" -mindepth 1 -type d)" ]; then \
			echo "FAIL: notes/ must remain flat (zero subdirectories)"; exit 1; \
		fi; \
		for f in "$(DOTFILES)/notes"/*; do \
			[ -e "$$f" ] || continue; \
			base=$$(basename "$$f"); \
			slug=$${base%.md}; \
			if ! git -C "$(DOTFILES)" ls-files --error-unmatch "notes/$$base" >/dev/null 2>&1; then \
				echo "FAIL: untracked note notes/$$base (run 'make track FILE=notes/$$base')"; exit 1; \
			fi; \
			if ! printf '%s\n' "$$base" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)+\.md$$' || [ "$${#slug}" -gt 64 ]; then \
				echo "FAIL: notes/$$base must be multi-word lowercase kebab-case (<= 64 chars)"; exit 1; \
			fi; \
			if ! grep -Eq '^title: .+' "$$f" || ! grep -Eq '^tags: \[[a-z0-9-]+:[a-z0-9-]+' "$$f" || ! grep -Fxq '## Sources' "$$f"; then \
				echo "FAIL: notes/$$base must include YAML title, tags: [<domain>:<subtopic>], and '## Sources'"; exit 1; \
			fi; \
			if grep -Eq '\[\[[^]]+\]\]' "$$f"; then \
				echo "FAIL: notes/$$base contains [[wikilinks]]; use [text](slug.md)"; exit 1; \
			fi; \
		done; \
	fi
	@echo "4. public-repo sanitization..."
	@if git -C "$(DOTFILES)" grep -I -E '([g]ooglers\.com|[g]oogle3|[g]linux|[r]odete|/usr/local/[g]oogle)' -- . >/dev/null 2>&1; then \
		echo "FAIL: internal marker found in tracked files:"; \
		git -C "$(DOTFILES)" grep -I -n -E '([g]ooglers\.com|[g]oogle3|[g]linux|[r]odete|/usr/local/[g]oogle)' -- .; \
		exit 1; \
	fi
	@if [ -n "$(USER)" ] && [ "$(USER)" != "lopes" ] && git -C "$(DOTFILES)" grep -I -F "$(USER)" -- . >/dev/null 2>&1; then \
		echo "FAIL: local username '$(USER)' found in tracked files:"; \
		git -C "$(DOTFILES)" grep -I -n -F "$(USER)" -- .; \
		exit 1; \
	fi
	@! command -v gitleaks >/dev/null 2>&1 || gitleaks git --redact --no-banner --config "$(DOTFILES)/.config/git/gitleaks.toml" "$(DOTFILES)"
	@echo "all checks passed."
