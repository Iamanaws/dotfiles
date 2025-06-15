{ lib, pkgs, ... }:

{
  services = {
    xserver.enable = lib.mkForce true;
    desktopManager.gnome.enable = true;
    displayManager.defaultSession = "gnome";

    displayManager.gdm = {
      enable = true;
      wayland = true;
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
