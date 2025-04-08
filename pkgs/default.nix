# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'

{ pkgs }:

{
  kuyen-icons = import ./kuyen-icon-theme/default.nix {
    inherit (pkgs)
      lib
      stdenvNoCC
      fetchFromGitLab
      hicolor-icon-theme
      ;
  };
  antu-icons = import ./antu-icon-theme/default.nix {
    inherit (pkgs)
      lib
      stdenvNoCC
      fetchFromGitLab
      hicolor-icon-theme
      ;
  };

  textcompare = import ./textcompare/package.nix {
    inherit (pkgs)
      lib
      stdenv
      fetchFromGitHub
      desktop-file-utils
      gjs
      gobject-introspection
      gtksourceview5
      gtk4
      libadwaita
      meson
      ninja
      wrapGAppsHook4
      nix-update-script
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
      nix-update-script
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
      nix-update-script
      ;
  };
}
