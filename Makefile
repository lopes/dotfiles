DOTFILES := $(HOME)/Projects/dotfiles
CONFIG   := $(HOME)/.config

# directories symlinked entirely into ~/.config/
DIRS := gemini git oh-my-posh tmux vim zsh

.PHONY: install uninstall list check

install:
	@mkdir -p "$(HOME)/.cache/zsh" "$(HOME)/.local/state/zsh" "$(HOME)/.local/bin" "$(HOME)/.local/state/gemini"
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
	@mkdir -p "$(HOME)/.gemini/config"
	@for item in rules AGENTS.md; do \
		if [ -L "$(HOME)/.gemini/config/$$item" ]; then \
			echo "skip  $(HOME)/.gemini/config/$$item (already linked)"; \
		elif [ -e "$(HOME)/.gemini/config/$$item" ]; then \
			echo "WARN  $(HOME)/.gemini/config/$$item exists and is not a symlink — skipping"; \
		elif [ -e "$(CONFIG)/gemini/$$item" ]; then \
			ln -sv "$(CONFIG)/gemini/$$item" "$(HOME)/.gemini/config/$$item"; \
		fi; \
	done
	@printf "\ndone. restart your shell to apply changes.\n"

uninstall:
	@for d in $(DIRS); do \
		[ -L "$(CONFIG)/$$d" ] && rm -v "$(CONFIG)/$$d" || true; \
	done
	@[ -L "$(HOME)/.zshenv" ] && rm -v "$(HOME)/.zshenv" || true
	@[ -L "$(HOME)/.ssh/config" ] && rm -v "$(HOME)/.ssh/config" || true
	@for item in rules AGENTS.md; do \
		[ -L "$(HOME)/.gemini/config/$$item" ] && rm -v "$(HOME)/.gemini/config/$$item" || true; \
	done
	@printf "\ndone. all symlinks removed.\n"

list:
	@echo "managed symlinks:"
	@for d in $(DIRS); do \
		printf "  %-28s -> %s\n" "$(CONFIG)/$$d" "$$(readlink "$(CONFIG)/$$d" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-28s -> %s\n" "$(HOME)/.zshenv" "$$(readlink "$(HOME)/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-28s -> %s\n" "$(HOME)/.ssh/config" "$$(readlink "$(HOME)/.ssh/config" 2>/dev/null || echo 'NOT LINKED')"
	@for item in rules AGENTS.md; do \
		printf "  %-28s -> %s\n" "$(HOME)/.gemini/config/$$item" "$$(readlink "$(HOME)/.gemini/config/$$item" 2>/dev/null || echo 'NOT LINKED')"; \
	done

check:
	@echo "1. syntax check..."
	@zsh -n "$(DOTFILES)/.zshenv" "$(DOTFILES)/.config/zsh/.zshrc" "$(DOTFILES)/.config/zsh/aliases.sh"
	@git config --file "$(DOTFILES)/.config/git/config" --list >/dev/null
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
	@for link in "$(CONFIG)"/* "$(HOME)/.gemini/config"/*; do \
		if [ -L "$$link" ] && [ ! -e "$$link" ]; then \
			echo "FAIL: dangling symlink $$link -> $$(readlink "$$link")"; exit 1; \
		fi; \
	done
	@if [ "$$(stat -c '%a' "$(DOTFILES)/.config/ssh/config")" != "600" ]; then \
		echo "FAIL: .config/ssh/config must be mode 600"; exit 1; \
	fi
	@echo "3. gitignore allowlist & tracking parity..."
	@for p in $$(sed -n 's/^!//p' "$(DOTFILES)/.gitignore"); do \
		if [ ! -e "$(DOTFILES)/$$p" ]; then \
			echo "FAIL: .gitignore allowlists missing path: $$p"; exit 1; \
		fi; \
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
	@echo "all checks passed."
