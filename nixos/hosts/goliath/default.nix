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
    xserver = {
      enable = lib.mkForce true;
      xkb.layout = "latam";

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      
      displayManager.defaultSession = "gnome";
      desktopManager.gnome.enable = true;

    };
  };

  environment.gnome.excludePackages = with pkgs; [
    geary
    epiphany
  ];

  system.stateVersion = "24.05"; 
}
