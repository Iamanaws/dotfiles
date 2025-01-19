{ lib, ...}:

{
  imports = [
    ../../../options.nix
  ];

  config.options = {
    system = "aarch64-darwin";
    hostname = "Galileo";
    type = "laptop";
    users = [ "iamanaws" ];
  };

}