{ lib, config, ... }:

{
  nix = {
    enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@admin" ];
    };

    optimise.automatic = config.nix.enable;

    gc = {
      automatic = config.nix.enable;
      options = "--delete-older-than 14d";
      interval = [ { Hour = 2; } ];
    };

    # Run GC when there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.2.12"
  ];
}
