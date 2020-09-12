DOTFILES_BIN = .local/bin
BIN = ~/$(DOTFILES_BIN)
COMPLETIONS_DIR = ~/.bash_completion.d

SHIVS = shiv \
	ipython \
	vex \
	flake8 \
	isort \
	twine \
	check-manifest \
	sops \
	black \
	blacken-docs \
	flit \
	nox \
	bowler \
	yesqa \
	pyupgrade \
	structurediff \
	identify-cli

.PHONY: all clean

SHIV = shiv --python "/usr/local/bin/python3.8 -sE"

all: $(addprefix $(BIN)/,$(SHIVS)) Brewfile ~/.fzf.bash

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN)/$$shiv; \
		rm $(DOTFILES_BIN)/$$shiv.symlink; \
	done

$(BIN)/%: $(DOTFILES_BIN)/%.symlink
	dotfiles install

$(DOTFILES_BIN)/shiv.symlink:
	VENV_DIR=$$(mktemp -d) && \
	python3 -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

$(DOTFILES_BIN)/flake8.symlink: $(BIN)/shiv
	$(SHIV) 'flake8>=3.2.0' flake8-comprehensions flake8-bugbear \
		-c flake8 -o $@

$(DOTFILES_BIN)/ipython.symlink: $(BIN)/shiv
	$(SHIV) ipython requests attrs \
		-c ipython -o $@

$(DOTFILES_BIN)/isort.symlink: $(BIN)/shiv
	$(SHIV) isort \
		-c isort -o $@

$(DOTFILES_BIN)/twine.symlink: $(BIN)/shiv
	$(SHIV) twine 'readme_renderer[md]' \
		-c twine -o $@

$(DOTFILES_BIN)/check-manifest.symlink: $(BIN)/shiv
	$(SHIV) check-manifest \
		-c check-manifest -o $@

$(DOTFILES_BIN)/sops.symlink: $(BIN)/shiv
	$(SHIV) 'sops >= 1.18' \
		-c sops -o $@

$(DOTFILES_BIN)/vex.symlink: $(BIN)/shiv
	$(SHIV) vex \
		-c vex -o $@
	mkdir -p $(COMPLETIONS_DIR)
	$@ --shell-config bash > $(COMPLETIONS_DIR)/vex

$(DOTFILES_BIN)/black.symlink: $(BIN)/shiv
	$(SHIV) black \
		-c black -o $@

$(DOTFILES_BIN)/blacken-docs.symlink: $(BIN)/shiv
	$(SHIV) blacken-docs \
		-c blacken-docs -o $@

$(DOTFILES_BIN)/flit.symlink: $(BIN)/shiv
	$(SHIV) flit \
		-c flit -o $@

$(DOTFILES_BIN)/nox.symlink: $(BIN)/shiv
	$(SHIV) nox-automation \
		-c nox -o $@

$(DOTFILES_BIN)/bowler.symlink: $(BIN)/shiv
	$(SHIV) bowler \
		-c bowler -o $@

$(DOTFILES_BIN)/yesqa.symlink: $(BIN)/shiv
	$(SHIV) yesqa \
		-c yesqa -o $@

$(DOTFILES_BIN)/pyupgrade.symlink: $(BIN)/shiv
	$(SHIV) pyupgrade \
		-c pyupgrade -o $@

$(DOTFILES_BIN)/structurediff.symlink: $(BIN)/shiv
	$(SHIV) structurediff \
		-c structurediff -o $@

$(DOTFILES_BIN)/identify-cli.symlink: $(BIN)/shiv
	$(SHIV) identify \
		-c identify-cli -o $@

Brewfile: $(shell brew --prefix) /Applications
	brew bundle dump --describe --force --no-restart

~/.fzf.bash:
	fzf --version || brew install fzf
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
