#!/bin/bash
# WORK IN PROGRESS
# MAJOR POTENTIAL FOR EXPLOSIONS
# <http://andyfreeland.net/setup.sh>

set -e
cd "`dirname "$0"`"

if [[ `uname -s` == "Darwin" ]]; then
    if [[ ! -f mac.sh ]]; then
        curl -Os https://raw.github.com/rouge8/dotfiles/master/setup/mac.sh
    fi
    bash mac.sh
elif [[ `uname -s` == "Linux" ]]; then
    if [[ ! -f linux.sh ]]; then
        curl -Os https://raw.github.com/rouge8/dotfiles/master/setup/linux.sh
    fi
    bash linux.sh
fi

# dotfiles
if [[ ! -d "$HOME/.dotfiles.base" ]]; then
    git clone git://github.com/rouge8/dotfiles-base.git ~/.dotfiles.base
    ~/.dotfiles.base/bin/dotfiles.symlink install
fi

if [[ ! -d "$HOME/.dotfiles.public" ]]; then
    git clone https://github.com/rouge8/dotfiles.git ~/.dotfiles.public
fi

~/bin/dotfiles install

# install vim bundles
vim -u ~/.bundles.vim +BundleInstall +q +q

# install cross-platform tools
if [[ ! -f all.sh ]]; then
    curl -Os https://raw.github.com/rouge8/dotfiles/master/setup/all.sh
fi
bash all.sh

# any additional OS specific tasks
if [[ `uname -s` == "Darwin" ]]; then
    export PATH=/usr/local/bin:$PATH
elif [[ `uname -s` == "Linux" ]]; then
    : # currently, do nothing
fi

echo "done."
