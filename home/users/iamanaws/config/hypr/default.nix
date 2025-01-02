{
  inputs,
  config,
  lib,
  pkgs,
  # pkgsUnstable,
  # pkgsStable,
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