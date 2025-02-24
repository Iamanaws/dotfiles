{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports = [
    ./../..
    ./homebrew.nix
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  networking = {
    # Charles (Robert), SteveAir, Galileo
    computerName = "Galileo";
    hostName = "Galileo";
    localHostName = "Galileo";
  };

  users.users = {
    iamanaws = {
      home = "/Users/iamanaws";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit outputs systemType; };
    users = {
      # Import your home-manager configuration
      iamanaws = import ../../../home/users/iamanaws/darwin;
    };
  };

  fonts.packages = with pkgs.nerd-fonts; [ caskaydia-mono ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    mongodb-compass-custom

    asciidoctor
    # brave
    colima
    docker
    docker-compose
    flameshot
    # google-chrome
    libreoffice-bin
    ngrok
    nsnake
    postman
    spotify
    vscode
  ];

  system.defaults = {
    controlcenter.WiFi = lib.mkForce true;

    dock = {
      autohide = true;
      expose-group-apps = true;
      magnification = false;
      minimize-to-application = true;
      mru-spaces = false;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Applications/Notes.app"
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/Nix Apps/Visual Studio Code.app"
        "/Applications/Ghostty.app"
        "/Applications/Nix Apps/MongoDB Compass.app"
        "/Applications//Nix Apps/Postman.app"
        "/Applications/Nix Apps/Spotify.app"
        "/Applications/ClickUp.app"
      ];
      show-recents = false;

      wvous-bl-corner = 14;
      wvous-br-corner = 4;
      wvous-tl-corner = 5;
      wvous-tr-corner = 2;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file:///Users/iamanaws/Downloads/";
      ShowPathbar = true;
      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
    };
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
