{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "mongodb-atlas-cli";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    rev = "atlascli/v${version}";
    sha256 = "sha256-LCnUIip1XdAFOAP0KnQOl9GUhkEZ45tpFUwzoU7zi04=";
  };

  vendorHash = "sha256-Cet3oVTiuR1UqjRwIo5IQqcePoUm25+G75dTVV1Q0Sk=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/atlas" ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  meta = {
    description = "Atlas CLI enables you to manage your MongoDB Atlas";
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.all;
    mainProgram = "atlas";
  };
}
