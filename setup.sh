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

# Python shivs and other things
make

# Make some directories
mkdir -p ~/tmp ~/forks

# Locally trusted SSL certificates
# https://github.com/FiloSottile/mkcert
mkcert -install

# Set fish as the login shell
FISH_BIN="$(brew --prefix)/bin/fish"
echo "$FISH_BIN" | sudo tee -a /etc/shells
chsh -s "$FISH_BIN"

# TODO: plist shenanigans for system settings? dock? application settings? divvy?
