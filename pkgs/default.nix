# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

{
  antu-icons = pkgs.callPackage ./antu-icon-theme/package.nix { };
  dsnote = pkgs.callPackage ./dsnote/package.nix { };
  kuyen-icons = pkgs.callPackage ./kuyen-icon-theme/package.nix { };
}
