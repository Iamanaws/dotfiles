# hostnames.nix
{ lib, ...}:

{
  imports = [
    ../../options.nix
  ];

  default = {
    system = "x86_64-linux";
    hostname = "archimedes";
    type = "laptop";
    username = "iamanaws";
    displayServer = "wayland";
  };
  
}