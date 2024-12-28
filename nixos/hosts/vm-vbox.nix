# desktop.nix
{ inputs, outputs, config, lib, pkgs, systemType, ... }:

{
  imports = 
    [ ../hardware/vm-vbox.nix ./core.nix ] 
    ++ lib.optional (systemType == "x11") ../display/x11.nix
    ++ lib.optional (systemType == "wayland") ../display/wayland.nix;
  
}
