{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    ../.
    ./graphical.nix
    ../config/shell/bash.nix
  ];

  home = {
    username = "iamanaws";
    homeDirectory = "/home/iamanaws";
  };

  home.packages = with pkgs; [ ];

  # Add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
