# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

{
  kuyen-icons = import ./kuyen-icon-theme/package.nix {
    inherit (pkgs)
      lib
      stdenvNoCC
      fetchFromGitLab
      hicolor-icon-theme
      ;
  };

  antu-icons = import ./antu-icon-theme/package.nix {
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
      taglib
      rubberband
      libarchive
      xz
      lame
      xdotool
      wayland
      wayland-protocols
      ;
  };
}
