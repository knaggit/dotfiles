## Setup

- Run `install.sh`.
- Change default shell: `chsh -s $(which fish)`
- Import uBlock setting via the import features in browser

## Brew

Install from Brewfile: `brew bundle --file=~/dotfiles/macos/Brewfile`  
Dump to Brewfile: `brew bundle dump --file=~/dotfiles/macos/Brewfile --describe --force`  
Match Brewfile: `brew bundle --file=~/dotfiles/macos/Brewfile cleanup`  

Housekeeping with Brew: https://mac.install.guide/homebrew/8.html

## System software update

`softwareupdate -ia`

## SSH Setup

Generate new keyfile: `ssh-keygen -t ed25519 -C "niklasravnsborg@gmail.com"`  
Change password: `ssh-keygen -p -f ~/.ssh/id_ed25519`  
Add password to keychain: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`  

## Connect with public network

- Deactivate NextDNS: `nextdns deactivate`
- Connect to network
- Clear DNS cache: `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
- Reactivate NextDNS: `nextdns activate`

## PDF Printer Driver

Install PDFWriter: https://github.com/rodyager/RWTS-PDFwriter

## Install Fish

https://gist.github.com/gagarine/cf3f65f9be6aa0e105b184376f765262
