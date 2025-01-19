{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./options.nix
    ../../roles/laptop
  ];
  
  networking.hostName = config.options.hostname;

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    iamanaws = {
      # You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "password123!";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "input"];
    };
  };

  home-manager = {
    # useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { 
      inherit inputs outputs; 
      hostConfig = config;  
    };
    users = {
      # Import your home-manager configuration
      iamanaws = import ../../../home/users/iamanaws/nixos;
    };
  };
  
  system.stateVersion = "24.11";
}
