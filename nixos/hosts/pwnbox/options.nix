{ lib, ... }:

{
  imports = [ ../../../options.nix ];

  config.options = {
    system = "x86_64-linux";
    hostname = "pwnbox";
    type = "vm";
    users = [ "iamanaws" ];
    displayServer = "wayland";
  };

}
