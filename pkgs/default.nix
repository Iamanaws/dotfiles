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

  mongodb-atlas-cli = import ./mongodb-atlas-cli/package.nix {
    inherit (pkgs)
      stdenv
      fetchFromGitHub
      lib
      buildGoModule
      installShellFiles
      nix-update-script
      testers
      mongodb-atlas-cli
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
}
