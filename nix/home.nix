{
  pkgs,
  config,
  lib,
  ...
}:

let
  shellAliases = {
    # Set the `TERM` env var to fix color display with `delta` as long as lazygit doesn't support Ghostty.
    # Relevant Pull Request: https://github.com/jesseduffield/lazygit/pull/4149
    lg = "TERM=xterm-256color lazygit";
    man = "batman";
    nix-switch =
      if pkgs.stdenv.isDarwin then
        "sudo darwin-rebuild switch --flake ~/Git/dotfiles"
      else
        "sudo nixos-rebuild switch --flake ~/Git/dotfiles";
    svgo = "svgo --config=$HOME/.svgo.config.js";
    wifi = "nextdns deactivate; open http://neverssl.com; read -P 'Continue? '; nextdns activate";
    ffmpeg = "ffmpeg -hide_banner";
    cat = "bat -p";

    # Shortcuts
    c = "clear";
    o = "open .";
    dot = "hx ~/dotfiles";
  };
  homePath = config.home.homeDirectory;
  configDir = "${homePath}/Git/dotfiles";
  dotfile = file: {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/${file}";
  };
in
{
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # osint
    mtr # Network diagnostics tool
    # ngrok # Reverse proxy, secure tunnels to localhost
    trippy # # Network diagnostic tool

    #   act # Run GitHub Actions locally
    age # Secure file encryption
    any-nix-shell # Run nix-shell in any directory
    atuin # Universal history
    btop # Monitor of resources
    bun # Incredibly fast JavaScript runtime
    cloc # Count lines of code
    cloudflared # Cloudflare tunnel
    delta # Syntax-highlighter for git and diff output
    exiftool # EXIF tool for file with EXIF data (photos)
    # fast-cli # Test your download and upload speed using fast.com
    #   fd # Alternative to find
    ffmpeg_7 # Play, record, convert, and stream audio and video
    gh # GitHub command-line tool
    git # Version control system
    gitui # Terminal ui for git
    gnused # GNU version of the famous stream editor
    gnutar # GNU version of the tar archiving utility
    helix # Post-modern modal text editor
    #   htop # Improved top (interactive process viewer)
    #   httpie # User-friendly HTTP client
    #   imagemagick # Manipulate images in many formats
    instaloader # Download pictures (or videos) along with their captions and other metadata from Instagram
    khal # CLI calendar application
    #   micromamba # Environment manager
    #   nodePackages.svgo # Optimize SVGs
    #   nushell # Modern alternative shell
    #   pandoc # Document conversion
    qrrs # CLI QR code generator and reader written in rust
    #   restic # Backup program
    sops # Editor of encrypted files
    tlrc # client for tldr: collaborative cheatsheets for console commands
    #   tree # Display directories as trees
    #   watch # Execute a program periodically
    vdirsyncer # Synchronize calendars and contacts
    wget # tool for downloading files from the web
    yt-dlp # youtube-dl successor
    #   yq # Process YAML, JSON, XML, CSV and properties documents

    # AI Tools
    codex
    opencode

    # Fun
    asciiquarium # Aquarium animation
    cbonsai # Bonsai
    cmatrix # Matrix animation
    cowsay # Talking cow
    lolcat # Rainbow colors
    sl # Steam locomotive
  ];

  imports = [
    (import ../tmux/tmux.nix { inherit pkgs configDir; })
  ];

  home.file = {
    ".config/atuin/config.toml" = dotfile "atuin/config.toml";
    ".config/btop/btop.conf" = dotfile "btop/btop.conf";
    ".config/ghostty/config" = dotfile "ghostty/config";
    ".config/gitui/key_bindings.ron" = dotfile "gitui/key_bindings.ron";
    ".config/gitui/theme.ron" = dotfile "gitui/theme.ron";
    ".config/helix/config.toml" = dotfile "helix/config.toml";
    ".config/helix/themes/my_theme.toml" = dotfile "helix/my_theme.toml";
    ".config/khal/config" = dotfile "khal/config";
    ".config/kitty/kitty.conf" = dotfile "kitty/kitty.conf";
    ".config/nix/nix.conf" = dotfile "nix/nix.conf";
    ".config/opencode/opencode.jsonc" = dotfile "opencode/opencode.jsonc";
    ".config/opencode/plugin/my-plugin.ts" = dotfile "opencode/plugin/my-plugin.ts";
    ".config/posting/config.yaml" = dotfile "posting/config.yaml";
    ".config/starship.toml" = dotfile "starship/starship.toml";
    ".config/vdirsyncer/config" = dotfile "vdirsyncer/config";
    ".config/yazi/init.lua" = dotfile "yazi/init.lua";
    ".config/yazi/keymap.toml" = dotfile "yazi/keymap.toml";
    ".config/yazi/theme.toml" = dotfile "yazi/theme.toml";
    ".config/yazi/yazi.toml" = dotfile "yazi/yazi.toml";
    ".env.sh" = dotfile "shell/.env.sh";
    ".finicky.js" = dotfile "finicky/.finicky.js";
    ".gitconfig" = dotfile "git/.gitconfig";
    ".gpg.conf" = dotfile "gpg/gpg.conf";
    ".irssi/config" = dotfile "irssi/config";
    ".lbdbrc" = dotfile "lbdb/lbdbrc";
    ".local/share/posting/themes/my_theme.yaml" = dotfile "posting/themes/my_theme.yaml";
    ".ssh/config" = dotfile "ssh/config";
    ".svgo.config.js" = dotfile "svgo/.svgo.config.js";
    ".vimrc" = dotfile "vim/.vimrc";
    "/Users/nik/Library/Application Support/ableset/custom-styles/styles.css" =
    "Library/LaunchAgents/gnupg.gpg-agent.plist" = dotfile "gpg/gnupg.gpg-agent.plist";
  };

  # This sets the `XDG_CONFIG_HOME` environment variable to `~/.config`.
  # For some programs (e.g. `sops`) on macOS this is needed, because they would otherwise look for their config files in `~/Library/Application Support`.
  xdg.enable = true;

  sops = {
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    age.keyFile = "${homePath}/.config/sops/age/keys.txt";
    secrets = {
      "atuin/username" = { };
      "atuin/password" = { };
      "atuin/key" = {
        path = "${homePath}/.local/share/atuin/key";
      };
    };
  };

  # This sets the `XDG_CONFIG_HOME` environment variable to `~/.config`.
  # For some programs (e.g. `sops`) on macOS this is needed, because they would otherwise look for their config files in `~/Library/Application Support`.
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellInitLast = "source ~/dotfiles/fish/config.fish";
    shellAliases = shellAliases;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "v10.3";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "1.1.0";
          sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "1.0.4";
          sha256 = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
        };
      }
      {
        name = "grc";
        src = pkgs.fetchFromGitHub {
          owner = "orefalo";
          repo = "grc";
          rev = "68e4325c1f261dfa5153937e7670fde046a0fe56";
          sha256 = "sha256-iHlxCEKYyKHlIpyOz4bwTQ6R0lr7FqZb54/wuWfWQfg=";
        };
      }
      {
        name = "spaced-prompts.fish";
        src = pkgs.fetchFromGitHub {
          owner = "niklasravnsborg";
          repo = "spaced-prompts.fish";
          rev = "0.1.1";
          sha256 = "sha256-J0RdvUwn+r39jNFNus9XYDjwhf8Qh/nZqtRo/BpShh4=";
        };
      }
    ];
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Set PATH and environment
        source ~/.env.sh
      '')

      (lib.mkAfter ''
        # Ignore commands in history that begin with a space
        # https://dev.to/epranka/hide-the-exported-env-variables-from-the-history-49ni
        export HISTCONTROL=ignorespace

        # Bind Alt+Left and Alt+Right to move between words
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;3D" backward-word

        # Setup Atuin
        eval "$(ATUIN_NOBIND=true atuin init zsh)"
        bindkey '^a' atuin-search

        # This adds a blank line before each command output for better readability
        function precmd { echo }
      '')
    ];

    shellAliases = shellAliases;

    antidote = {
      enable = true;
      plugins = [
        "wintermi/zsh-gcloud"
      ];
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ../gpg/0x7426E2F78A84EB06_knaggit.asc;
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

  programs.yazi = {
    enable = true;
    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        starship
        ;
    };
    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';
  };

  # Universal prompt
  programs.starship = {
    enable = true;
  };

  # Modern replacement for 'ls'
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--classify"
      "--group-directories-first"
      "--header"
      "--group"
      "--created"
      "--modified"
      "--octal-permissions"

      "--time-style"
      "long-iso"
    ];
  };

  # Modern replacement for 'cd'
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  # Modern replacement for 'cat'
  programs.bat = {
    enable = true;
    config.theme = "Coldark-Dark";

    extraPackages = with pkgs.bat-extras; [
      batman
    ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    package = pkgs.fzf.overrideAttrs (oldAttrs: {
      # The normal postInstall script installs shell integrations.
      # I don't want them, because I use the fish plugin `PatrickF1/fzf.fish`.
      postInstall = ''
        install bin/fzf-tmux $out/bin
        installManPage man/man1/fzf.1 man/man1/fzf-tmux.1
      '';
    });
  };

  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --paging=never";
        };
        commit = {
          autoWrapCommitMessage = false;
        };
        autoForwardBranches = "none";
      };
      gui = {
        scrollHeight = 1;
        nerdFontsVersion = 3;
        statusPanelView = "allBranchesLog";
        showCommandLog = false;
        showBottomLine = true;
        theme = {
          activeBorderColor = [
            "#ee99a0"
            "bold"
          ];
          inactiveBorderColor = [ "#a5adcb" ];
          optionsTextColor = [ "#8aadf4" ];
          selectedLineBgColor = [ "#363a4f" ];
          cherryPickedCommitBgColor = [ "#494d64" ];
          cherryPickedCommitFgColor = [ "#ee99a0" ];
          unstagedChangesColor = [ "#ed8796" ];
          defaultFgColor = [ "#cad3f5" ];
          searchingActiveBorderColor = [ "#eed49f" ];
        };
        authorColors = {
          "*" = "#b7bdf8";
        };
      };
      update = {
        method = "never";
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Control><Super>Return" ];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Control><Super>Left" ];
      toggle-tiled-right = [ "<Control><Super>Right" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      # This is the shortcut to lock the screen
      screensaver = [ "<Control><Alt>q" ];
    };

  };
}
