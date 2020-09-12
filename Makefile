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
	identify-cli

.PHONY: all clean $(SHIVS)

.PRECIOUS: $(DOTFILES_BIN)/%.symlink

all: $(SHIVS) Brewfile ~/.fzf.bash $(COMPLETIONS_DIR)/vex

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN)/$$shiv; \
		rm $(DOTFILES_BIN)/$$shiv.symlink; \
	done

$(SHIVS): % : $(BIN)/%

$(BIN)/%: $(DOTFILES_BIN)/%.symlink
	dotfiles install

$(DOTFILES_BIN)/%.symlink: $(BIN)/shiv
	shiv --python "/usr/local/bin/python3.8 -sE" $(or $(DEPS),$*) \
		--console-script $(basename $(notdir $@)) \
		--output-file $@

$(DOTFILES_BIN)/shiv.symlink:
	VENV_DIR=$$(mktemp -d) && \
	python3 -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

flake8: DEPS = flake8 flake8-comprehensions flake8-bugbear

ipython: DEPS = ipython requests attrs

twine: DEPS = twine readme_renderer[md]

nox: DEPS = nox-automation

identify-cli: DEPS = identify

$(COMPLETIONS_DIR)/vex: $(BIN)/vex
	mkdir -p $(dir $@)
	$< --shell-config bash > $@

Brewfile: $(shell brew --prefix) /Applications
	brew bundle dump --describe --force --no-restart

~/.fzf.bash:
	fzf --version || brew install fzf
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
