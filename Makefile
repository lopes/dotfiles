DOTFILES := $(HOME)/Projects/dotfiles
CONFIG   := $(HOME)/.config

# directories symlinked entirely into ~/.config/
DIRS := agents gemini git oh-my-posh tmux vim zsh

.PHONY: install uninstall list check

install:
	@mkdir -p "$(HOME)/.cache/zsh" "$(HOME)/.local/state/zsh" "$(HOME)/.local/bin" "$(HOME)/.local/state/gemini"
	@chmod +x "$(DOTFILES)/.config/git/hooks/pre-commit" "$(DOTFILES)/.config/git/hooks/pre-push"
	@for d in $(DIRS); do \
		if [ -L "$(CONFIG)/$$d" ]; then \
			echo "skip  $(CONFIG)/$$d (already linked)"; \
		elif [ -e "$(CONFIG)/$$d" ]; then \
			echo "WARN  $(CONFIG)/$$d exists and is not a symlink — skipping"; \
		else \
			ln -sv "$(DOTFILES)/.config/$$d" "$(CONFIG)/$$d"; \
		fi; \
	done
	@if [ -L "$(HOME)/.zshenv" ]; then \
		echo "skip  $(HOME)/.zshenv (already linked)"; \
	elif [ -e "$(HOME)/.zshenv" ]; then \
		echo "WARN  $(HOME)/.zshenv exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(DOTFILES)/.zshenv" "$(HOME)/.zshenv"; \
	fi
	@mkdir -p "$(HOME)/.ssh" && chmod 700 "$(HOME)/.ssh"
	@chmod 600 "$(DOTFILES)/.config/ssh/config"
	@if [ -L "$(HOME)/.ssh/config" ]; then \
		echo "skip  $(HOME)/.ssh/config (already linked)"; \
	elif [ -e "$(HOME)/.ssh/config" ]; then \
		echo "WARN  $(HOME)/.ssh/config exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(DOTFILES)/.config/ssh/config" "$(HOME)/.ssh/config"; \
	fi
	@if [ -L "$(CONFIG)/gemini/AGENTS.md" ]; then \
		echo "skip  $(CONFIG)/gemini/AGENTS.md (already linked)"; \
	elif [ -e "$(CONFIG)/gemini/AGENTS.md" ]; then \
		echo "WARN  $(CONFIG)/gemini/AGENTS.md exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(CONFIG)/agents/AGENTS.md" "$(CONFIG)/gemini/AGENTS.md"; \
	fi
	@mkdir -p "$(HOME)/.gemini/config"
	@if [ -L "$(HOME)/.gemini/config/AGENTS.md" ]; then \
		echo "skip  $(HOME)/.gemini/config/AGENTS.md (already linked)"; \
	elif [ -e "$(HOME)/.gemini/config/AGENTS.md" ]; then \
		echo "WARN  $(HOME)/.gemini/config/AGENTS.md exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(CONFIG)/agents/AGENTS.md" "$(HOME)/.gemini/config/AGENTS.md"; \
	fi
	@if [ -L "$(HOME)/.gemini/config/rules" ]; then \
		echo "skip  $(HOME)/.gemini/config/rules (already linked)"; \
	elif [ -e "$(HOME)/.gemini/config/rules" ]; then \
		echo "WARN  $(HOME)/.gemini/config/rules exists and is not a symlink — skipping"; \
	elif [ -e "$(CONFIG)/gemini/rules" ]; then \
		ln -sv "$(CONFIG)/gemini/rules" "$(HOME)/.gemini/config/rules"; \
	fi
	@mkdir -p "$(HOME)/.claude"
	@if [ -L "$(HOME)/.claude/CLAUDE.md" ]; then \
		echo "skip  $(HOME)/.claude/CLAUDE.md (already linked)"; \
	elif [ -e "$(HOME)/.claude/CLAUDE.md" ]; then \
		echo "WARN  $(HOME)/.claude/CLAUDE.md exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(CONFIG)/agents/AGENTS.md" "$(HOME)/.claude/CLAUDE.md"; \
	fi
	@printf "\ndone. restart your shell to apply changes.\n"

uninstall:
	@for d in $(DIRS); do \
		[ -L "$(CONFIG)/$$d" ] && rm -v "$(CONFIG)/$$d" || true; \
	done
	@[ -L "$(HOME)/.zshenv" ] && rm -v "$(HOME)/.zshenv" || true
	@[ -L "$(HOME)/.ssh/config" ] && rm -v "$(HOME)/.ssh/config" || true
	@[ -L "$(CONFIG)/gemini/AGENTS.md" ] && rm -v "$(CONFIG)/gemini/AGENTS.md" || true
	@for item in rules AGENTS.md; do \
		[ -L "$(HOME)/.gemini/config/$$item" ] && rm -v "$(HOME)/.gemini/config/$$item" || true; \
	done
	@[ -L "$(HOME)/.claude/CLAUDE.md" ] && rm -v "$(HOME)/.claude/CLAUDE.md" || true
	@printf "\ndone. all symlinks removed.\n"

