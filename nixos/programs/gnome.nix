{ lib, pkgs, ... }:

{
  services = {
    displayManager.defaultSession = "gnome";

    xserver = {
      enable = lib.mkForce true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-connections

    epiphany
    geary
    gnome-contacts
    gnome-tour
    seahorse
    totem
  ];
}
