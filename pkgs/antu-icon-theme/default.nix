{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  gtk3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "antu-icon-theme";
  version = "a12a9e55";

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "antu-icons";
    rev = version;
    sha256 = "sha256-CLcr+X/b0moVEBV0O/dzCDq4w5G2+KRLUBdqKm0eAKA=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/antu-icons
    cp -r * $out/share/icons/antu-icons

    # Remove or fix broken symlinks
    find $out/share/icons/kuyen-icons -xtype l -delete
  '';

  meta = with lib; {
    description = "A smooth icon theme designed for Plasma Desktop";
    homepage = "https://gitlab.com/froodo_alexis/Antu-icons";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iamanaws ];
  };
}
