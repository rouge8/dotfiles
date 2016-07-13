BIN_DIR = .local/bin
PEX_RELEASE = https://github.com/pantsbuild/pex/releases/download/v1.1.12/pex27

PEXES = pex tox flake8 ipython http

.PHONY: all clean

all: $(PEXES)

clean:
	for pex in $(PEXES); do \
		rm $(BIN_DIR)/$$pex.symlink; \
	done

%: pex $(BIN_DIR)/%.symlink
	dotfiles install

$(BIN_DIR)/pex.symlink:
	curl -f -L $(PEX_RELEASE) -o $@
	chmod +x $@

$(BIN_DIR)/tox.symlink:
	pex tox \
		-c tox -o $@

$(BIN_DIR)/flake8.symlink:
	pex 'flake8<3' setuptools flake8-plone-hasattr pep8-naming \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	pex ipython \
		-c ipython -o $@

$(BIN_DIR)/http.symlink:
	pex httpie \
		-c http -o $@
