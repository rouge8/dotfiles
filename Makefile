BIN_DIR = .local/bin

SHIVS = tox flake8 ipython ipython3 http sphobjinv coverage pycobertura isort \
	codemod twine cookiecutter futurize yamllint check-manifest sops vex

.PHONY: all clean

SHIV2 = shiv -p $(shell which python2.7)
SHIV3 = shiv -p $(shell which python3.6)

all: $(SHIVS)

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN_DIR)/$$shiv.symlink; \
	done

%: $(BIN_DIR)/%.symlink
	dotfiles install

$(BIN_DIR)/tox.symlink:
	$(SHIV3) tox \
		-c tox -o $@

$(BIN_DIR)/flake8.symlink:
	$(SHIV2) 'flake8>=3.2.0' flake8-plone-hasattr flake8-comprehensions flake8-docstrings flake8-commas \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	$(SHIV2) ipython \
		-c ipython -o $@

$(BIN_DIR)/ipython3.symlink:
	$(SHIV3) ipython \
		-c ipython -o $@

$(BIN_DIR)/http.symlink:
	$(SHIV3) httpie \
		-c http -o $@

$(BIN_DIR)/sphobjinv.symlink:
	$(SHIV3) sphobjinv \
		-c sphobjinv -o $@

$(BIN_DIR)/coverage.symlink:
	$(SHIV3) coverage \
		-c coverage -o $@

$(BIN_DIR)/pycobertura.symlink:
	$(SHIV3) pycobertura \
		-c pycobertura -o $@

$(BIN_DIR)/isort.symlink:
	$(SHIV3) isort \
		-c isort -o $@

$(BIN_DIR)/codemod.symlink:
	$(SHIV2) 'codemod>=1.0' \
		-c codemod -o $@

$(BIN_DIR)/twine.symlink:
	$(SHIV3) twine \
		-c twine -o $@

$(BIN_DIR)/cookiecutter.symlink:
	$(SHIV3) cookiecutter \
		-c cookiecutter -o $@

$(BIN_DIR)/futurize.symlink:
	$(SHIV2) future \
		-c futurize -o $@

$(BIN_DIR)/yamllint.symlink:
	$(SHIV3) yamllint \
		-c yamllint -o $@

$(BIN_DIR)/check-manifest.symlink:
	$(SHIV3) check-manifest \
		-c check-manifest -o $@

$(BIN_DIR)/sops.symlink:
	$(SHIV2) sops \
		-c sops -o $@

$(BIN_DIR)/vex.symlink:
	$(SHIV2) vex \
		-c vex -o $@
