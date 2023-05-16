#!/bin/bash
set -eu
set -o pipefail

# Brew
which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Dotfiles
[[ -d ~/.dotfiles.base ]] \
  || git clone git@github.com:rouge8/dotfiles-base.git ~/.dotfiles.base \
  && ~/.dotfiles.base/bin/dotfiles.symlink install
[[ -d ~/.dotfiles.public ]] \
  || git clone git@github.com:rouge8/dotfiles ~/.dotfiles.public \
  && ~/bin/dotfiles install

cd ~/.dotfiles.public

# Install 'em all
brew bundle install

# VirtualFish
vf install compat_aliases

# Rust
if [[ -f "$(brew --prefix)/bin/rust-analyzer" ]]; then
  rustup --version || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- --no-modify-path
  rustup toolchain install stable nightly
  rustup component add rust-src rustfmt clippy llvm-tools-preview
fi

# Python tools
pipx install ipython
pipx inject ipython requests attrs rich

pipx install twine
pipx inject twine readme_renderer[md]

pipx install black

pipx install blacken-docs

pipx install build

# Various things
make -j$(nproc)

# Make some directories
mkdir -p ~/tmp ~/forks
if [[ -d ~/Dropbox/Projects && ! -d ~/projects ]]; then
  ln -s ~/Dropbox/Projects/ ~/projects
fi

# Set fish as the login shell
FISH_BIN="$(brew --prefix)/bin/fish"
if ! grep -xq "$FISH_BIN" /etc/shells; then
  echo "Adding $FISH_BIN to /etc/shells..."
  echo "$FISH_BIN" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_BIN"

# But configure Terminal.app to always use bash as a fallback
defaults write com.apple.terminal Shell /bin/bash

# Poetry
poetry config virtualenvs.path "$HOME/.virtualenvs"

# Vim
fish -c vim-plug-install

# Docker
mkdir -p ~/.docker/cli-plugins
echo '{"credsStore": "osxkeychain"}' > ~/.docker/config.json
ln -sfn $(brew --prefix docker-buildx)/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx

#######################
# macOS configuration #
#######################
echo "macOS configuration..."

# Scroll bars
defaults write -g AppleShowScrollBars Always

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write -g AppleShowAllExtensions -bool true
chflags nohidden ~/Library

# Dock
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 100

# Keyboard
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
# Enable Tab in all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# No Natural scrollng
defaults write -g com.apple.swipescrolldirection -bool false

# Screensaver and lock screen
defaults -currentHost write com.apple.screensaver idleTime -int 1200 # 20 minutes
echo Configuring "Require password immediately after screensaver"...
sysadminctl -screenLock immediate -password -

# Terminal.app
open -a Terminal.app misc/Gruvbox-dark.terminal
defaults write com.apple.terminal 'Default Window Settings' -string Gruvbox-dark
defaults write com.apple.terminal 'Startup Window Settings' -string Gruvbox-dark

# Moom
defaults import com.manytricks.Moom misc/Moom.plist

# TODO: Remove once
# https://github.com/kovidgoyal/kitty/commit/a7e9030c12a6c623e480e9f65055fe8956a9ea3a
# is released
# Add /usr/local/bin to $PATH even for GUI apps
echo 'Updating $PATH...'
sudo launchctl config user path /usr/bin:/bin:/usr/sbin:/sbin:$(brew --prefix)/bin

# Restart Finder and Dock
killall Dock
killall Finder

# Menu bar
open /System/Library/CoreServices/Menu\ Extras/TimeMachine.menu
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"

# TODO: Dock layout
# TODO: keyboard input sources shortcuts
# TODO: keyboard input sources
# TODO: time machine menu bar
# TODO: things in menu bar that launch at startup
# TODO: hue app

set +x
echo
echo
echo
echo "TODO: Open System Preferences > Keyboard > Modifier Keys to remap capslock to control"
echo
echo "If this is a personal computer, run 'brew bundle install --file Brewfile.home' and re-run '~/.dotfiles.public/setup.sh' to complete installation."
