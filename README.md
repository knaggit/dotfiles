# Niks dotfiles

This is my personal dotfiles repository. It is managed with [Nix](https://nixos.org/) and [Nix-darwin](https://github.com/LnL7/nix-darwin). I use these dotfiles on macOS and on NixOS. But this guide is only for macOS.

## Installation

- [Install Nix](https://github.com/DeterminateSystems/nix-installer)
- Clone this repo to `~/dotfiles`
- Run `nix run nix-darwin -- switch --flake ~/dotfiles`

## Personal Setup Checklist

- Setup Dropbox
- Import GPG Key with `gpg --import Secret.asc`
- Import uBlock setting via the import features in browser
- Import TablePlus Connections
- Import Timemator History from `~/Application Support/com.catforce.timemator.macos`

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
