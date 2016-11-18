BIN_DIR = .local/bin
PEX_RELEASE = https://github.com/pantsbuild/pex/releases/download/v1.1.15/pex27

PEXES = pex tox flake8 ipython http sphobjinv coverage pycobertura isort \
	codemod twine cookiecutter credstash futurize yamllint

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
	pex 'flake8>=3.2.0' setuptools flake8-plone-hasattr flake8-comprehensions \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	pex ipython \
		-c ipython -o $@

$(BIN_DIR)/http.symlink:
	pex httpie \
		-c http -o $@

$(BIN_DIR)/sphobjinv.symlink:
	pex sphobjinv \
		-c sphobjinv -o $@

$(BIN_DIR)/coverage.symlink:
	pex coverage \
		-c coverage -o $@

$(BIN_DIR)/pycobertura.symlink:
	pex pycobertura \
		-c pycobertura -o $@

$(BIN_DIR)/isort.symlink:
	pex isort setuptools \
		-c isort -o $@

$(BIN_DIR)/codemod.symlink:
	pex codemod \
		-c codemod -o $@

$(BIN_DIR)/twine.symlink:
	pex twine \
		-c twine -o $@

$(BIN_DIR)/cookiecutter.symlink:
	pex cookiecutter \
		-c cookiecutter -o $@

$(BIN_DIR)/credstash.symlink:
	pex credstash \
		-c credstash -o $@

$(BIN_DIR)/futurize.symlink:
	pex future \
		-c futurize -o $@

$(BIN_DIR)/yamllint.symlink:
	pex yamllint \
		-c yamllint -o $@
