{
  stdenv,
  stdenvNoCC,
  fetchurl,
  unzip,
  lib,
  ...
}:

let
  pname = "mongodb-atlas-cli";
  version = "1.39.0";
  meta = {
    description = "Atlas CLI enables you to manage your MongoDB Atlas";
    maintainers = with lib.maintainers; [ iamanaws ];
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "atlas";
  };

  system = stdenv.hostPlatform.system;
  isDarwin = stdenv.hostPlatform.isDarwin;

  # Distribution information for each platform.
  dist =
    if isDarwin then
      {
        aarch64-darwin = {
          arch = "arm64";
          sha256 = "sha256-gftjTOaxaqyQXIXjaJwFNarioEeB90AczRNvK1lfvhM=";
        };
        x86_64-darwin = {
          arch = "x86_64";
          sha256 = "sha256-kms4ZtmNdAxBlmu+YCSB5TgkOwasyNtaltCykNkYPx8=";
        };
      }
    else
      {
        x86_64-linux = {
          arch = "x86_64";
          sha256 = "sha256-UMaLwoZiY9KwSyaJFxTgtC2COk1sLmvUkykve772lDg=";
        };
        aarch64-linux = {
          arch = "arm64";
          sha256 = "sha256-++wXf+1cMmKIT76j92qDi3FjNPKC6qKCp10uXIX/i8M=";
        };
      };

  # Base URL and file extension depend on the platform.
  baseUrl = "https://fastdl.mongodb.org/mongocli/mongodb-atlas-cli_";
  ext = if isDarwin then ".zip" else ".tar.gz";
  url =
    if isDarwin then
      "${baseUrl}${version}_macos_${dist.${system}.arch}${ext}"
    else
      "${baseUrl}${version}_linux_${dist.${system}.arch}${ext}";

  # Use stdenvNoCC on Darwin, stdenv on Linux.
  drv = if isDarwin then stdenvNoCC else stdenv;
in
drv.mkDerivation {
  inherit pname version meta;
  src = fetchurl {
    url = url;
    sha256 = dist.${system}.sha256;
    name = "${pname}-${version}${ext}";
  };

  # On Darwin we need to manually unzip and disable automatic fixup/unpacking.
  dontUnpack = isDarwin;
  dontFixup = isDarwin;
  nativeBuildInputs = lib.optional isDarwin unzip;

  installPhase = ''
    runHook preInstall
    ${if isDarwin then "unzip \"$src\"" else ""}
    mkdir -p $out/bin
    install -Dm755 bin/atlas $out/bin/atlas
    runHook postInstall
  '';
}
