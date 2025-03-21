{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "mongodb-cli";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-cli";
    rev = "mongocli/v${version}";
    sha256 = "sha256-vhx8dxTNngDBy+34e+Er7uqIAGJImJiPmwxZX+EwIG0=";
  };

  vendorHash = "sha256-825S3jMwgZC3aInuahg6/jg4A9u/bKeie30MB9HexJY=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/mongocli" ];

  postInstall = ''
    installShellCompletion --cmd mongocli \
      --bash <($out/bin/mongocli completion bash) \
      --fish <($out/bin/mongocli completion fish) \
      --zsh <($out/bin/mongocli completion zsh)
  '';

  meta = {
    description = "MongoDB CLI enable you to manage your MongoDB via ops manager and cloud manager";
    homepage = "https://github.com/mongodb/mongodb-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.all;
    mainProgram = "mongocli";
  };
}