list:
	@echo "managed symlinks:"
	@for d in $(DIRS); do \
		printf "  %-28s -> %s\n" "$(CONFIG)/$$d" "$$(readlink "$(CONFIG)/$$d" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-28s -> %s\n" "$(HOME)/.zshenv" "$$(readlink "$(HOME)/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(HOME)/.ssh/config" "$$(readlink "$(HOME)/.ssh/config" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(CONFIG)/gemini/AGENTS.md" "$$(readlink "$(CONFIG)/gemini/AGENTS.md" 2>/dev/null || echo 'NOT LINKED')"
	@for item in rules AGENTS.md; do \
		printf "  %-28s -> %s\n" "$(HOME)/.gemini/config/$$item" "$$(readlink "$(HOME)/.gemini/config/$$item" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-28s -> %s\n" "$(HOME)/.claude/CLAUDE.md" "$$(readlink "$(HOME)/.claude/CLAUDE.md" 2>/dev/null || echo 'NOT LINKED')"

check:
	@echo "1. syntax check..."
	@zsh -n "$(DOTFILES)/.zshenv" "$(DOTFILES)/.config/zsh/.zshrc" "$(DOTFILES)/.config/zsh/aliases.sh"
	@sh -n "$(DOTFILES)/.config/git/hooks/pre-commit" "$(DOTFILES)/.config/git/hooks/pre-push"
	@git config --file "$(DOTFILES)/.config/git/config" --list >/dev/null
	@ssh -F "$(DOTFILES)/.config/ssh/config" -G github.com >/dev/null
	@vim --not-a-term -es -u "$(DOTFILES)/.config/vim/vimrc" -c 'q!'
	@! command -v oh-my-posh >/dev/null 2>&1 || oh-my-posh print primary --config "$(DOTFILES)/.config/oh-my-posh/sable.toml" >/dev/null
	@echo "2. symlinks & permissions..."
	@for d in $(DIRS); do \
		if [ "$$(readlink "$(CONFIG)/$$d" 2>/dev/null)" != "$(DOTFILES)/.config/$$d" ]; then \
			echo "FAIL: $(CONFIG)/$$d is not linked to $(DOTFILES)/.config/$$d"; exit 1; \
		fi; \
	done
	@if [ "$$(readlink "$(HOME)/.zshenv" 2>/dev/null)" != "$(DOTFILES)/.zshenv" ]; then \
		echo "FAIL: $(HOME)/.zshenv is not linked"; exit 1; \
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
	@if [ -e "$(CONFIG)/gemini/rules" ] && [ "$$(readlink "$(HOME)/.gemini/config/rules" 2>/dev/null)" != "$(CONFIG)/gemini/rules" ]; then \
		echo "FAIL: $(HOME)/.gemini/config/rules is not linked to $(CONFIG)/gemini/rules"; exit 1; \
	fi
	@if [ "$$(readlink "$(HOME)/.claude/CLAUDE.md" 2>/dev/null)" != "$(CONFIG)/agents/AGENTS.md" ]; then \
		echo "FAIL: $(HOME)/.claude/CLAUDE.md is not linked to $(CONFIG)/agents/AGENTS.md"; exit 1; \
	fi
	@for link in "$(CONFIG)"/* "$(HOME)/.gemini/config"/* "$(HOME)/.claude/CLAUDE.md"; do \
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
	@for d in "$(DOTFILES)/.config"/*; do \
		[ -d "$$d" ] || continue; \
		name=$$(basename "$$d"); \
		case " $(DIRS) ssh " in *" $$name "*) ;; *) \
			echo "FAIL: unexpected directory in .config/: $$name"; exit 1 ;; \
		esac; \
	done
	@untracked=$$(find "$(DOTFILES)/.config" "$(DOTFILES)/.agents" -type f \
		! -path "$(DOTFILES)/.config/zsh/private.sh" \
		! -path "$(DOTFILES)/.config/gemini/rules/*" \
		-printf '%P\n' | while read -r rel; do \
			parent=$$(echo "$$rel" | cut -d/ -f1); \
			case " $(DIRS) ssh skills " in *" $$parent "*) ;; *) continue ;; esac; \
			git -C "$(DOTFILES)" ls-files --error-unmatch ".config/$$rel" >/dev/null 2>&1 || \
			git -C "$(DOTFILES)" ls-files --error-unmatch ".agents/$$rel" >/dev/null 2>&1 || \
			echo "$$rel"; \
		done); \
	if [ -n "$$untracked" ]; then \
		echo "FAIL: untracked files in managed dirs (update .gitignore and git add -f):"; \
		echo "$$untracked"; exit 1; \
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
	@echo "all checks passed."
