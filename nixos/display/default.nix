# graphical.nix
{ inputs, outputs, config, lib, pkgs, allPkgs, systemType, ... }:

{
  imports = [ ]
  ++ lib.optional (systemType == "x11") ./x11.nix
  ++ lib.optional (systemType == "wayland") ./wayland.nix;

  networking.wireless.enable = lib.mkOverride 900 false;
  networking.networkmanager.enable = lib.mkOverride 900 true;
  
  fonts.packages = with allPkgs.unstable; [
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

  environment.systemPackages = (with pkgs; [
    brave
    clapper
    firefox
    flameshot
    imv
    # (inputs.ghostty.packages.${pkgs.system}.ghostty)
    networkmanagerapplet
    fuse
    #outputs.packages.tresorit
    vscode

    brightnessctl
    playerctl
  ] 
  ++ lib.optionals (systemType == "x11") [ 
    rofi
    nitrogen
  ]
  ++ lib.optionals (systemType == "wayland") [ 
    rofi-wayland
    (inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo)
  ])
  ++ lib.optionals (systemType == "wayland") (with allPkgs.unstable; [
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
