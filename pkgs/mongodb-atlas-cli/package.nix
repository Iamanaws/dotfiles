{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "mongodb-atlas-cli";
  version = "1.41.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-atlas-cli";
    tag = "atlascli/v${version}";
    sha256 = "sha256-fqWtiApOnarP6eWa9RfxJKHb9R/nVvcWpBtYJKLmiso=";
  };

  vendorHash = "sha256-mJ7INuRYBntUGYAFfplNvHpwiK6f8UBwVFjSDiQ2ptU=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/atlas" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  meta = {
    description = "Atlas CLI enables you to manage your MongoDB Atlas";
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    changelog = "https://www.mongodb.com/docs/atlas/cli/current/atlas-cli-changelog/#atlas-cli-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "atlas";
  };
}
