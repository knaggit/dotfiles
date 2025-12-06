{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  home = "/Users/knaggit";
  configDir = "${home}/Git/dotfiles";
  appicon = name: {
    path = "/Applications/${name}.app";
    icon = "${configDir}/macos/icons/${name}.icns";
  };
in
{
  # Disable management of the nix installation via nix-darwin since I'm using Determinate Nix
  nix.enable = false;

  # sops = {
  #   defaultSopsFile = "${home}/Git/config/secrets.yaml"; # Secrets Store
  #   age.keyFile = "${home}/.config/sops/age/keys.txt"; # Private Key
  #   validateSopsFiles = false; # temporary
  #   # Disable automatic key generation
  #   age.sshKeyPaths = [ ];
  #   gnupg.sshKeyPaths = [ ];

  #   secrets = {
  #     nextdns-config = { };
  #     # irssi = { };
  #   };
  # };

  # services.nextdns.enable = true;
  # # Manually start and stop the nextdns service with:
  # # `sudo launchctl bootout system /Library/LaunchDaemons/org.nixos.nextdns.plist`
  # # `sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nextdns.plist`
  # launchd.daemons.nextdns = {
  #   # Uncomment to enable logging
  #   # serviceConfig.StandardErrorPath = "/var/log/nextdns.log";
  #   # serviceConfig.StandardOutPath = "/var/log/nextdns.log";
  #   command = mkForce (
  #     toString (
  #       pkgs.writeShellScript "nextdns-config-watch" ''
  #         trap 'kill $(jobs -p); exit' SIGINT

  #         # `nextdns activate` depends on `launchctl` and `networksetup`
  #         export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

  #         # Make sure nextdns is activated
  #         ${pkgs.nextdns}/bin/nextdns activate

  #         while true; do
  #           # Start long-running nextdns process in the background
  #           ${pkgs.nextdns}/bin/nextdns run --config-file=${config.sops.secrets.nextdns-config.path} &
  #           nextdns_pid=$!

  #           # If the tmpfs is not yet mounted, the file watchers won't trigger on change
  #           # wait4path will exit when the path is mounted
  #           if ! [ -d /run/secrets.d/ ]; then
  #             echo "Secrets volume not yet mounted. This script will restart when it is."
  #             /bin/wait4path /run/secrets.d/ &
  #           elif ! [ -e /run/secrets/ ]; then
  #             echo "Secrets not yet created. Restart the script."
  #             exit &
  #           else
  #             # Monitor symlink and config file in background
  #             # fswatch will exit when those paths are modified
  #             ${pkgs.fswatch}/bin/fswatch -1 ${config.sops.secrets.nextdns-config.path} > /dev/null &
  #           fi

  #           # Wait for at least one process to exit
  #           wait -n
  #           exit_code=$?

  #           # Check if the nextdns process has exited
  #           if ! /bin/ps -p $nextdns_pid > /dev/null; then
  #             echo "Process has exited with code $exit_code. Exiting script."
  #             exit $exit_code
  #           fi

  #           # Kill all other running processes
  #           echo "A monitored file was changed. Restarting."
  #           pids=$(jobs -p)
  #           kill $pids 2> /dev/null
  #           wait $pids

  #           # Before restarting the loop, let's sleep for 100 ms
  #           echo "Restarting in 100 ms..."
  #           /bin/sleep 0.1
  #         done
  #       ''
  #     )
  #   );
  # };

  # Create sourcings for zsh and fish
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.knaggit.home = home;

  # Your Terminal emulator might need Full Disk Access to change icons for all applications
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

  system.primaryUser = "knaggit";

  # Enable Touch ID for sudo
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true; # Fixes Touch ID for sudo inside tmux and screen
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

  system.defaults.CustomUserPreferences = {
    NSGlobalDomain = {
      WebKitDeveloperExtras = true; # Add a context menu item for showing the Web Inspector in web views
      ApplePressAndHoldEnabled = true; # Enable key repeat when pressing and holding a key and set a fast repeat rate
      InitialKeyRepeat = 16;
      KeyRepeat = 2;

      AppleShowAllExtensions = true; # Show all filename extensions in Finder
      AppleShowAllFiles = true; # Whether to always show hidden files. The default is false.

      AppleSpacesSwitchOnActivate = true; # Enable switching to a space when an application is activated
    };
    "com.apple.finder" = {
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true;
      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";

      "com.apple.swipescrolldirection" = false;

      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.screencapture" = {
        location = "~/Desktop";
        type = "png";
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
    };
  };

  system.defaults.dock = {
    autohide = true; # automatically hide and show the Dock
    mineffect = "scale"; # Set the minimize/maximize window effect. The default is genie.
    mru-spaces = false; # Whether to automatically rearrange spaces based on most recent use. The default is true.
    orientation = "left"; # Position of the dock on screen. The default is “bottom”.
    show-recents = false; # Show recent applications in the dock.
    wvous-br-corner = 1; # Hot corner action for bottom right corner.
    #  persistent-apps = [
    #      "/Applications/Arc.app"
    #  ]
  };

  system.activationScripts.postActivation = {
    text = ''
      # Set default shell to fish
      sudo chsh -s /run/current-system/sw/bin/fish knaggit

      # Run the following script as user knaggit
      sudo -i -u knaggit bash <<'EOF'

        # Run batt service
        sudo brew services restart batt

        # Disable 'Select the previous input source', because I use Ctrl + Space in Tmux
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'

        # Disable 'Show Spotlight search', because I use Cmd + Space for Raycast
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'

        # Activate settings so we don't have to restart
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

        # Install keyboard shortcuts
        ${pkgs.bun}/bin/bun run --cwd=${configDir}/macos/karabiner/ build
        ${pkgs.bun}/bin/bun run --cwd=${configDir}/macos/phoenix/ build

        # Configure Final Cut to enable timeline rendering during playback
        defaults write com.apple.FinalCut FFSuspendBGOpsDuringPlay 0

        # Configure Apple Mail
        # defaults write com.apple.mail ShowCcHeader 0
        # defaults write com.apple.mail EnableContactPhotos 1
        # defaults write com.apple.mail NSFont SFPro-Regular
        # defaults write com.apple.mail NSFontSize 12

        # Disable autoupgrade - Use `brew cu -aqy` to upgrade apps
        defaults write com.DanPristupov.Fork SUEnableAutomaticChecks -bool false
        defaults write com.proxyman.NSProxy isUsingSystemStatusBar -bool false
        defaults write com.proxyman.NSProxy shouldShowUpdatePopup -bool false

      EOF
    '';
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # `zap` will move related files of apps that are removed to the trash
      # cleanup = "zap";
      # This will force an overwrite of apps already present
      extraFlags = [ "--force" ];
    };

    taps = [
      # Upgrade casks with `brew cu -aqy`
      "buo/cask-upgrade"
      "mongodb/brew"
    ];

    brews = [
      # Although we already have it in home-manager, this gpg binary is the only one that Fork can find
      "cloudflared" # Cloudflare Tunnel client (formerly Argo Tunnel)
      "asn" # OSINT command line tool for investigating network data
      "iftop" # Display an interface's bandwidth usage

      "irssi" # Modular IRC client
      # "mongodb-community@8.0"
      "neovim" # Ambitious Vim-fork focused on extensibility and agility
      "zbar" # Suite of barcodes-reading tools

      # Mail with PGP support
      "neomutt" # pain in the ass config + pgp support
      "lbdb" # Little brother's database for the mutt mail reader
      # mutt-wizard on a linux system can help

      # Überlegen zu home.nix zu verschieben
      # OpSec
      "libfido2" # Provides library functionality for FIDO U2F & FIDO 2.0, including USB (required for OpenSSH)
      "openssh" # Upgrades older OpenSSH of macOS
      "bitwarden-cli" # Secure and free password manager for all of your devices
      "gobuster" # Directory/file & DNS busting tool written in Go
      "httpx" # Fast and multi-purpose HTTP toolkit
      "subfinder" # Subdomain discovery tool
      "pass" # password manager for CLI (configurations)
      "pinentry-mac" # Pinentry for GPG on Mac
      "yubikey-personalization" # YubiKey personalization library and tool
      "ykman" # Tool for managing your YubiKey configuration
      "gnupg" # GNU Pretty Good Privacy (PGP) package
      "batt" # Battery manager
    ];

    casks = [
      # Fonts
      "font-dm-sans"
      "font-inter"
      "font-kumbh-sans"
      "font-lexend"
      "font-montserrat"
      "font-open-sans"
      "font-palanquin"
      "font-poppins"
      "font-roboto"
      "font-sf-pro"
      "font-source-sans-3"
      "font-space-grotesk"

      # Nerd Fonts
      "font-anonymous-pro"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-sauce-code-pro-nerd-font"

      # Work
      "figma" # Collaborative team software

      # OpSec
      "yubico-authenticator" # Application for generating TOTP and HOTP codes
      "yubico-yubikey-manager" # Application for configuring any YubiKey
      "wireshark" # Network protocol analyzer

      # Applications
      "anki" # Memory training application
      "arc" # Chromium based browser
      "audio-hijack" # Records audio from any application
      "balenaetcher" # Flashing tool for linux distros on USB
      "bitwarden" # Desktop password and login vault
      "coconutbattery" # Tool to show live information about the batteries in various devices
      "cursor" # Write, edit, and chat about your code with AI
      "cyberduck" # Server and cloud storage browser
      "daisydisk" # Disk space utility
      "discord" # Voice and text chat software
      "disk-drill" # Data recovery software
      "figma" # Collaborative team software
      "finicky" # Utility for customizing which browser to start
      "ghostty" # Terminal emulator that uses platform-native UI and GPU acceleration
      "imageoptim" # Tool to optimise images to a smaller size
      "istat-menus@6" # iStat Menus vor top bar metrics of all ways
      "kitty" # GPU-based terminal emulator
      "logi-options+" # Logitech mouse configuration
      "loopback" # Cable-free audio router
      "miro" # Online collaborative whiteboard platform
      "mos" # Smooths scrolling and set mouse scroll directions independently
      "musescore" # Open-source music notation software
      "nota" # Markdown files editor
      "notion" # App to write, plan, collaborate, and get organised
      "numi" # Calculator and converter application
      "omnigraffle" # Visual communication software
      "obsidian" # Knowledge base that works on top of a local folder of plain text Markdown files
      "qlmarkdown" # Quick Look generator for Markdown files
      "raindropio" # Bookmark manager
      "rwts-pdfwriter" # Print driver for printing documents directly to a pdf file
      "scroll-reverser" # Set mouse scroll directions independently
      "signal" # Instant messaging application focusing on security
      "timemator" # Automatic time-tracking application
      "the-unarchiver" # Unpacks archive files
      # "topnotch" # Utility to hide the notch
      "visual-studio-code" # Open-source code editor
      "vlc" # Multimedia player
      "yubico-authenticator" # Application for configuring YubiKeys
      "zoom" # Video communication and virtual meeting platform

      # Web browser
      "arc" # Chromium based browser
      # "chatgpt-atlas" # OpenAI's browser with ChatGPT built in
      "finicky" # Utility for customizing which browser to start
      # "firefox" # Web browser
      # "helium-browser" # Chromium based browser
      # "ungoogled-chromium" # Chromium based browser with privacy in mind

      # Graphic & Image Applications
      # "affinity" # Image editing and design software
      "figma" # Collaborative team software
      "imageoptim" # Tool to optimise images to a smaller size

      # Audio & Music Applications
      # "audacity" # Cross-platform audio software
      "blackhole-2ch" # Virtual Audio Driver
      "motu-m-series" # Driver for Motu M-Series audio interfaces
      "musescore" # Open-source music notation software
      # "native-access" # Installer for Native Instruments products

      # Productivity
      "anytype" # Local-first and end-to-end encrypted notes app
      # "craft" # Personal knowledge management
      # "missive" # Team inbox and chat tool
      # "nota" # Markdown files editor
      # "notion-calendar" # Calendar by Notion
      "notion" # App to write, plan, collaborate, and get organised
      "obsidian" # Knowledge base that works on top of a local folder of plain text Markdown files
      "raindropio" # Bookmark manager
      "karabiner-elements"

      # Development
      "bruno" # API client
      "cyberduck" # Server and cloud storage browser
      "dbngin" # Database version management tool
      "fork" # Git client
      "ghostty" # Terminal emulator that uses platform-native UI and GPU acceleration
      "kitty" # GPU-based terminal emulator
      # "orbstack" # Replacement for Docker Desktop
      "proxyman" # HTTP debugging proxy
      # "tableplus" # Native GUI tool for relational databases
      # "tuple" # Remote pair programming app
      # "visual-studio-code" # Open-source code editor
      # "warp" # Rust-based terminal
      "wireshark-app" # Network protocol analyzer
      "zed" # Code editor
    ];
  };

  system.stateVersion = 5;
}
