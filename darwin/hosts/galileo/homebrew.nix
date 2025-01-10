{ inputs, config,... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "angel";

    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;

    # Optional: Declarative tap management
    # Ensure to name the key as a unique folder starting with homebrew-
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

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
    ];

    # handle delcaratively by nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}