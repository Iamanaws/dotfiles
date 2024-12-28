{ lib, stdenvNoCC, fetchFromGitLab, gtk3 }:

stdenvNoCC.mkDerivation rec {
  pname = "kuyen-icon-theme";
  version = "7d4fdecf";

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "kuyen-icons";
    rev = version;
    sha256 = "sha256-28AAcjg8f0FWwbYeYOMX5OJX2eYL6/a3dgu1HlkW2ZU=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/kuyen-icons
    cp -r * $out/share/icons/kuyen-icons
  '';

  meta = with lib; {
    description = "A colourful flat theme designed for Plasma desktop";
    homepage = "https://gitlab.com/froodo_alexis/kuyen-icons";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iamanaws ];
  };
}
