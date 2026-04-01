DOTFILES := $(HOME)/Projects/dotfiles
CONFIG   := $(HOME)/.config

# directories symlinked entirely into ~/.config/
DIRS := aerospace bash claude ghostty git nano oh-my-posh termux tmux vim zsh

# loose files symlinked into ~/.config/
FILES := aliases.bsd.sh aliases.linux.sh aliases.unix.sh aliases.windows.sh inputrc

.PHONY: install uninstall list

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
	@echo "\ndone. restart your shell to apply changes."

uninstall:
	@for d in $(DIRS); do \
		[ -L "$(CONFIG)/$$d" ] && rm -v "$(CONFIG)/$$d" || true; \
	done
	@for f in $(FILES); do \
		[ -L "$(CONFIG)/$$f" ] && rm -v "$(CONFIG)/$$f" || true; \
	done
	@[ -L "$(HOME)/.zshenv" ] && rm -v "$(HOME)/.zshenv" || true
	@echo "\ndone. all symlinks removed."

list:
	@echo "managed symlinks:"
	@for d in $(DIRS); do \
		printf "  %-20s -> %s\n" "$(CONFIG)/$$d" "$$(readlink "$(CONFIG)/$$d" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@for f in $(FILES); do \
		printf "  %-20s -> %s\n" "$(CONFIG)/$$f" "$$(readlink "$(CONFIG)/$$f" 2>/dev/null || echo 'NOT LINKED')"; \
	done
	@printf "  %-20s -> %s\n" "$(HOME)/.zshenv" "$$(readlink "$(HOME)/.zshenv" 2>/dev/null || echo 'NOT LINKED')"
