# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ pkgs }:

{
  kuyen-icons = import ./kuyen-icon-theme/default.nix { inherit (pkgs) lib stdenvNoCC fetchFromGitLab gtk3; };
  antu-icons = import ./antu-icon-theme/default.nix { inherit (pkgs) lib stdenvNoCC fetchFromGitLab gtk3; };
  # tresorit = import ./tresorit/default.nix { inherit (pkgs) lib stdenvNoCC fetchFromGitHub autoPatchelfHook qt5 fuse; };
  # tresorit = import ./tresorit/default.nix { inherit pkgs; };
}