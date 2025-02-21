{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  autoPatchelfHook,
  qt5,
  fuse,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tresorit";
  version = "3.5.1244.4360";

  src = fetchFromGitHub {
    owner = "apeyroux";
    repo = "tresorit.nix";
    rev = "673f0f87854d6a805fc0504abbafe28b652d0d17";
    sha256 = "sha256-zj5C4TSEqBTe+FPi+ppbdWqbDcZy/mis1zeXw4kQ4kk=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    qt5.qtbase
    fuse
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
        mkdir -p $out/bin
        cp -r ${src}/default.nix $out/bin/
        cat > $out/bin/install-tresorit-impure <<EOF
    #!/bin/bash
    mkdir -p \$HOME/.local/share/tresorit
    cp -rf ${src}/bin/* \$HOME/.local/share/tresorit/
    chmod +w \$HOME/.local/share/tresorit/tresorit.desktop
    cat >> \$HOME/.local/share/tresorit/tresorit.desktop <<EOL
    Exec=\$HOME/.local/share/tresorit/tresorit %u
    MimeType=x-scheme-handler/tresorit
    Icon=\$HOME/.local/share/tresorit/tresorit.png
    EOL
    ln -s \$HOME/.local/share/tresorit/tresorit.desktop \$HOME/.local/share/applications/tresorit.desktop
    EOF

        chmod +x $out/bin/install-tresorit-impure

        cat > $out/bin/tresorit-impure <<EOF
    #!/bin/bash
    BIN=\$HOME/.local/share/tresorit/tresorit
    if [ -f \$BIN ]; then
      \$BIN "\$@"
    else
      echo "You must first run install-tresorit-impure before using this command."
    fi
    EOF

        chmod +x $out/bin/tresorit-impure

        cat > $out/bin/tresorit-cli-impure <<EOF
    #!/bin/bash
    BIN=\$HOME/.local/share/tresorit/tresorit-cli
    if [ -f \$BIN ]; then
      \$BIN "\$@"
    else
      echo "You must first run install-tresorit-impure before using this command."
    fi
    EOF

        chmod +x $out/bin/tresorit-cli-impure
  '';

  meta = with lib; {
    description = "Tresorit is the ultra-secure place in the cloud to store, sync and share files easily from anywhere, anytime.";
    homepage = "https://tresorit.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.apeyroux ];
  };
}
