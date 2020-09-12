#!/bin/bash
set -eux
set -o pipefail

# Brew
which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Dotfiles
[[ -d ~/.dotfiles.base ]] \
  || git clone git@github.com:rouge8/dotfiles-base.git ~/.dotfiles.base \
  && ~/.dotfiles.base/bin/dotfiles.symlink install
[[ -d ~/.dotfiles.public ]] \
  || git clone git@github.com:rouge8/dotfiles ~/.dotfiles.public \
  && dotfiles install

cd ~/.dotfiles.public

# Reload
set +eu
. ~/.bash_profile
set -eu

# Install 'em all
brew bundle install

# Rust
rustup --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path

# Python shivs
make

# virtualenv
PIP_REQUIRE_VIRTUALENV="" python3 -m pip install virtualenv

# TODO: plist shenanigans for system settings? dock? application settings? divvy?
