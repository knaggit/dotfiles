{
  pkgs,
  config,
  lib,
  ...
}:

let
  shellAliases = {
    lg = "lazygit";
    man = "batman";
    nix-switch =
      if pkgs.stdenv.isDarwin then
        "nix run nix-darwin -- switch --flake ~/Git/dotfiles"
      else
        "sudo nixos-rebuild switch --flake ~/Git/dotfiles";
    svgo = "svgo --config=$HOME/.svgo.config.js";
    wifi = "nextdns deactivate; open http://neverssl.com; read -P 'Continue? '; nextdns activate";
    ffmpeg = "ffmpeg -hide_banner";
    cat = "bat -p";
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
    #   act # Run GitHub Actions locally
    age # Secure file encryption
    any-nix-shell # Run nix-shell in any directory
    #   cloc # Count lines of code
    #   cloudflared # Cloudflare tunnel
    delta # Syntax-highlighter for git and diff output
    exiftool # EXIF tool for file with EXIF data (photos)
    #   fd # Alternative to find
    ffmpeg_7 # Play, record, convert, and stream audio and video
    gh # GitHub command-line tool
    #   gitui # Terminal ui for git
    gnused # GNU version of the famous stream editor
    gnutar # GNU version of the tar archiving utility
    #   google-cloud-sdk # Manage resources and applications hosted on Google Cloud
    helix # Post-modern modal text editor
    #   htop # Improved top (interactive process viewer)
    #   httpie # User-friendly HTTP client
    #   imagemagick # Manipulate images in many formats
    #   micromamba # Environment manager
    mtr
    #   ngrok # Reverse proxy, secure tunnels to localhost
    #   nodePackages.svgo # Optimize SVGs
    #   nushell # Modern alternative shell
    #   pandoc # Document conversion
    #   restic # Backup program
    sops # Editor of encrypted files
    tlrc # client for tldr: collaborative cheatsheets for console commands
    #   tree # Display directories as trees
    #   watch # Execute a program periodically
    wget # tool for downloading files from the web
    yt-dlp # youtube-dl successor
    #   yq # Process YAML, JSON, XML, CSV and properties documents

    #   # Fun
    #   asciiquarium # Aquarium animation
    #   cmatrix # Matrix animation
    #   cowsay # Talking cow
    #   lolcat # Rainbow colors
    #   sl # Steam locomotive
  ];

  imports = [
    (import ../tmux/tmux.nix { inherit pkgs configDir; })
  ];

  home.file = {
    "Library/LaunchAgents/gnupg.gpg-agent.plist" = dotfile "gpg/gnupg.gpg-agent.plist";
    ".env.sh" = dotfile "shell/.env.sh";
    ".gpg.conf" = dotfile "gpg/gpg.conf";
    ".finicky.js" = dotfile "finicky/.finicky.js";
    ".gitconfig" = dotfile "git/.gitconfig";
    ".gitignore" = dotfile "git/.gitignore";
    ".ssh/config" = dotfile "ssh/config";
    ".svgo.config.js" = dotfile "svgo/.svgo.config.js";
    ".vimrc" = dotfile "vim/.vimrc";

    ".config/atuin/config.toml" = dotfile "atuin/config.toml";
    ".config/gitui/key_bindings.ron" = dotfile "gitui/key_bindings.ron";
    ".config/gitui/theme.ron" = dotfile "gitui/theme.ron";
    ".config/helix/config.toml" = dotfile "helix/config.toml";
    ".config/helix/themes/my_theme.toml" = dotfile "helix/my_theme.toml";
    ".config/kitty/kitty.conf" = dotfile "kitty/kitty.conf";
    ".config/nix/nix.conf" = dotfile "nix/nix.conf";
    ".config/starship.toml" = dotfile "starship/starship.toml";

    # Yazi
    ".config/yazi/theme.toml" = dotfile "yazi/theme.toml";
    ".config/yazi/yazi.toml" = dotfile "yazi/yazi.toml";
    ".config/yazi/keymap.toml" = dotfile "yazi/keymap.toml";
    ".config/yazi/init.lua" = dotfile "yazi/init.lua";
  };

  # This sets the `XDG_CONFIG_HOME` environment variable to `~/.config`.
  # For some programs (e.g. `sops`) on macOS this is needed, because they would otherwise look for their config files in `~/Library/Application Support`.
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellInitLast = builtins.readFile ../fish/config.fish;
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
        name = "google-cloud-sdk-fish-completion";
        src = pkgs.fetchFromGitHub {
          owner = "lgathy";
          repo = "google-cloud-sdk-fish-completion";
          rev = "bc24b0bf7da2addca377d89feece4487ca0b1e9c";
          sha256 = "sha256-BIbzdxAj3mrf340l4hNkXwA13rIIFnC6BxM6YuJ7/w8=";
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

    initExtraFirst = ''
      # Set PATH and environment
      source ~/.env.sh
    '';

    initExtra = ''
      # Ignore commands in history that begin with a space
      # https://dev.to/epranka/hide-the-exported-env-variables-from-the-history-49ni
      export HISTCONTROL=ignorespace

      # Bind Alt+Left and Alt+Right to move between words
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word

      # This adds a blank line before each command output for better readability
      function precmd { echo }
    '';

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
    pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry;
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
  };

  # Universal prompt
  programs.starship = {
    enable = true;
  };

  # Universal history
  programs.atuin = {
    enable = true;
    enableFishIntegration = false; # We set it up manually in config.fish
    flags = [ "--disable-up-arrow" ];
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
          pager = "delta --no-gitconfig --paging=never --dark --syntax-theme=Coldark-Dark";
        };
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
