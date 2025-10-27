# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

{
  antu-icons = pkgs.callPackage ./antu-icon-theme/package.nix { };
  beekeeper-studio = pkgs.callPackage ./beekeeper-studio/package.nix { };
  dsnote = pkgs.callPackage ./dsnote/package.nix { };
  genai-toolbox = pkgs.callPackage ./genai-toolbox/package.nix { };
  kuyen-icons = pkgs.callPackage ./kuyen-icon-theme/package.nix { };
}
