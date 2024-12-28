# minimal.nix
{ config, lib, pkgs, ... }:

{
  imports = [ ./core.nix ];

  services.openssh = {
    enable = true; 
    ports = [ 3232 ];
    
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

}
