{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  python3,
  fmt,
  openblas,
  mbrola,
  boost,
  stt,
  onnxruntime,
  pcaudiolib,
  spdlog,
  python312Packages,
  rhvoice,
  qt5,
  libsForQt5,
  opencl-headers,
  ocl-icd,
  amdvlk,
  cudaPackages,
  pcre2,
  extra-cmake-modules,
  libpulseaudio,
  xorg,
  autoconf,
  automake,
  libtool,
  which,
  libvorbis,
  ffmpeg,
  taglib,
  rubberband,
  libarchive,
  xz,
  lame,
  xdotool,
  wayland,
  wayland-protocols,
}:

let
  dsnote_commit_hash = "a48334317e0aeada3e8146e426f8a876a9b1e25b";

  aprilasr = stdenv.mkDerivation {
    pname = "aprilasr";
    version = "0-unstable-2023-09-03";

    src = fetchFromGitHub {
      owner = "abb128";
      repo = "april-asr";
      rev = "3308e68442664552de593957cad0fa443ea183dd";
      hash = "sha256-/cOZ2EcZu/Br9v0ComxnOegcEtlC9e8FYt3XHfah7mE=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [
      onnxruntime
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    meta = {
      description = "Small, fast, and accurate speech recognition engine";
      homepage = "https://github.com/abb128/april-asr";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };

  html2md = stdenv.mkDerivation (finalAttrs: {
    pname = "html2md";
    version = "1.6.4";

    src = fetchFromGitHub {
      owner = "tim-gromeyer";
      repo = "html2md";
      rev = "v${finalAttrs.version}";
      hash = "sha256-DkRyHrXS9Fg8sGij+EtTjH0/r0rxvFZH2JGazPQXZN8=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      "-DBUILD_EXE=OFF"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/html2md.patch";
        hash = "sha256-0UA5kpOdRV46UfkY7Ak0Blj5AdoHdA7dAl/ftxw9o5w=";
      })
    ];

    meta = {
      description = "C++ library for converting HTML to Markdown";
      homepage = "https://github.com/tim-gromeyer/html2md";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  });

  libnumbertext = stdenv.mkDerivation {
    pname = "libnumbertext";
    version = "1.0.11-unstable-2023-08-14";

    src = fetchFromGitHub {
      owner = "Numbertext";
      repo = "libnumbertext";
      rev = "a4b0225813b015a0f796754bc6718be20dd9943c";
      hash = "sha256-iUikSA4oZSRniSPOwukVtlTtaeu62fMAY8wdRW17KRw=";
    };

    nativeBuildInputs = [
      autoconf
      automake
      libtool
    ];

    preConfigure = ''
      ./autogen.sh || autoreconf -vfi
    '';

    configureFlags = [
      "--enable-shared=false"
      "--enable-static=true"
      "--with-pic=yes"
    ];

    meta = {
      description = "Number to number name conversion library";
      homepage = "https://github.com/Numbertext/libnumbertext";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
    };
  };

  maddy = stdenv.mkDerivation (finalAttrs: {
    pname = "maddy";
    version = "1.3.0";

    src = fetchFromGitHub {
      owner = "progsource";
      repo = "maddy";
      tag = "${finalAttrs.version}";
      hash = "sha256-sVUXACT94PSPcohnOyIp7KK8baCBuf6ZNMIyk6Cfdjg=";
    };

    buildPhase = null;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/include
      cp -r include/maddy $out/include/
      runHook postInstall
    '';

    meta = {
      description = "C++ Markdown to HTML header-only parser library";
      homepage = "https://github.com/progsource/maddy";
      license = lib.licenses.mit;
    };
  });

  espeak-ng = stdenv.mkDerivation {
    pname = "espeak-ng";
    version = "2023.9.7-4-unstable-2023-11-27";

    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "espeak-ng";
      rev = "8593723f10cfd9befd50de447f14bf0a9d2a14a4";
      hash = "sha256-zuRVbQr2MCTB5cx7WlSC/JhB/hHaFxCXYHl26n3Ja2I=";
    };

    nativeBuildInputs = [
      autoconf
      automake
      libtool
      which
      pkg-config
    ];

    preConfigure = ''
      ./autogen.sh
    '';

    configureFlags = [
      "--with-pic"
      "--enable-static"
      "--with-pcaudiolib=no"
      "--with-sonic=no"
      "--with-speechplayer=no"
      "--with-mbrola=yes"
      "--with-extdict-ru"
    ];

    meta = {
      description = "Open source speech synthesizer that supports more than hundred languages and accents";
      homepage = "https://github.com/rhasspy/espeak-ng";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  };

  piper-phonemize = stdenv.mkDerivation {
    pname = "piper_phonemize";
    version = "1.1.0-unstable-2023-07-31";

    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "piper-phonemize";
      rev = "7f7b5bd4de22f7fe24341c5bedda0dc1e33f3666";
      hash = "sha256-2+Ll1rdL7yTXR3B53vD1EX/g/mRk/iWWunPfGCFmmBM=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      ninja
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      "-DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON"
      "-DONNXRUNTIME_DIR=${onnxruntime.dev}"
      "-DESPEAK_NG_DIR=${espeak-ng}"
    ];

    buildInputs = [
      onnxruntime
      espeak-ng
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/piperphonemize.patch";
        hash = "sha256-mj2AFFPyq3ef7OzT8MhdA7tAuyr8mGD2j2HMxM1jBmM=";
      })
    ];

    meta = {
      description = "C++ library for converting text to phonemes for Piper";
      homepage = "https://github.com/rhasspy/piper-phonemize";
      license = lib.licenses.mit;
    };
  };

  piper = stdenv.mkDerivation {
    pname = "piper";
    version = "1.2.0-unstable-2023-07-31";

    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "piper";
      rev = "e268564deb779af984ac8f632c98727447632124";
      hash = "sha256-aszACWNJwDHHVs5F/bO6o/GTZFmEv3nA1T+bZYeyRB4=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      ninja
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      "-DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON"
      "-DFMT_DIR=${fmt}"
      "-DSPDLOG_DIR=${spdlog.src}"
      "-DPIPER_PHONEMIZE_DIR=${piper-phonemize}"
    ];

    buildInputs = [
      fmt
      onnxruntime
      pcaudiolib
      piper-phonemize
      espeak-ng
      spdlog
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/piper.patch";
        hash = "sha256-uIJdopDcHXwGbq3c8+RKKLmD85TRX4G+2rj+QD0/f3Q=";
      })
    ];

    env.NIX_CFLAGS_COMPILE = builtins.toString [
      "-isystem ${lib.getDev piper-phonemize}/include/piper-phonemize"
    ];

    meta = {
      description = "Fast, local neural text to speech system";
      homepage = "https://github.com/rhasspy/piper";
      license = lib.licenses.mit;
    };
  };

  qhotkey = stdenv.mkDerivation {
    pname = "qhotkey";
    version = "1.5.0-unstable-2023-04-18";

    src = fetchFromGitHub {
      owner = "Skycoder42";
      repo = "QHotkey";
      rev = "cd72a013275803fce33e028fc8b05ae32248da1f";
      hash = "sha256-hsRnaY0K7BeEYohQkxceK8JYiTLaPHEXBesftWQ2E9c=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [
      qt5.qtbase
      libsForQt5.qt5.qtx11extras
    ];

    dontWrapQtApps = true;

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/qhotkey.patch";
        hash = "sha256-dW+ODst0CZmd5aoU7qixd3Lg4C+uOjXUAv+2aFYs5fY=";
      })
    ];

    meta = {
      description = "Qt library for global shortcuts";
      homepage = "https://github.com/Skycoder42/QHotkey";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.linux;
    };
  };

  rnnoise-nu = stdenv.mkDerivation {
    pname = "rnnoise-nu";
    version = "0-unstable-2018-09-16";

    src = fetchFromGitHub {
      owner = "GregorR";
      repo = "rnnoise-nu";
      rev = "26269304e120499485438cd93acf5127c6908c68";
      hash = "sha256-t7XTpf4lz+rdT0qls5f5GxkxMeC81SzMxQl/MeeKXTU=";
    };

    nativeBuildInputs = [
      autoconf
      automake
      libtool
      pkg-config
    ];

    preConfigure = ''
      ./autogen.sh
    '';

    configureFlags = [
      "--disable-examples"
      "--disable-doc"
      "--disable-shared"
      "--enable-static"
      "--with-pic"
    ];

    env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-Dpitch_downsample=rnnoise_pitch_downsample"
      "-Dpitch_search=rnnoise_pitch_search"
      "-Dremove_doubling=rnnoise_remove_doubling"
      "-D_celt_lpc=rnnoise__celt_lpc"
      "-Dcelt_iir=rnnoise_celt_iir"
      "-D_celt_autocorr=rnnoise__celt_autocorr"
      "-Dcompute_gru=rnnoise_compute_gru"
      "-Dcompute_dense=rnnoise_compute_dense"
      "-fpie"
    ];

    meta = {
      description = "Recurrent neural network for audio noise reduction";
      homepage = "https://github.com/GregorR/rnnoise-nu";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.linux;
    };
  };

  sam = stdenv.mkDerivation {
    pname = "sam";
    version = "0-unstable-2020-02-09";

    src = fetchFromGitHub {
      owner = "s-macke";
      repo = "sam";
      rev = "a7b36efac730957b59471a42a45fd779f94d77dd";
      hash = "sha256-gWGyA10s5U4huqNkyQsFHV1r7jUifdJOTmY9Ti6+PLM=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/sam.patch";
        hash = "sha256-sy7W7G6vNjnB11YK/OvsTHT0RDPN0elD++iSR7F4JRU=";
      })
    ];

    meta = {
      description = "Software Automatic Mouth - Tiny Speech Synthesizer";
      homepage = "https://github.com/s-macke/sam";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
    };
  };

  ssplitcpp = stdenv.mkDerivation {
    pname = "ssplitcpp";
    version = "0-unstable-2022-04-12";

    src = fetchFromGitHub {
      owner = "ugermann";
      repo = "ssplit-cpp";
      rev = "49a8e12f11945fac82581cf056560965dcb641e6";
      hash = "sha256-ZmymCokVMbPbadAtun/7O8flbkFJcsQfI5YLSr0+6Ao=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [ pcre2 ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      "-DSSPLIT_COMPILE_LIBRARY_ONLY=ON"
      "-DSSPLIT_PREFER_STATIC_COMPILE=ON"
      "-DBUILD_SHARED_LIBS=OFF"
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/ssplitcpp.patch";
        hash = "sha256-vEIlv46QdWaV1y2+y9P1gS9YxoJrv8J0AmKqjYGGbfM=";
      })
    ];

    meta = {
      description = "C++ library for sentence splitting";
      homepage = "https://github.com/ugermann/ssplit-cpp";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };

  vosk = stdenv.mkDerivation (finalAttrs: {
    pname = "vosk";
    version = "0.3.45";

    src = fetchzip {
      url =
        if stdenv.hostPlatform.system == "x86_64-linux" then
          "https://github.com/alphacep/vosk-api/releases/download/v${finalAttrs.version}/vosk-linux-x86_64-${finalAttrs.version}.zip"
        else if stdenv.hostPlatform.system == "aarch64-linux" then
          "https://github.com/alphacep/vosk-api/releases/download/v${finalAttrs.version}/vosk-linux-aarch64-${finalAttrs.version}.zip"
        else
          throw "Unsupported system: ${stdenv.hostPlatform.system}";
      hash =
        if stdenv.hostPlatform.system == "x86_64-linux" then
          "sha256-ToMDbD5ooFMHU0nNlfpLynF29kkfMknBluKO5PipLFY="
        else
          "";
    };

    installPhase = ''
      mkdir -p $out/lib $out/include
      cp libvosk.so $out/lib
      cp vosk_api.h $out/include
    '';

    meta = {
      description = "Offline speech recognition API";
      homepage = "https://github.com/alphacep/vosk-api";
      license = lib.licenses.asl20;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  });

  webrtcvad = stdenv.mkDerivation {
    pname = "webrtcvad";
    version = "0-unstable-2024-09-29";

    src = fetchFromGitHub {
      owner = "webrtc-mirror";
      repo = "webrtc";
      rev = "ac87c8df2780cb12c74942ec8a473718c76cb5b7";
      hash = "sha256-BiFPuLi1r/ohDbUPOvp+kWZ5S7e40wzuvrdE31eHcHM=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    ];

    patches = [
      (fetchurl {
        url = "https://github.com/mkiol/dsnote/raw/${dsnote_commit_hash}/patches/webrtcvad.patch";
        hash = "sha256-4V5M9PpKTpwKESPRKh5gtFEFjMv5AdUJfk+P/6Q7XjY=";
      })
    ];

    meta = {
      description = "WebRTC Voice Activity Detector";
      homepage = "https://github.com/webrtc-mirror/webrtc";
      platforms = lib.platforms.linux;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SpeechNote";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "mkiol";
    repo = "dsnote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1ksn6WhMJbh9+9gTnWBx4Z3Hijbe9WZWE1fYqUUWZPs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt5.wrapQtAppsHook
    extra-cmake-modules
  ];

  buildInputs = [
    libpulseaudio
    fmt
    openblas
    mbrola
    espeak-ng
    boost
    webrtcvad
    stt
    vosk
    onnxruntime
    piper-phonemize
    spdlog
    piper
    sam
    ssplitcpp
    python312Packages.pybind11
    rnnoise-nu
    rhvoice
    qt5.qtbase
    qt5.qtdeclarative
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtx11extras
    libsForQt5.kdbusaddons
    opencl-headers
    ocl-icd
    xorg.libXdmcp
    xorg.libXtst
    xorg.libXinerama
    xorg.libXtst
    qhotkey
    libvorbis
    ffmpeg
    taglib
    libnumbertext
    html2md
    rubberband
    libarchive
    xz
    aprilasr
    lame
    xdotool
    maddy
    wayland
    wayland-protocols
    # amdvlk
    # cudaPackages.nvidia_driver
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-declarations -Wno-error"
    "-DWITH_DESKTOP=ON"
    "-DDOWNLOAD_LIBSTT=OFF"
    "-DBUILD_VOSK=OFF"
    "-DBUILD_LIBARCHIVE=OFF"
    "-DBUILD_FMT=OFF"
    "-DBUILD_WHISPERCPP=OFF"
    "-DBUILD_WEBRTCVAD=OFF"
    "-DBUILD_OPENBLAS=OFF"
    "-DBUILD_XZ=OFF"
    "-DBUILD_RNNOISE=OFF"
    "-DBUILD_PYBIND11=OFF"
    "-DBUILD_PYTHON_MODULE=OFF"
    "-DBUILD_ESPEAK=OFF"
    "-DBUILD_ESPEAK_MODULE=OFF"
    "-DBUILD_PIPER=OFF"
    "-DBUILD_SSPLITCPP=OFF"
    "-DBUILD_RHVOICE=OFF"
    "-DBUILD_RHVOICE_MODULE=OFF"
    "-DBUILD_BERGAMOT=OFF"
    "-DBUILD_RUBBERBAND=OFF"
    "-DBUILD_FFMPEG=OFF"
    "-DBUILD_TAGLIB=OFF"
    "-DBUILD_LIBNUMBERTEXT=OFF"
    "-DBUILD_QHOTKEY=OFF"
    "-DBUILD_APRILASR=OFF"
    "-DBUILD_HTML2MD=OFF"
    "-DBUILD_MADDY=OFF"
    "-DBUILD_XDO=OFF"
    "-DBUILD_SAM=OFF"
    "-DBUILD_XKBCOMMON=OFF"
  ];

  preConfigure = ''
    substituteInPlace cmake/openblas_pkgconfig.cmake \
      --replace-quiet 'pkg_search_module(openblas openblas)' 'pkg_search_module(openblas blas)'
    substituteInPlace cmake/openblas_pkgconfig.cmake \
      --replace-quiet 'pkg_search_module(openblas REQUIRED openblas)' 'pkg_search_module(openblas REQUIRED blas)'
  '';

  meta = {
    description = "Speech recognition and text-to-speech application. Note taking, reading and translating with offline Speech to Text, Text to Speech and Machine Translation";
    homepage = "https://github.com/mkiol/SpeechNote";
    changelog = "https://github.com/mkiol/dsnote/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.iamanaws ];
    mainProgram = "dsnote";
    platforms = lib.platforms.linux;
  };
})
