#!/bin/bash

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## Run these three commands in your terminal to add Homebrew to your PATH:
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install dependencies with brew
brew bundle --file=macos/Brewfile

echo "Link config files to home"
dotbot -c install.conf.yaml

echo "Install fisher dependencies"
fish -c "fisher update"

echo "Install zsh dependencies"
antidote load

echo "Setup iTerm2"
./iterm/setup.sh

echo "Configure macOS"
./macos/defaults.sh

# echo "Install custom keyboard"
# ./macos/keyboard.sh

# echo "Fix GPG pinentry"
# ./macos/pinentry.sh

# echo "Install tmux plugin manager"
# ./tmux/setup.sh

echo "Install tmux plugin manager"
./tmux/setup.sh
