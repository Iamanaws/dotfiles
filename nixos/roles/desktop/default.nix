# desktop.nix
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports = [
    ../core
    ../../display
  ];

}
