{ ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true; # .nix-Files
  programs.prettier.enable = true; # diverse Files (web)
  programs.taplo.enable = true; # .toml-Files
}
