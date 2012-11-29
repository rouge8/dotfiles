#!/bin/bash
set -e

echo "prerequisites: sudo access"
read -p "continue? (y/n) "
if [[ $REPLY  != [yY] ]]; then
    echo "exiting linux setup"
    $(exit 0)
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
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs npm

# fish
curl -O http://ridiculousfish.com/shell/files/fishfish_0.9.1_i386.deb
sudo dpkg -i fishfish_0.9.1_i386.deb
rm -f fishfish_0.9.1_i386.deb

# install ack-grep as ack instead of ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

echo "linux setup done."
