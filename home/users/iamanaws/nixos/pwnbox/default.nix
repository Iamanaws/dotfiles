{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  hostConfig,
  ...
}:

{
  imports = [
    ../../config/shell
    ../../config/shell/bash.nix
    ../../config/dunst.nix
    ../../config/kitty.nix
    ../../config/hypr/hyprlock/hyprlock.nix
    ../../config/hypr/hyprland.nix
    ../../config/hypr/hyprpaper.nix
    ./waybar.nix
    ./browser.nix
  ];

  home = {
    username = "iamanaws";
    homeDirectory = "/home/iamanaws";
  };

  home.packages = with pkgs; [ ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.11";
}
