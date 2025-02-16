# desktop.nix
{ inputs, outputs, config, lib, pkgs, systemType, ... }:

{
  imports = [ ../../core ../../../display ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
}
