# graphical.nix
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports =
    [ ../programs/firefox.nix ]
    ++ lib.optional (systemType == "x11") ./qtile.nix
    ++ lib.optional (systemType == "wayland") ./hyprland.nix;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-mono
  ];

  services = {

  };

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages =
    (
      with pkgs;
      [
        brave
        clapper
        flameshot
        imv
        # ghostty
        fuse
        vscode

        brightnessctl
        playerctl
        tray-tui

        rofi-bluetooth
        networkmanager_dmenu
      ]
      ++ lib.optionals (systemType == "x11") [
        rofi
        nitrogen
      ]
      ++ lib.optionals (systemType == "wayland") [
        rofi-wayland
      ]
    )
    ++ lib.optionals (systemType == "wayland") (
      with pkgs;
      [
        hyprpaper
        hyprpicker
        hyprsysteminfo
        # hyprlock
        hyprsunset
        hyprpolkitagent
        wl-clipboard
      ]
    );

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };
}
