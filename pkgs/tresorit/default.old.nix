{ pkgs }:

let
  # Fetch the tresorit repository
  tresoritSrc = pkgs.fetchFromGitHub {
    owner = "apeyroux";
    repo = "tresorit.nix";
    rev = "673f0f87854d6a805fc0504abbafe28b652d0d17";
    sha256 = "sha256-zj5C4TSEqBTe+FPi+ppbdWqbDcZy/mis1zeXw4kQ4kk=";
  };

  # Import the release.nix from the fetched repository
  tresoritDerivation = import "${tresoritSrc}/release.nix" {
    inherit pkgs;
  };
in
# Return the impure derivation
tresoritDerivation.impure
#pkgs.callPackage (import "${tresoritSrc}/release.nix") { }
#pkgs.callPackage (import tresoritSrc).impure {}
