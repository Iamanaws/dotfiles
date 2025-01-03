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
      
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];
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
    };

    nvidia = {
      open = false;
      modesetting.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
    };
  };

  system.stateVersion = "24.05"; 
}
