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
which htop || brew install htop
brew install bash-completion

if ! brew ls node &> /dev/null; then brew install node; fi
if ! brew ls python &> /dev/null; then brew install python --framework; fi

htop_binary=$(python -c "import os; print os.path.realpath('`which htop`')")
permissions=(`ls -l $htop_binary`)
if [[ $permissions != "-r-sr-xr-x" ]]; then
    echo "setting suid bit on htop (will prompt for sudo):"
    sudo chmod u+s $htop_binary
fi

# application preferences
# no more accidental quitting chrome
defaults write com.google.Chrome.plist 'NSUserKeyEquivalents = { "Quit Google Chrome" = "@~q"; };'

echo "mac setup done."
