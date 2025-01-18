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
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home = {
    username = "zsheen";
    homeDirectory = "/home/zsheen";
  };

  programs.home-manager.enable = true;

  services.flatpak.packages = [
    { 
      flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
      sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
    }
  ];

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.05";
}
