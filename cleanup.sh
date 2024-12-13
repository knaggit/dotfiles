#!/bin/bash

# Homebrew
brew cleanup --prune=all

# Nix
nix-store --gc
