BIN_DIR = .local/bin

SHIVS = tox flake8 ipython http sphobjinv coverage pycobertura isort \
	codemod twine cookiecutter futurize yamllint check-manifest sops vex

.PHONY: all clean

SHIV = shiv -p $(shell which python3.6)

all: $(SHIVS)

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN_DIR)/$$shiv.symlink; \
	done

%: $(BIN_DIR)/%.symlink
	dotfiles install

$(BIN_DIR)/tox.symlink:
	$(SHIV) tox \
		-c tox -o $@

$(BIN_DIR)/flake8.symlink:
	$(SHIV) 'flake8>=3.2.0' flake8-plone-hasattr flake8-comprehensions flake8-docstrings flake8-commas \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	$(SHIV) ipython \
		-c ipython -o $@

$(BIN_DIR)/http.symlink:
	$(SHIV) httpie \
		-c http -o $@

$(BIN_DIR)/sphobjinv.symlink:
	$(SHIV) sphobjinv \
		-c sphobjinv -o $@

$(BIN_DIR)/coverage.symlink:
	$(SHIV) coverage \
		-c coverage -o $@

$(BIN_DIR)/pycobertura.symlink:
	$(SHIV) pycobertura \
		-c pycobertura -o $@

$(BIN_DIR)/isort.symlink:
	$(SHIV) isort \
		-c isort -o $@

$(BIN_DIR)/codemod.symlink:
	$(SHIV) 'codemod>=1.0' \
		-c codemod -o $@

$(BIN_DIR)/twine.symlink:
	$(SHIV) twine \
		-c twine -o $@

$(BIN_DIR)/cookiecutter.symlink:
	$(SHIV) cookiecutter \
		-c cookiecutter -o $@

$(BIN_DIR)/futurize.symlink:
	$(SHIV) future \
		-c futurize -o $@

$(BIN_DIR)/yamllint.symlink:
	$(SHIV) yamllint \
		-c yamllint -o $@

$(BIN_DIR)/check-manifest.symlink:
	$(SHIV) check-manifest \
		-c check-manifest -o $@

$(BIN_DIR)/sops.symlink:
	$(SHIV) sops \
		-c sops -o $@

$(BIN_DIR)/vex.symlink:
	$(SHIV) vex \
		-c vex -o $@
