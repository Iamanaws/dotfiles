{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  hostConfig,
  ...
}:
{
  imports = [
    ./shell
    ./kitty.nix
    ./dunst
    ./hypr
  ];
}
