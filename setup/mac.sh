#!/bin/bash
set -e

echo "prerequisites: sudo access, xcode/command-line tools"
read -p "continue? (y/n) "
if [[ $REPLY  != [yY] ]]; then
    echo "exiting mac setup"
    exit 0
fi

# appropriate path for homebrew
export PATH=/usr/local/bin:$PATH

# install brew
which brew || ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

# install some things
which git || brew install git
which hg || brew install mercurial
which ack || brew install ack
which tmux || brew install tmux

if ! brew ls node &> /dev/null; then brew install node; fi
if ! brew ls python &> /dev/null; then brew install python --framework; fi
if ! brew ls fishfish &> /dev/null; then brew install fishfish; fi

if [[ ! `grep /usr/local/bin/fish /etc/shells` ]]; then
    echo "adding fish to /etc/shells (will prompt for sudo):"
    sudo echo "/usr/local/bin/fish" >> /etc/shells
fi

echo "mac setup done."
