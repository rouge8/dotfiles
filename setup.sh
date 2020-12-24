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
make -j$(nproc)

# Make some directories
mkdir -p ~/tmp ~/forks

# Locally trusted SSL certificates
# https://github.com/FiloSottile/mkcert
mkcert -install

# Set fish as the login shell
FISH_BIN="$(brew --prefix)/bin/fish"
if ! grep -xq "$FISH_BIN" /etc/shells; then
  echo "Adding $FISH_BIN to /etc/shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_BIN"

# But configure Terminal.app to always use bash as a fallback
defaults write com.apple.terminal Shell /bin/bash

#######################
# macOS configuration #
#######################
echo "macOS configuration..."

# Scroll bars
defaults write -g AppleShowScrollBars Always

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write -g AppleShowAllExtensions -bool true

# Dock
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 100

# Keyboard
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# No Natural scrollng
defaults write -g com.apple.swipescrolldirection -bool false

# Screensaver and lock screen
defaults -currentHost write com.apple.screensaver idleTime -int 1200 # 20 minutes
echo Configuring "Require password immediately after screensaver"...
sysadminctl -screenLock immediate -password -

# Restart Finder and Dock
killall Dock
killall Finder

# TODO: Dock layout
# TODO: Divvy
# TODO: capslock -> ctrl on internal keyboard
# TODO: keyboard input sources shortcuts
# TODO: keyboard input sources
# TODO: time machine menu bar
