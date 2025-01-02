{
  inputs,
  outputs,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: 

let
  systemType = osConfig.default.system;
in
{
  imports = [
    ./shell
  ]
  ++ lib.optionals (systemType == "x11" || systemType == "wayland") [ ./kitty.nix ./dunst.nix ]
  ++ lib.optional (systemType == "wayland") ./hypr;
}