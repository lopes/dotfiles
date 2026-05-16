DOTFILES := $(HOME)/Projects/dotfiles
CONFIG   := $(HOME)/.config

# directories symlinked entirely into ~/.config/
DIRS := bash claude ghostty git htop nano oh-my-posh termux tmux vim zsh

# loose files symlinked into ~/.config/
FILES := aliases.bsd.sh aliases.linux.sh aliases.unix.sh aliases.windows.sh inputrc

.PHONY: install uninstall list brew brew-check brew-dump bootstrap

install:
	@mkdir -p "$(HOME)/.cache/zsh" "$(HOME)/.local/bin"
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
	@echo "\ndone. all symlinks removed."

brew:
	@brew bundle install --file="$(DOTFILES)/Brewfile"

brew-check:
	@brew bundle check --file="$(DOTFILES)/Brewfile" --verbose

brew-dump:
	@brew bundle dump --file="$(DOTFILES)/Brewfile" --force
	@echo "Brewfile regenerated. review the diff before committing."

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
