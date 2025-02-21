{ stdenv, callPackage, lib, ... }:

let
  pname = "mongodb-compass";
  version = "1.45.2";
  meta = {
    description = "GUI for MongoDB";
    homepage = "https://github.com/mongodb-js/compass";
    license = lib.licenses.sspl;
    maintainers = with lib.maintainers; [ bryanasdev000 friedow iamanaws ];
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
    mainProgram = "mongodb-compass";
  };
in if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
