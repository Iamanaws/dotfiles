{ inputs, outputs, lib, config, pkgs, ... }: 

{
  # You can import other home-manager modules here
  imports = [
    ../default.nix
    ../config/shell/zsh.nix
  ];

  home = {
    username = "iamanaws";
    homeDirectory = "/Users/iamanaws";
  };
}