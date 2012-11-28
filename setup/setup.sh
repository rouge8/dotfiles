#!/bin/bash
# WORK IN PROGRESS
# MAJOR POTENTIAL FOR EXPLOSIONS

set -e
cd "`dirname "$0"`"

if [[ `uname -s` == "Darwin" ]]; then
    ./mac.sh
elif [[ `uname -s` == "Linux" ]]; then
    ./linux.sh
fi

# dotfiles
if [[ ! -d "$HOME/.dotfiles.base" ]]; then
    git clone git://github.com/rouge8/dotfiles-base.git ~/.dotfiles.base
    ~/.dotfiles.base/bin/dotfiles.symlink install
fi

if [[ ! -d "$HOME/.dotfiles.public" ]]; then
    git clone git@github.com:rouge8/dotfiles.git ~/.dotfiles.public
fi

~/bin/dotfiles install

# install vim bundles
vim -u ~/.bundles.vim +BundleInstall +q +q

# install cross-platform tools
./all.sh

# any additional OS specific tasks
if [[ `uname -s` == "Darwin" ]]; then
    export PATH=/usr/local/bin:$PATH
elif [[ `uname -s` == "Linux" ]]; then
    : # currently, do nothing
fi

echo "done."
