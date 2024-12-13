{
  description = "knaggit's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    darwin = {
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      url = "github:niklasravnsborg/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin-custom-icons = {
      url = "github:ryanccn/nix-darwin-custom-icons";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-secrets = {
      url = "git+ssh://git@github.com/niklasravnsborg/dotfiles-secrets?shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      darwin-custom-icons,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
        ./tmux/tmux-module.nix
      ];
      secretsPath = builtins.toString inputs.dotfiles-secrets;
    in
    {

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

      darwinConfigurations."Karrajor" = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
        specialArgs = {
          inherit secretsPath;
        };
        modules = [
          ./nix/darwin.nix
          sops-nix.darwinModules.sops
          darwin-custom-icons.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              users.nik = import ./nix/home.nix;
              inherit sharedModules;
              extraSpecialArgs = {
                inherit secretsPath;
              };
            };
          }
        ];
      };
    };
}
