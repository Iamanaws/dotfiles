{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  ...
}:

{
  home = {
    username = "zsheen";
    homeDirectory = "/home/zsheen";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}
