# knaggit's dotfiles
## Intro

This repository is managed with [Nix](https://nixos.org/) and [Nix-darwin](https://github.com/LnL7/nix-darwin). It's based on repositories from [niklasravnsborg](https://github.com/niklasravnsborg) and [drdruh](https://github.com/drduh).

## Precautions

- Admin account is not used for day-to-day work, as recommend by Apple[^1][^3] itself.

## Initial Setup

- Create and login to admin account
- Create standard account, logout from admin account, login in standard account
- [Install Nix](https://github.com/DeterminateSystems/nix-installer)
- [Install Homebrew](https://brew.sh/)
- Clone this repo to `~/Git/dotfiles`
- Run `nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/Git/dotfiles`
- Run `softwareupdate -ia` for softare updates
- Do a system cleanup `softwareupdate -ia`

## Hardening[^3]

### macOS

Regarding to [Apple's Best Practices](https://support.apple.com/en-us/102099) hide admin & home dir
`sudo dscl . create /Users/hiddenuser IsHidden 1`
`sudo chflags hidden /Users/hiddenuser`
<pre>sudo dscl<br>
delete Local/Defaults/SharePoints/Hidden\ User’s\ Public\ Folder/<br>
exit</pre>

### GPG
`gpg --import /Users/knaggit/Git/dotfiles/gpg/0x7426E2F78A84EB06_knaggit.asc`

`export KEYID=0x7426E2F78A84EB06`

<pre>launchctl load $HOME/Library/LaunchAgents/gnupg.gpg-agent-symlink.plist<br>
nano $HOME/Library/LaunchAgents/gnupg.gpg-agent-symlink.plist<br>
launchctl load $HOME/Library/LaunchAgents/gnupg.gpg-agent.plist<br>
nano $HOME/Library/LaunchAgents/gnupg.gpg-agent.plist</pre>

`gpg-connect-agent /bye`

`git config --global user.signingkey $KEYID`

### SSH

## Daily Usage

### Connect with public network
- Deactivate NextDNS: `nextdns deactivate`
- Connect to network
- Clear DNS cache: `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
- Reactivate NextDNS: `nextdns activate`

## References
[^1]: [Ways to avoid harmful software](https://help.apple.com/machelp/mac/10.12/index.html#/mh11389)
[^2]: [Yubikey-Guide](https://github.com/drduh/YubiKey-Guide)
[^3]: [macOS-Security-and-Privacy-Guide](https://github.com/drduh/macOS-Security-and-Privacy-Guide)