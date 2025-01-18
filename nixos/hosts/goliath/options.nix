{ lib, ...}:

{
  imports = [
    ../../../options.nix
  ];

  config.options = {
    system = "x86_64-linux";
    hostname = "goliath";
    type = "desktop";
    users = [ "iamanaws" "zsheen" ];
    displayServer = "wayland";
  };
  
}