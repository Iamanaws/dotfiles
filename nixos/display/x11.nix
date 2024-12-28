# x11.nix
{ config, lib, pkgs, ... }:

{
  imports = [ ./graphical.nix ];

  services = {
    picom.enable = false;

    xserver = {
      enable = true;

      # Configure keymap in X11
      xkb.layout = "latam";
      # xkb.options = "eurosign:e,caps:escape";

      # desktopManager = { };
      
      windowManager = {
        qtile = {
          enable = true;
          backend = "x11";
        };
      };
      
      # VBoxClient --vmsvga &
      displayManager = {
        sessionCommands = ''
          picom &
          nm-applet &
          nitrogen --restore     
        '';

        lightdm.enable = true;
      };
    };

    displayManager = {
      defaultSession = "none+qtile";
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
