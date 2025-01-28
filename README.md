# Intro

This repository is managed with [Nix](https://nixos.org/) and [Nix-darwin](https://github.com/LnL7/nix-darwin). All design is mainly considered with macOS. It's based on repositories from [niklasravnsborg](https://github.com/niklasravnsborg) and [drdruh](https://github.com/drduh).

# Preliminary Considerations

## Design
There is always a lot of ways how to do stuff and what someone is prefering. All software and configuration is thought in a way of **OpSec, CLI, keyboard-interactive and Versioning** first. It's nerdy, fast, customizable as hell and aesthetic.

## What software is used?
* [kitty](https://sw.kovidgoyal.net/kitty/) OR [ghostty](https://ghostty.org/) with [tmux](https://github.com/tmux/tmux/wiki) for CLI
* [neovim](https://neovim.io/) as IDE (with nerdtree, coc, copilot and themes)
* [lazygit](https://github.com/jesseduffield/lazygit) for Git
* PGP, Smartcards and age/pass/sops for Encryption
* Git for Versioning 
* [NeoMutt](https://neomutt.org/) with [lbdb](https://www.spinnaker.de/lbdb/) and PGP for Mail
* [khal](https://khal.readthedocs.io/en/latest/configure.html#help-with-initial-configuration) with [vdirsyncer](https://vdirsyncer.pimutils.org/en/stable/) for Calendar

# Requirements

This repository requires that you already have created a PKI pair of keys and stored them in the most secure place (like a SmartCard). If not, consider following the YubiKey Guide.[^2]

# Initial Setup

Admin account is not used for day-to-day work, as recommend by Apple[^1][^3] itself.

- Create and login to admin account
- Create standard account, logout from admin account, login in standard account
- [Install Nix](https://github.com/DeterminateSystems/nix-installer)
- [Install Homebrew](https://brew.sh/)
- Clone this repo to `~/Git/dotfiles`
- Run `nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/Git/dotfiles`
- Run `softwareupdate -ia` for softare updates
- Do a system cleanup `softwareupdate -ia`

# Hardening[^3]

## Secrets

It's strongly recommended to use a password manager of any sort. To use them there are some limits to consider. Therefore I decided to use a second password manager for configuration and encrypt these with my Yubikey.[^5]


## macOS

Regarding to [Apple's Best Practices](https://support.apple.com/en-us/102099) hide admin & home dir
`sudo dscl . create /Users/hiddenuser IsHidden 1`
`sudo chflags hidden /Users/hiddenuser`
<pre>sudo dscl<br>
delete Local/Defaults/SharePoints/Hidden\ User’s\ Public\ Folder/<br>
exit</pre>

## GPG
`gpg --import /Users/knaggit/Git/dotfiles/gpg/0x7426E2F78A84EB06_knaggit.asc`

`export KEYID=0x7426E2F78A84EB06`

<pre>launchctl load $HOME/Library/LaunchAgents/gnupg.gpg-agent-symlink.plist<br>
nano $HOME/Library/LaunchAgents/gnupg.gpg-agent-symlink.plist<br>
launchctl load $HOME/Library/LaunchAgents/gnupg.gpg-agent.plist<br>
nano $HOME/Library/LaunchAgents/gnupg.gpg-agent.plist</pre>

`gpg-connect-agent /bye`

`git config --global user.signingkey $KEYID`

## SSH

## Secrets

age, pass (with PGP), sops (age)

# Daily Usage

## Key Bindings

### neomutt
### lazygit
### tmux

## Connect with public network
- Deactivate NextDNS: `nextdns deactivate`
- Connect to network
- Clear DNS cache: `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
- Reactivate NextDNS: `nextdns activate`

# References
[^1]: [Ways to avoid harmful software](https://help.apple.com/machelp/mac/10.12/index.html#/mh11389)
[^2]: [Yubikey-Guide](https://github.com/drduh/YubiKey-Guide)
[^3]: [macOS-Security-and-Privacy-Guide](https://github.com/drduh/macOS-Security-and-Privacy-Guide)
[^4]: [Using mutt on OS X](https://annvix.com/using_mutt_on_os_x)
[^5]: [Neomutt GNUpg and Pass Howto](https://hispagatos.org/post/neomutt-gpg-howto/)