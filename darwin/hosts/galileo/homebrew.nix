{ inputs, config,... }:

{
  nix-homebrew = {
    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "iamanaws";

    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;
  };

  homebrew = {
    masApps = {
      "Bitwarden" = 1352778147;
      "Command X" = 6448461551;
      "CopyClip" = 595191960;
      "Plain Text Editor" = 1572202501;
      "Pixea" = 1507782672;
      "Xcode" = 497799835;
    };

    brews = [

    ];

    casks = [
      "brave-browser"
      "google-chrome"
      "ghostty" # broken on nixpkgs darwin

      "affinity-designer"
      "beekeeper-studio"
      "jetbrains-toolbox"
      "mongodb-compass"
    ];
  };
}