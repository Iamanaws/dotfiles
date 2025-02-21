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

  # Use kernel 6.12 LTS
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_6_12;

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

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        #libvdpau-va-gl
      ];
    };

    nvidia = {
      open = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # videoDrivers [ "nvidia" ] handle by nixos-hardware
      # modesetting enabled by default
      # prime and offset enabled by nixos-hardware

      prime = {
        nvidiaBusId = "PCI:4:0:3";
        intelBusId = "PCI:0:2:0";
      };
    };

    logitech.wireless = {
      enable = true; # ltunify
      enableGraphical = true; # Solaar
    };
  };

  # Force intel-media-driver (iHD / i915) or nvidia
  environment.sessionVariables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  system.stateVersion = "24.05";
}
