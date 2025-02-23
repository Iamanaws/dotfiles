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
  imports =
    [ ./shell ]
    ++ lib.optionalAttrs (systemType != null) [
      ./kitty.nix
      ./dunst.nix
    ]
    ++ lib.optional (systemType == "wayland") ./hypr;
}
