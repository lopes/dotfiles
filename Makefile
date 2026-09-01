DOTFILES := $(HOME)/Projects/dotfiles
CONFIG   := $(HOME)/.config

# directories symlinked entirely into ~/.config/
DIRS := bash claude gemini ghostty git htop nano oh-my-posh termux tmux vim zsh

# loose files symlinked into ~/.config/
FILES := aliases.bsd.sh aliases.linux.sh aliases.unix.sh aliases.windows.sh inputrc

.PHONY: install uninstall list brew brew-check brew-dump bootstrap apt

install:
	@mkdir -p "$(HOME)/.cache/zsh" "$(HOME)/.local/state/zsh" "$(HOME)/.local/bin" "$(HOME)/.local/state/gemini/skills" "$(HOME)/.local/state/gemini/scripts"
	@for d in $(DIRS); do \
		if [ -L "$(CONFIG)/$$d" ]; then \
			echo "skip  $(CONFIG)/$$d (already linked)"; \
		elif [ -e "$(CONFIG)/$$d" ]; then \
			echo "WARN  $(CONFIG)/$$d exists and is not a symlink — skipping"; \
		else \
			ln -sv "$(DOTFILES)/.config/$$d" "$(CONFIG)/$$d"; \
		fi; \
	done
	@for f in $(FILES); do \
		if [ -L "$(CONFIG)/$$f" ]; then \
			echo "skip  $(CONFIG)/$$f (already linked)"; \
		elif [ -e "$(CONFIG)/$$f" ]; then \
			echo "WARN  $(CONFIG)/$$f exists and is not a file — skipping"; \
		else \
			ln -sv "$(DOTFILES)/.config/$$f" "$(CONFIG)/$$f"; \
		fi; \
	done
	@if [ -L "$(HOME)/.zshenv" ]; then \
		echo "skip  $(HOME)/.zshenv (already linked)"; \
	elif [ -e "$(HOME)/.zshenv" ]; then \
		echo "WARN  $(HOME)/.zshenv exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(DOTFILES)/.zshenv" "$(HOME)/.zshenv"; \
	fi
	@if [ -L "$(HOME)/.bashrc" ]; then \
		echo "skip  $(HOME)/.bashrc (already linked)"; \
	elif [ -e "$(HOME)/.bashrc" ]; then \
		echo "WARN  $(HOME)/.bashrc exists and is not a symlink — skipping"; \
	else \
		ln -sv "$(DOTFILES)/.config/bash/bashrc" "$(HOME)/.bashrc"; \
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
	@for item in rules skills AGENTS.md; do \
		if [ -L "$(HOME)/.gemini/config/$$item" ]; then \
			echo "skip  $(HOME)/.gemini/config/$$item (already linked)"; \
		elif [ -e "$(HOME)/.gemini/config/$$item" ]; then \
			echo "WARN  $(HOME)/.gemini/config/$$item exists and is not a symlink — skipping"; \
		elif [ -e "$(CONFIG)/gemini/$$item" ]; then \
			ln -sv "$(CONFIG)/gemini/$$item" "$(HOME)/.gemini/config/$$item"; \
		fi; \
	done
	@echo "\ndone. restart your shell to apply changes."

uninstall:
	@for d in $(DIRS); do \
		[ -L "$(CONFIG)/$$d" ] && rm -v "$(CONFIG)/$$d" || true; \
	done
	@for f in $(FILES); do \
		[ -L "$(CONFIG)/$$f" ] && rm -v "$(CONFIG)/$$f" || true; \
	done
	@[ -L "$(HOME)/.zshenv" ] && rm -v "$(HOME)/.zshenv" || true
	@[ -L "$(HOME)/.bashrc" ] && rm -v "$(HOME)/.bashrc" || true
	@[ -L "$(HOME)/.ssh/config" ] && rm -v "$(HOME)/.ssh/config" || true
	@for item in rules skills AGENTS.md; do \
		[ -L "$(HOME)/.gemini/config/$$item" ] && rm -v "$(HOME)/.gemini/config/$$item" || true; \
	done
	@echo "\ndone. all symlinks removed."

brew:
	@brew tap jandedobbeleer/oh-my-posh        # ensure tap exists before trusting it
	@brew trust jandedobbeleer/oh-my-posh      # third-party tap: brew refuses to load it until trusted
	@brew bundle install --file="$(DOTFILES)/Brewfile"

brew-check:
	@brew bundle check --file="$(DOTFILES)/Brewfile" --verbose

brew-dump:
	@brew bundle dump --file="$(DOTFILES)/Brewfile" --force --no-vscode
	@echo "Brewfile regenerated. review the diff before committing."

apt:
	@sudo apt update && sudo apt install -y \
		ripgrep \
		fzf \
		zoxide \
		direnv \
		git-delta \
		htop \
		miller \
		lnav \
		pv \
		shellcheck \
		zsh-autosuggestions \
		zsh-syntax-highlighting \
		gh
	@mkdir -p "$(HOME)/.local/bin"
	@if ! command -v oh-my-posh >/dev/null 2>&1; then \
		echo "Installing oh-my-posh..."; \
		curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$(HOME)/.local/bin"; \
	fi
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	fi

bootstrap:
	@$(MAKE) brew
	@$(MAKE) install
	@bash "$(DOTFILES)/.config/macos/macos-defaults.sh"

list:
	@echo "managed symlinks:"
	@for d in $(DIRS); do \
		printf "  %-20s -> %s\n" "$(CONFIG)/$$d" "$$(readlink "$(CONFIG)/$$d" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@for f in $(FILES); do \
		printf "  %-20s -> %s\n" "$(CONFIG)/$$f" "$$(readlink "$(CONFIG)/$$f" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-20s -> %s\n" "$(HOME)/.zshenv" "$$(readlink "$(HOME)/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-20s -> %s\n" "$(HOME)/.bashrc" "$$(readlink "$(HOME)/.bashrc" 2>/dev/null || echo 'NOT LINKED')"
	@printf "  %-20s -> %s\n" "$(HOME)/.ssh/config" "$$(readlink "$(HOME)/.ssh/config" 2>/dev/null || echo 'NOT LINKED')"
	@for item in rules skills AGENTS.md; do \
		printf "  %-20s -> %s\n" "$(HOME)/.gemini/config/$$item" "$$(readlink "$(HOME)/.gemini/config/$$item" 2>/dev/null || echo 'NOT LINKED')"; \
	done

