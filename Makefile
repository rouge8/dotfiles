BIN_DIR = .local/bin

SHIVS = tox flake8 ipython http sphobjinv coverage pycobertura isort \
	codemod twine cookiecutter futurize yamllint check-manifest sops vex \
	black blacken-docs caniusepython3 snakeviz flit nox cfn-lint python-modernize \
	bowler yesqa

.PHONY: all clean

SHIV = shiv --python "/usr/local/bin/python3.7 -sE"

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
	$(SHIV) 'flake8>=3.2.0' flake8-plone-hasattr flake8-comprehensions flake8-bugbear \
		-c flake8 -o $@

$(BIN_DIR)/ipython.symlink:
	$(SHIV) ipython requests attrs \
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
	$(SHIV) twine 'readme_renderer[md]' \
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
	# sops 1.17 + https://github.com/mozilla/sops/pull/372
	$(SHIV) https://github.com/mozilla/sops/archive/21df5a6ba7b7a97be7a5f5658306625ba679f75a.zip \
		-c sops -o $@

$(BIN_DIR)/vex.symlink:
	$(SHIV) vex \
		-c vex -o $@

$(BIN_DIR)/black.symlink:
	$(SHIV) black \
		-c black -o $@

$(BIN_DIR)/blacken-docs.symlink:
	$(SHIV) blacken-docs \
		-c blacken-docs -o $@

$(BIN_DIR)/caniusepython3.symlink:
	$(SHIV) caniusepython3 \
		-c caniusepython3 -o $@

$(BIN_DIR)/snakeviz.symlink:
	$(SHIV) snakeviz \
		-c snakeviz -o $@

$(BIN_DIR)/flit.symlink:
	$(SHIV) flit \
		-c flit -o $@

$(BIN_DIR)/nox.symlink:
	$(SHIV) nox-automation \
		-c nox -o $@

$(BIN_DIR)/cfn-lint.symlink:
	$(SHIV) cfn-lint \
		-c cfn-lint -o $@

$(BIN_DIR)/python-modernize.symlink:
	$(SHIV) modernize \
		-c python-modernize -o $@

$(BIN_DIR)/bowler.symlink:
	$(SHIV) bowler \
		-c bowler -o $@

$(BIN_DIR)/yesqa.symlink:
	$(SHIV) yesqa \
		-c yesqa -o $@
