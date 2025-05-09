{
  inputs,
  config,
  lib,
  pkgs,
  systemType,
  hostConfig,
  ...
}:

lib.optionalAttrs (systemType == "wayland") {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock/hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];
}
