{ lib, ...}:

{
  imports = [
    ../../../options.nix
  ];

  config.options = {
    system = "x86_64-linux";
    hostname = "archimedes";
    type = "laptop";
    users = [ "iamanaws" ];
    displayServer = "wayland";
  };
  
}