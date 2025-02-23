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
    ./hardware.nix
    ./options.nix
    ../../roles/desktop
    ../../services/flatpak.nix
    ../../programs/gnome.nix
  ];

  networking.hostName = "goliath";
  services.xserver.xkb.layout = "latam";

  users.users = {
    iamanaws = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
      ];
      packages = with pkgs; [
        # gnome.gnome-software
      ];
    };

    zsheen = {
      isNormalUser = true;
    };
  };

  home-manager = {
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs outputs systemType;
      hostConfig = config;
    };
    users = {
      iamanaws = import ../../../home/users/iamanaws/nixos;
      zsheen = import ../../../home/users/zsheen;
    };
  };

  services.flatpak.packages = [
    "net.sourceforge.VMPK"
    "com.github.tchx84.Flatseal"
    # "io.github.nokse22.asciidraw"
    # "app.drey.EarTag"
    # "xyz.slothlife.Jogger"
    # "com.jeffser.Alpaca"
    # mission center
  ];

  environment.systemPackages = with pkgs; [
    egl-wayland
    libva-utils
  ];

  # Force intel-media-driver (iHD / i915) or nvidia
  environment.sessionVariables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  system.stateVersion = "24.05";
}
