{
  inputs,
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:
{

  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock/hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];

}
