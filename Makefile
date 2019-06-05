BIN_DIR = .local/bin

SHIVS = shiv \
	tox \
	ipython \
	vex \
	http \
	flake8 \
	isort \
	codemod \
	twine \
	cookiecutter \
	yamllint \
	check-manifest \
	sops \
	black \
	blacken-docs \
	flit \
	nox \
	bowler \
	yesqa

.PHONY: all clean

SHIV = shiv --python "/usr/local/bin/python3.7 -sE"

all: $(SHIVS)

clean:
	for shiv in $(SHIVS); do \
		rm $(BIN_DIR)/$$shiv.symlink; \
	done

%: $(BIN_DIR)/%.symlink
	dotfiles install

$(BIN_DIR)/shiv.symlink:
	# Build shiv with pip 19.1.1 with https://github.com/pypa/pip/pull/6008
	VENV_DIR=$$(mktemp -d) && \
	python3 -m venv "$${VENV_DIR}" && \
	"$${VENV_DIR}/bin/pip" install shiv && \
	PIP_NO_CACHE_DIR=1 "$${VENV_DIR}/bin/shiv" https://github.com/pypa/pip/archive/287aa4b7bf88c7ccc237a68165ce29511e3193fa.zip shiv -c shiv -o $@ ; \
	rm -rf "$${VENV_DIR}"

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
