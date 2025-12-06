#!/bin/bash

# Add bun bin
PATH=$PATH:$HOME/.bun/bin

# Disable brew auto update
export HOMEBREW_NO_AUTO_UPDATE=true

# Set Helix editor
export EDITOR=hx

# Set Docker default platform - fixes issue with M1 Macs
export DOCKER_DEFAULT_PLATFORM=linux/amd64
