#!/bin/bash
set -e

if [[ ! -d ~/.autoenv ]]; then
    git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
fi
if [[ ! -d ~/.venvburrito ]]; then
    curl -s https://raw.github.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL
fi

pip install --user see requests beautifulsoup4
