#!/bin/bash

# Download iTerm2 shell integration scripts
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
curl -L https://iterm2.com/shell_integration/fish -o ~/.iterm2_shell_integration.fish

# Tell iTerm2 to use the preferences of our dotfiles
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
