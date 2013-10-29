#!/bin/bash
set -e

# autoenv
if [[ ! -d ~/.autoenv ]]; then
    git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
fi

# venvburrito
if [[ ! -d ~/.venvburrito ]]; then
    curl -s https://raw.github.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL
fi

# python packages
sudo pip install ipython pyflakes

# node packages
npm install -g less jshint coffee-script
