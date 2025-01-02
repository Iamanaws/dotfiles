{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  ...
}: {
  imports = [
    ./shells.nix
  ]
  ++ lib.optionals (systemType == "x11" || systemType == "wayland") [ ./kitty.nix ./dunst.nix ]
  ++ lib.optional (systemType == "wayland") ./hypr;
}