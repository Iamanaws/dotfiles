{ inputs, outputs, config, lib, pkgs, allPkgs, systemType, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/desktop
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    
    extraSpecialArgs = { inherit outputs systemType; };
    users = {
      iamanaws = import ../../../home/users/iamanaws;
      zsheen = import ../../../home/users/zsheen;
    };
  };
 
  # https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Configure flatpak repo for all users
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

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

  hardware = {
    graphics = {
      enable = true;
      package = allPkgs.unstable.mesa.drivers;
      extraPackages = with allPkgs.unstable; [
	libvdpau-va-gl
      ];
    };

    nvidia = {
      open = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      prime = {
        nvidiaBusId = "PCI:0:4:0";
	intelBusId = "PCI:0:2:0";
      };
    };
  };

  # Force intel-media-driver (iHD) or nvidia
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  system.stateVersion = "24.05"; 
}
