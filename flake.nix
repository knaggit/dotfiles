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
      # home dir
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      darwin-custom-icons,
      home-manager,
      ...
    }@inputs:
    let
      sharedModules = [
        ./tmux/tmux-module.nix
      ];
    in
    {

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

      darwinConfigurations."Karrajor" = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
        modules = [
          ./nix/darwin.nix
          darwin-custom-icons.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              users.knaggit = import ./nix/home.nix;
              inherit sharedModules;
            };
          }
        ];
      };
    };
}
