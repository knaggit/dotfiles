# Copied and modified from: https://discourse.nixos.org/t/how-to-create-macos-file-associations-with-nix-darwin/64801

# Determine the bundle bundle ID:
# $ mdls /Applications/IINA.app | grep kMDItemCF

# Determine the Uniform Type Identifier (UTI) of a file:
# $ mdls file.ext | grep kMDItemContentType

# Show configuration for extension:
# $ duti -x <ext>

{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.duti
  ];
  # Create a home activation script to apply duti settings
  home.activation = {
    setFileAssociation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Setting file associations with duti..."
      ${pkgs.duti}/bin/duti ~/.duti.conf
    '';
  };
  home.file = {
    ".duti.conf".text = ''
      # Web browser
      se.johnste.finicky http

      # Audio
      com.apple.QuickTimePlayerX flac all
      com.apple.QuickTimePlayerX mp3 all
      com.apple.QuickTimePlayerX ogg all
      com.apple.QuickTimePlayerX wav all

      # Video
      com.colliderli.iina avi all
      com.colliderli.iina mkv all
      com.colliderli.iina mov all
      com.colliderli.iina mp4 all
      com.colliderli.iina webm all
      com.colliderli.iina webp all

      # Most code related files
      dev.zed.Zed public.source-code all
      dev.zed.Zed public.plain-text all
      dev.zed.Zed bru all
      dev.zed.Zed css all
      dev.zed.Zed fish all
      dev.zed.Zed json all
      dev.zed.Zed md all
      dev.zed.Zed mdx all
      dev.zed.Zed mjs all
      dev.zed.Zed nix all
      dev.zed.Zed ts all
      dev.zed.Zed tsx all
      dev.zed.Zed xml all
      dev.zed.Zed xsd all
      dev.zed.Zed yaml all

      # C# / .NET
      com.microsoft.VSCode cs all
      com.microsoft.VSCode csproj all
      com.microsoft.VSCode razor all
      com.microsoft.VSCode sln all

      # Firestore Rules (db.rules)
      # Currently only VSCode has the extension for viewing db.rules files
      com.microsoft.VSCode rules all
    '';
  };
}
