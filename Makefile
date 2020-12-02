DOTFILES_BIN = .local/bin
BIN = ~/$(DOTFILES_BIN)
COMPLETIONS_DIR = ~/.bash_completion.d
PYTHON = $(shell brew --prefix python@3.9)/bin/python3.9 -sE

SHIVS = shiv \
	virtualenv \
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
	identify-cli \
	pyproject-build

.PHONY: all clean $(SHIVS)

.PRECIOUS: $(DOTFILES_BIN)/%.symlink

all: $(SHIVS) Brewfile ~/.fzf.bash $(COMPLETIONS_DIR)/vex

clean:
	$(RM) $(addprefix $(BIN)/,$(SHIVS))
	$(RM) $(addprefix $(DOTFILES_BIN)/,$(addsuffix .symlink,$(SHIVS)))

$(SHIVS): % : $(BIN)/%

$(BIN)/%: $(DOTFILES_BIN)/%.symlink
	dotfiles install

$(DOTFILES_BIN)/%.symlink: $(BIN)/shiv
	shiv --python "$(PYTHON)" $(or $(DEPS),$*) \
		--console-script $(basename $(notdir $@)) \
		--output-file $@

$(DOTFILES_BIN)/shiv.symlink:
	VENV_DIR=$$(mktemp -d) && \
	$(PYTHON) -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

flake8: DEPS = flake8 flake8-comprehensions flake8-bugbear flake8-docstrings

ipython: DEPS = ipython requests attrs

twine: DEPS = twine readme_renderer[md]

nox: DEPS = nox-automation

identify-cli: DEPS = identify

pyproject-build: DEPS = build

$(COMPLETIONS_DIR)/vex: $(BIN)/vex
	mkdir -p $(dir $@)
	$< --shell-config bash > $@

Brewfile: $(shell brew --prefix)/Cellar/* $(shell brew --prefix)/Caskroom/*
	brew bundle dump --describe --force --no-restart

~/.fzf.bash:
	fzf --version || brew install fzf
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc
