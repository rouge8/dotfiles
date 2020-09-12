DOTFILES_BIN_DIR = .local/bin
BIN_DIR = ~/$(DOTFILES_BIN_DIR)
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

all: $(addprefix $(BIN_DIR)/,$(SHIVS)) Brewfile ~/.fzf.bash

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN_DIR)/$$shiv; \
		rm $(DOTFILES_BIN_DIR)/$$shiv.symlink; \
	done

$(BIN_DIR)/%: $(DOTFILES_BIN_DIR)/%.symlink
	dotfiles install

$(DOTFILES_BIN_DIR)/shiv.symlink:
	VENV_DIR=$$(mktemp -d) && \
	python3 -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

$(DOTFILES_BIN_DIR)/flake8.symlink: $(BIN_DIR)/shiv
	$(SHIV) 'flake8>=3.2.0' flake8-comprehensions flake8-bugbear \
		-c flake8 -o $@

$(DOTFILES_BIN_DIR)/ipython.symlink: $(BIN_DIR)/shiv
	$(SHIV) ipython requests attrs \
		-c ipython -o $@

$(DOTFILES_BIN_DIR)/isort.symlink: $(BIN_DIR)/shiv
	$(SHIV) isort \
		-c isort -o $@

$(DOTFILES_BIN_DIR)/twine.symlink: $(BIN_DIR)/shiv
	$(SHIV) twine 'readme_renderer[md]' \
		-c twine -o $@

$(DOTFILES_BIN_DIR)/check-manifest.symlink: $(BIN_DIR)/shiv
	$(SHIV) check-manifest \
		-c check-manifest -o $@

$(DOTFILES_BIN_DIR)/sops.symlink: $(BIN_DIR)/shiv
	$(SHIV) 'sops >= 1.18' \
		-c sops -o $@

$(DOTFILES_BIN_DIR)/vex.symlink: $(BIN_DIR)/shiv
	$(SHIV) vex \
		-c vex -o $@
	mkdir -p $(COMPLETIONS_DIR)
	$@ --shell-config bash > $(COMPLETIONS_DIR)/vex

$(DOTFILES_BIN_DIR)/black.symlink: $(BIN_DIR)/shiv
	$(SHIV) black \
		-c black -o $@

$(DOTFILES_BIN_DIR)/blacken-docs.symlink: $(BIN_DIR)/shiv
	$(SHIV) blacken-docs \
		-c blacken-docs -o $@

$(DOTFILES_BIN_DIR)/flit.symlink: $(BIN_DIR)/shiv
	$(SHIV) flit \
		-c flit -o $@

$(DOTFILES_BIN_DIR)/nox.symlink: $(BIN_DIR)/shiv
	$(SHIV) nox-automation \
		-c nox -o $@

$(DOTFILES_BIN_DIR)/bowler.symlink: $(BIN_DIR)/shiv
	$(SHIV) bowler \
		-c bowler -o $@

$(DOTFILES_BIN_DIR)/yesqa.symlink: $(BIN_DIR)/shiv
	$(SHIV) yesqa \
		-c yesqa -o $@

$(DOTFILES_BIN_DIR)/pyupgrade.symlink: $(BIN_DIR)/shiv
	$(SHIV) pyupgrade \
		-c pyupgrade -o $@

$(DOTFILES_BIN_DIR)/structurediff.symlink: $(BIN_DIR)/shiv
	$(SHIV) structurediff \
		-c structurediff -o $@

$(DOTFILES_BIN_DIR)/identify-cli.symlink: $(BIN_DIR)/shiv
	$(SHIV) identify \
		-c identify-cli -o $@

Brewfile: $(shell brew --prefix) /Applications
	brew bundle dump --describe --force --no-restart

~/.fzf.bash:
	fzf --version || brew install fzf
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
