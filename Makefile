BIN = ~/.local/bin
BASH_COMPLETIONS_DIR = ~/.bash_completion.d
FISH_COMPLETIONS_DIR = ~/.config/fish/completions
PYTHON = $(shell brew --prefix python@3.10)/bin/python3.10 -sE

.PHONY: all clean

all: Brewfile \
	~/.fzf.bash ~/.config/fish/functions/fzf_key_bindings.fish \
	$(BIN)/git-blast

Brewfile: $(shell brew --prefix)/Cellar/* $(shell brew --prefix)/Caskroom/*
	brew bundle dump --mas --describe --force --no-restart

~/.fzf.bash ~/.config/fish/functions/fzf_key_bindings.fish:
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc

$(BIN)/git-blast:
	curl -f https://raw.githubusercontent.com/rouge8/git-blast/master/git-blast -o $@
	chmod +x $@
