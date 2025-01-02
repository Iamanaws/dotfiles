{ inputs, outputs, config, lib, pkgs, allPkgs, systemType, ... }:

{
  imports = [
    ./hardware.nix
    ../../roles/desktop
  ];
  
  networking.hostName = "goliath";
  
}
