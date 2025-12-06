{
  description = "knaggit's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.url = "github:Homebrew/brew/4.6.7";
    };
    nix-darwin-custom-icons = {
      url = "github:ryanccn/nix-darwin-custom-icons";
    };
    home-manager = {
      # home dir
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      systems = {
        darwin = "aarch64-darwin";
        nixos = "x86_64-linux";
      };
      myNixpkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      secretsPath = builtins.toString inputs.dotfiles-secrets;
      homeManagerConfig = {
        useGlobalPkgs = true;
        users.nik = import ./nix/home.nix;
        sharedModules = [
          ./tmux/tmux-module.nix

        ];
        extraSpecialArgs = {
          inherit secretsPath;
        };
      };
      darwinSystem = inputs.nix-darwin.lib.darwinSystem {
        system = systems.darwin;
        specialArgs = {
          inherit secretsPath;
          pkgs = myNixpkgs systems.darwin;
        };
        modules = [
          ./nix/darwin.nix
          inputs.nix-darwin-custom-icons.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            home-manager = homeManagerConfig // {
              sharedModules = homeManagerConfig.sharedModules ++ [
                ./macos/file-associations
              ];
            };
            nix-homebrew = {
              enable = true;
              user = "nik";
            };
          }
        ];
      };

      # Small tool to iterate over each systems
      eachSystem =
        f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
          system: f inputs.nixpkgs.legacyPackages.${system}
        );

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check inputs.self;
      });

      # development environment, enabled via `.envrc`
      devShell = eachSystem (
        pkgs:
        pkgs.mkShell {
          packages = with pkgs; [
            nixd
            nixfmt
          ];
        }
      );

      darwinConfigurations."Karrajor" = darwinSystem;

    };
}
