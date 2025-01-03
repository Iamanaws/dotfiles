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
    ./shell
  ]
  ++ lib.optionals (systemType == "x11" || systemType == "wayland") [ ./kitty.nix ./dunst.nix ]
  ++ lib.optional (systemType == "wayland") ./hypr;
}