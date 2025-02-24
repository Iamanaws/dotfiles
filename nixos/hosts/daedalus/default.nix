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
    ./disko.nix
    ./hardware.nix
    ../../../secrets/daedalus
    ../../roles/server
    ../../roles/server/auto-upgrade.nix
    # ../../programs/lanzaboote.nix
  ];

  # nix run github:nix-community/nixos-anywhere/acc1651576dac4e736e05021836fd50d45f8046b \
  # -- --extra-files base --disk-encryption-keys <remote_path> <local_path> \
  # --flake 'github:Iamanaws/dotfiles#daedalus' --target-host nixos@nixos

  networking.hostName = "daedalus";

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    iamanaws = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.passwd.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvjMCx6qhx8/wWEuALzeQ5PTX+0oq8o5Le0MAmvg97p iamanaws@archimedes"
      ];
      extraGroups = [
        "wheel"
        "input"
      ];
    };
  };

  home-manager = {
    # useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs outputs systemType;
      hostConfig = config;
    };
    users = {
      # Import your home-manager configuration
      iamanaws = import ../../../home/users/iamanaws/nixos;
    };
  };

  services = {
    getty.autologinUser = lib.mkForce "iamanaws";
  };

  system.stateVersion = "25.05";
}
