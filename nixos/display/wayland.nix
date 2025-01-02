# wayland.nix
{ inputs, outputs, config, lib, pkgs, 
  # pkgsUnstable, pkgsStable, 
  ... }:

{
  services.xserver.enable = false;
  
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland; # pkgsUnstable.hyprland;
    # .override { 
    #   withUWSM = true;
    # };
  };

  programs.hyprlock = {
    enable = true;
  };

  programs.uwsm = {
    enable = true;
    package = pkgs.uwsm; # pkgsUnstable.uwsm;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      comment = "Hyprland session managed by uwsm";
      prettyName = "Hyprland";
    };
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    displayManager = {
      defaultSession = "hyprland-wayland";
    };
  };

  security.pam.services.hyprlock = {};

}
