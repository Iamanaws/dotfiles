{ inputs, config, ... }:

{
  nix-homebrew = {
    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "admin";

    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;
  };

  homebrew = {
    # masApps = {
    #   "Bitwarden" = 1352778147;
    #   "Command X" = 6448461551;
    #   "CopyClip" = 595191960;
    #   "Plain Text Editor" = 1572202501;
    #   "Pixea" = 1507782672;
    #   "Xcode" = 497799835;
    # };

    brews = [ "python3" ];

    casks = [
      # broken on nixpkgs darwin
      "ghostty"

      # not available on nixpkgs darwin

    ];
  };
}
