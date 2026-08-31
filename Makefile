BIN = ~/.local/bin
FISH_COMPLETIONS_DIR = ~/.config/fish/completions

.PHONY: all clean

all: Brewfile \
	~/.config/fish/functions/fzf_key_bindings.fish

Brewfile: $(shell brew --prefix)/Cellar/* $(shell brew --prefix)/Caskroom/*
	brew bundle dump --describe --force --no-restart

~/.config/fish/functions/fzf_key_bindings.fish:
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
