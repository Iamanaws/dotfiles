{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {

  imports = [ 
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock/hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];

}