# knaggit's dotfiles

This is my personal dotfiles repository. It is managed with [Nix](https://nixos.org/) and [Nix-darwin](https://github.com/LnL7/nix-darwin). I use these dotfiles on macOS and on NixOS. But this guide is only for macOS.

## Setup

- [Install Nix](https://github.com/DeterminateSystems/nix-installer)
- [Install Homebrew](https://brew.sh/)
- Clone this repo to `~/Git/dotfiles`
- Run `nix run nix-darwin -- switch --flake ~/Git/dotfiles`
- Import uBlock setting via the import features in browser

## System software update

`softwareupdate -ia`

## System cleanup

`./cleanup.sh`

## SSH Setup

Generate new keyfile: `ssh-keygen -t ed25519 -C "niklasravnsborg@gmail.com"`  
Change password: `ssh-keygen -p -f ~/.ssh/id_ed25519`  
Add password to keychain: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`

## Connect with public network

- Deactivate NextDNS: `nextdns deactivate`
- Connect to network
- Clear DNS cache: `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
- Reactivate NextDNS: `nextdns activate`
