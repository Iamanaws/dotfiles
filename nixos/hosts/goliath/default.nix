{ inputs, outputs, config, lib, pkgs, allPkgs, systemType, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/desktop
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use kernel 6.12 LTS
  boot.kernelPackages = allPkgs.unstable.linuxPackagesFor allPkgs.unstable.linuxKernel.kernels.linux_6_12;

  networking.hostName = "goliath";
 
  users.users = {
    iamanaws = {
      isNormalUser = true;
      extraGroups = [ "wheel" "input" ];
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
    
    extraSpecialArgs = { inherit inputs outputs systemType; };
    users = {
      iamanaws = import ../../../home/users/iamanaws;
      zsheen = import ../../../home/users/zsheen;
    };
  };
 
  # https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  services.flatpak.packages = [
    "net.sourceforge.VMPK"
    # "io.github.nokse22.asciidraw"
    # "app.drey.EarTag"
    # "xyz.slothlife.Jogger"
    # "com.jeffser.Alpaca"
    # mission center
  ];

  # Configure flatpak repo for all users
  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };

  # Gnome
  services = {
    displayManager.defaultSession = "gnome";

    xserver = {
      enable = lib.mkForce true;
      xkb.layout = "latam";

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

  environment.systemPackages = with pkgs; [
    egl-wayland
    libva-utils
  ];

  hardware = {
    graphics = {
      enable = true;
      package = allPkgs.unstable.mesa.drivers;
      extraPackages = with allPkgs.unstable; [
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
