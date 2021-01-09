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

# Clock format
defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"

# Terminal.app
open -a Terminal.app misc/Gruvbox-dark.terminal
defaults write com.apple.terminal 'Default Window Settings' -string Gruvbox-dark
defaults write com.apple.terminal 'Startup Window Settings' -string Gruvbox-dark

# Divvy
open -a Divvy.app $(cat misc/divvy.txt)

# Remap Caps Lock to Left Control on the internal keyboard
osascript << EOF
tell application "System Preferences"
	activate
	delay 1
end tell

tell application "System Events"
	tell process "System Preferences"
		click menu item "Keyboard" of menu "View" of menu bar 1
		delay 1
		tell window "Keyboard"
			click button "Modifier Keys…" of tab group 1
			delay 1
			tell sheet 1
				click pop up button "Select keyboard:"
				click menu item "Apple Internal Keyboard / Trackpad" of menu 1 of pop up button "Select keyboard:"
				click pop up button "Caps Lock (⇪) Key:"
				click menu item "⌃ Control" of menu 1 of pop up button "Caps Lock (⇪) Key:"
				click button "OK"
			end tell
		end tell
	end tell
end tell

tell application "System Preferences"
	quit
end tell
EOF

# TODO: Remove once
# https://github.com/kovidgoyal/kitty/commit/a7e9030c12a6c623e480e9f65055fe8956a9ea3a
# is released
# Add /usr/local/bin to $PATH even for GUI apps
echo 'Updating $PATH...'
sudo launchctl config user path /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

# Restart Finder and Dock
killall Dock
killall Finder

# TODO: Dock layout
# TODO: keyboard input sources shortcuts
# TODO: keyboard input sources
# TODO: time machine menu bar
# TODO: things in menu bar that launch at startup
# TODO: hue app
