{ inputs, outputs, lib, config, pkgs, systemType, hostConfig, ... }: {
  imports = [ ./shell ]
    ++ lib.optionals (systemType == "x11" || systemType == "wayland") [
      ./kitty.nix
      ./dunst.nix
    ] ++ lib.optional (systemType == "wayland") ./hypr;
}
