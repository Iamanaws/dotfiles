{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.mac-app-util.darwinModules.default
    ./homebrew.nix
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  networking = {
    # Charles (Robert), SteveAir, Galileo
    computerName = "Galileo";
    hostName = "Galileo";
    localHostName = "Galileo";
  };

  fonts.packages = with pkgs.nerd-fonts; [
    caskaydia-mono
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    alt-tab-macos
    asciidoctor
    # brave
    colima
    docker
    docker-compose
    flameshot
    # ghostty # broken on nixpkgs use brew cask
    # google-chrome
    iina
    ngrok
    nsnake
    php
    postman
    python3
    rectangle
    spotify
    vscode
    zstd

    bottom
    fet-sh
    neofetch
    neovim
    vim
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}