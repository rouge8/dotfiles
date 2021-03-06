BIN = ~/.local/bin
BASH_COMPLETIONS_DIR = ~/.bash_completion.d
FISH_COMPLETIONS_DIR = ~/.config/fish/completions
PYTHON = $(shell brew --prefix python@3.9)/bin/python3.9 -sE

SHIVS = shiv \
	virtualenv \
	ipython \
	vex \
	flake8 \
	isort \
	twine \
	check-manifest \
	black \
	blacken-docs \
	flit \
	nox \
	identify-cli \
	pyproject-build

.PHONY: all clean $(SHIVS)

all: $(SHIVS) \
	Brewfile \
	$(BASH_COMPLETIONS_DIR)/vex $(FISH_COMPLETIONS_DIR)/vex.fish \
	~/.fzf.bash ~/.config/fish/functions/fzf_key_bindings.fish \
	$(FISH_COMPLETIONS_DIR)/volta.fish

clean:
	$(RM) $(addprefix $(BIN)/,$(SHIVS))

$(SHIVS): % : $(BIN)/%

$(BIN)/%: $(BIN)/shiv
	shiv --python "$(PYTHON)" $(or $(DEPS),$*) \
		--console-script $(basename $(notdir $@)) \
		--output-file $@

$(BIN)/shiv:
	VENV_DIR=$$(mktemp -d) && \
	$(PYTHON) -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" "pip >= 19.2" shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

flake8: DEPS = flake8 flake8-comprehensions flake8-bugbear flake8-docstrings

ipython: DEPS = 'ipython >= 7.20.0' requests attrs rich

twine: DEPS = twine readme_renderer[md]

nox: DEPS = nox-automation

identify-cli: DEPS = identify

pyproject-build: DEPS = build

vex: DEPS = https://github.com/rouge8/vex/archive/fix-fish-completion-macos.zip --no-cache-dir

$(BASH_COMPLETIONS_DIR)/vex: $(BIN)/vex
	mkdir -p $(dir $@)
	$< --shell-config bash > $@

$(FISH_COMPLETIONS_DIR)/vex.fish: $(BIN)/vex
	mkdir -p $(dir $@)
	$< --shell-config fish > $@

Brewfile: $(shell brew --prefix)/Cellar/* $(shell brew --prefix)/Caskroom/*
	brew bundle dump --mas --describe --force --no-restart

~/.fzf.bash ~/.config/fish/functions/fzf_key_bindings.fish:
	$(shell brew --prefix)/opt/fzf/install --completion --key-bindings --no-update-rc

$(FISH_COMPLETIONS_DIR)/volta.fish:
	volta completions fish > $@
