# graphical.nix
{ inputs, outputs, config, lib, pkgs, systemType, ... }:

{
  imports = [ ../programs/firefox.nix ]
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

  environment.systemPackages = (with pkgs;
    [
      brave
      clapper
      flameshot
      imv
      # (inputs.ghostty.packages.${pkgs.system}.ghostty)
      networkmanagerapplet
      fuse
      vscode

      brightnessctl
      playerctl
    ] ++ lib.optionals (systemType == "x11") [ rofi nitrogen ]
    ++ lib.optionals (systemType == "wayland") [
      rofi-wayland
      (inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo)
    ]) ++ lib.optionals (systemType == "wayland") (with pkgs; [
      hyprpaper
      hyprpicker
      wl-clipboard
      # hyprlock
      hyprsunset
      hyprpolkitagent
      waybar
    ]);

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };
}
