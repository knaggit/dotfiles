{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  home = "/Users/knaggit";
  appicon = name: {
    path = "/Applications/${name}.app";
    icon = "${home}/dotfiles/macos/icons/${name}.icns";
  };
in
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;

  services.nextdns.enable = true;
  launchd.daemons.nextdns = {
    # Uncomment to enable logging
    # serviceConfig.StandardErrorPath = "/var/log/nextdns.log";
    # serviceConfig.StandardOutPath = "/var/log/nextdns.log";
    command = mkForce (
      toString (
        pkgs.writeShellScript "nextdns-config-watch" ''
          trap 'kill $(jobs -p); exit' SIGINT

          while true; do
            # Start long-running nextdns process in the background
            ${pkgs.nextdns}/bin/nextdns run --config-file=/Users/knaggit/Git/nongit/nextdns-config &
            nextdns_pid=$!

            # If the tmpfs is not yet mounted, the file watchers won't trigger on change
            # wait4path will exit when the path is mounted
            if ! [ -d /run/secrets.d/ ]; then
              echo "Secrets volume not yet mounted. This script will restart when it is."
              /bin/wait4path /run/secrets.d/ &
            fi

            # Monitor symlink and config file in background
            # fswatch will exit when those paths are modified
            ${pkgs.fswatch}/bin/fswatch -1 /Users/knaggit/Git/nongit/nextdns-config > /dev/null &

            # Wait for at least one process to exit
            wait -n
            exit_code=$?

            # Check if the nextdns process has exited
            if ! /bin/ps -p $nextdns_pid > /dev/null; then
              echo "Process has exited with code $exit_code. Exiting script."
              exit $exit_code
            fi

            # Kill all other running processes
            echo "A monitored file was changed. Restarting."
            pids=$(jobs -p)
            kill $pids 2> /dev/null
            wait $pids

            # Before restarting the loop, let's sleep for 100 ms
            echo "Restarting in 100 ms..."
            /bin/sleep 0.1
          done
        ''
      )
    );
  };

  # Create sourcings for zsh and fish
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.knaggit.home = home;

  environment.customIcons = {
    enable = true;
    icons = map appicon [
      "calibre"
      "ImageOptim"
      "LogSeq"
      "Notion"
      "Visual Studio Code"
    ];
  };

  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv"; # Always open everything in list view
    ShowStatusBar = true; # Show status bar
    ShowPathbar = true; # Show path bar
    _FXSortFoldersFirst = true; # Keep folders on top when sorting by name
    FXEnableExtensionChangeWarning = false; # Disable the warning when changing a file extension
    FXDefaultSearchScope = "SCcf"; # When performing a search, search the current folder by default
  };

  system.defaults.trackpad = {
    Clicking = true; # Enable tap to click
    TrackpadThreeFingerDrag = true; # Enable three finger drag
  };

  system.defaults.NSGlobalDomain = {
    # Enable key repeat when pressing and holding a key and set a fast repeat rate
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 16;
    KeyRepeat = 2;

    AppleShowAllExtensions = true; # Show all filename extensions in Finder

    AppleSpacesSwitchOnActivate = false; # Disable switching to a space when an application is activated

    "com.apple.swipescrolldirection" = false;
  };

  system.defaults.dock = {
    autohide = true; # automatically hide and show the Dock
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.activationScripts.postUserActivation = {
    text = ''
      # Set default shell to fish
      sudo chsh -s /run/current-system/sw/bin/fish knaggit

      # Disable "Select the previous input source", because I use Ctrl + Space in Tmux
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'

      # Disable "Show Spotlight search", because I use Cmd + Space for Raycast
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><true/></dict>'

      # Activate settings so we don't have to restart
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      # Upgrade casks with `brew cu -a`
      "buo/cask-upgrade"
      "mongodb/brew"
    ];

    brews = [
      # Although we already have it in home-manager, this gpg binary is the only one that Fork can find
      "cloudflared" # Cloudflare Tunnel client (formerly Argo Tunnel)
      "gnupg" # GNU Pretty Good Privacy (PGP) package
      "gobuster" # Directory/file & DNS busting tool written in Go
      "mongodb-community@8.0"
      "neomutt" # E-mail reader with support for Notmuch, NNTP and much more
      "neovim" # Ambitious Vim-fork focused on extensibility and agility
      "pinentry-mac" # Pinentry for GPG on Mac
      "subfinder" # Subdomain discovery tool
      "yubikey-personalization" # YubiKey personalization library and tool
      "ykman" # Tool for managing your YubiKey configuration
      "zbar" # Suite of barcodes-reading tools
    ];

    casks = [
      # Fonts
      "font-dm-sans"
      "font-inter"
      "font-kumbh-sans"
      "font-lexend"
      "font-montserrat"
      "font-open-sans"
      "font-poppins"
      "font-palanquin"
      "font-roboto"
      "font-space-grotesk"
      "font-source-sans-3"

      # Nerd Fonts
      "font-jetbrains-mono-nerd-font"
      "font-sauce-code-pro-nerd-font"
      "font-hack-nerd-font"
      "font-anonymous-pro"

      # Applications
      "arc" # Chromium based browser
      "audio-hijack" # Records audio from any application
      "balenaetcher" # Flashing tool for linux distros on USB
      "bitwarden" # Desktop password and login vault
      "blackhole-2ch" # Virtual Audio Driver
      "cursor" # Write, edit, and chat about your code with AI
      "cyberduck" # Server and cloud storage browser
      "daisydisk" # Disk space utility
      "discord" # Voice and text chat software
      "finicky" # Utility for customizing which browser to start
      # "geotag"
      "imageoptim" # Tool to optimise images to a smaller size
      "istat-menus@6" # iStat Menus vor top bar metrics of all ways
      "kitty" # GPU-based terminal emulator
      "logi-options+" # Logitech mouse configuration
      "loopback" # Cable-free audio router
      "mos" # Smooths scrolling and set mouse scroll directions independently
      "musescore" # Open-source music notation software
      "nota" # Markdown files editor
      "notion" # App to write, plan, collaborate, and get organised
      "numi" # Calculator and converter application
      "qlmarkdown" # Quick Look generator for Markdown files
      "raindropio" # Bookmark manager
      "rwts-pdfwriter" # Print driver for printing documents directly to a pdf file
      "signal" # Instant messaging application focusing on security
      "timemator" # Automatic time-tracking application
      "the-unarchiver" # Unpacks archive files
      "topnotch" # Utility to hide the notch
      "visual-studio-code" # Open-source code editor
      "vlc" # Multimedia player
      "wireshark" # Network protocol analyzer
      "zoom" # Video communication and virtual meeting platform
    ];
  };

  system.stateVersion = 5;
}
