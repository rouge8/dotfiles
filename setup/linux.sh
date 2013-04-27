#!/bin/bash
set -e

echo "prerequisites: sudo access"
read -p "continue? (y/n) "
if [[ $REPLY  != [yY] ]]; then
    echo "exiting linux setup"
    exit 0
fi

# install sooo many things
echo "installing software (will prompt for sudo)"
sudo apt-get install -y \
    ack-grep \
    git \
    python-pip \
    mercurial \
    tmux \
    vim \
    htop

# nodejs
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs npm

# install ack-grep as ack instead of ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

echo "linux setup done."
