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

  dsnote = import ./dsnote/package.nix {
    inherit (pkgs)
      stdenv
      lib
      fetchFromGitHub
      fetchzip
      fetchurl
      cmake
      ninja
      pkg-config
      python3
      fmt
      openblas
      mbrola
      boost
      stt
      onnxruntime
      pcaudiolib
      spdlog
      python312Packages
      rhvoice
      qt5
      libsForQt5
      perl
      opencl-headers
      ocl-icd
      amdvlk
      cudaPackages
      pcre2
      extra-cmake-modules
      libpulseaudio
      xorg
      autoconf
      automake
      libtool
      which
      libvorbis
      ffmpeg
      taglib_1
      rubberband
      libarchive
      xz
      lame
      xdotool
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
