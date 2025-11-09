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
  imports = [
    ../programs/firefox.nix
  ]
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

  environment.systemPackages = (
    with pkgs;
    [
      brave
      clapper
      code-cursor
      imv
      # ghostty
      fuse

      brightnessctl
      playerctl
      tray-tui

      rofi
      dmenu-wpctl
      rofi-bluetooth
      networkmanager_dmenu
    ]
    ++ lib.optionals (systemType == "x11") [
      flameshot
      nitrogen
    ]
    ++ lib.optionals (systemType == "wayland") [
      grim
      slurp
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
    extraPortals =
      with pkgs;
      [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ]
      ++ lib.optionals (systemType == "wayland") [
        xdg-desktop-portal-hyprland
      ];
  };

  security.polkit.enable = true;
}
