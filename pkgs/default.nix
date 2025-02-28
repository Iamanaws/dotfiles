# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ pkgs }:

{
  kuyen-icons = import ./kuyen-icon-theme/default.nix {
    inherit (pkgs)
      lib
      stdenvNoCC
      fetchFromGitLab
      gtk3
      ;
  };
  antu-icons = import ./antu-icon-theme/default.nix {
    inherit (pkgs)
      lib
      stdenvNoCC
      fetchFromGitLab
      gtk3
      ;
  };

  mongodb-compass = import ./mongodb-compass/package.nix {
    inherit (pkgs) lib stdenv callPackage;
  };
  mongodb-atlas-cli = import ./mongodb-atlas-cli/package.nix {
    inherit (pkgs)
      stdenv
      fetchFromGitHub
      lib
      buildGoModule
      installShellFiles
      ;
  };
  mongodb-atlas = import ./mongodb-atlas/package.nix {
    inherit (pkgs)
      lib
      buildEnv
      mongodb-atlas-cli
      mongosh
      ;
  };
  mongodb-cli = import ./mongodb-cli/package.nix {
    inherit (pkgs)
      stdenv
      fetchFromGitHub
      lib
      buildGoModule
      installShellFiles
      ;
  };
}
