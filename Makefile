BIN_DIR = .local/bin
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

all: $(SHIVS) Brewfile ~/.fzf.bash

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN_DIR)/$$shiv.symlink; \
	done

%: $(BIN_DIR)/%.symlink
	dotfiles install

$(BIN_DIR)/shiv.symlink:
	VENV_DIR=$$(mktemp -d) && \
	python3 -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

$(BIN_DIR)/flake8.symlink:
	$(SHIV) 'flake8>=3.2.0' flake8-comprehensions flake8-bugbear \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	$(SHIV) ipython requests attrs \
		-c ipython -o $@

$(BIN_DIR)/isort.symlink:
	$(SHIV) isort \
		-c isort -o $@

$(BIN_DIR)/twine.symlink:
	$(SHIV) twine 'readme_renderer[md]' \
		-c twine -o $@

$(BIN_DIR)/check-manifest.symlink:
	$(SHIV) check-manifest \
		-c check-manifest -o $@

$(BIN_DIR)/sops.symlink:
	$(SHIV) 'sops >= 1.18' \
		-c sops -o $@

$(BIN_DIR)/vex.symlink:
	$(SHIV) vex \
		-c vex -o $@
	mkdir -p $(COMPLETIONS_DIR)
	$@ --shell-config bash > $(COMPLETIONS_DIR)/vex

$(BIN_DIR)/black.symlink:
	$(SHIV) black \
		-c black -o $@

$(BIN_DIR)/blacken-docs.symlink:
	$(SHIV) blacken-docs \
		-c blacken-docs -o $@

$(BIN_DIR)/flit.symlink:
	$(SHIV) flit \
		-c flit -o $@

$(BIN_DIR)/nox.symlink:
	$(SHIV) nox-automation \
		-c nox -o $@

$(BIN_DIR)/bowler.symlink:
	$(SHIV) bowler \
		-c bowler -o $@

$(BIN_DIR)/yesqa.symlink:
	$(SHIV) yesqa \
		-c yesqa -o $@

$(BIN_DIR)/pyupgrade.symlink:
	$(SHIV) pyupgrade \
		-c pyupgrade -o $@

$(BIN_DIR)/structurediff.symlink:
	$(SHIV) structurediff \
		-c structurediff -o $@

$(BIN_DIR)/identify-cli.symlink:
	$(SHIV) identify \
		-c identify-cli -o $@

Brewfile: $(shell brew --prefix) /Applications
	brew bundle dump --describe --force --no-restart

~/.fzf.bash:
	fzf --version || brew install fzf
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
