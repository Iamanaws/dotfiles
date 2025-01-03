# desktop.nix
{ inputs, outputs, config, lib, pkgs, allPkgs, systemType, ... }:

{
  imports = [ 
    ../core
    ../../display
  ];
  
}
