# desktop.nix
{ inputs, outputs, config, lib, pkgs, systemType, ... }:

{
  imports = 
    [ ../hardware/vm-vbox.nix ./core.nix ] 
    ++ lib.optional (systemType == "x11") ../display/x11.nix
    ++ lib.optional (systemType == "wayland") ../display/wayland.nix;

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.systemd-boot.enable = lib.mkOverride 900 false;
    boot.loader.efi.canTouchEfiVariables = lib.mkOverride 900 true;
  
}
