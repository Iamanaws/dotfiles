{ config, lib, ... }: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = lib.mkDefault true;
    dates = "02:00";
    flags = [ "--accept-flake-config" ];
    flake = "github:iamanaws/dotfiles"; # config.environment.variables.FLAKE or
    operation = "boot";
    persistent = true;
    randomizedDelaySec = "60min";

    rebootWindow = {
      lower = "02:00";
      upper = "06:00";
    };
  };
}
