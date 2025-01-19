{ lib, pkgs, hostConfig, ... }: 

let
  displayServer = hostConfig.options.displayServer;
in
{
  imports = [
    ./shell
  ]
  ++ lib.optionals (displayServer == "x11" || displayServer == "wayland") [ ./kitty.nix ./dunst.nix ]
  ++ lib.optional (displayServer == "wayland") ./hypr;
}