{
  lib,
  buildEnv,
  mongodb-atlas-cli,
  mongosh,
}:

buildEnv {
  pname = "mongodb-atlas";
  version = mongodb-atlas-cli.version;
  meta = {
    description = "MongoDB Atlas is a meta-package that installs the Atlas CLI for deployments and the MongoDB Shell.";
    homepage = "https://github.com/mongodb/mongodb-atlas-cli";
    license = [
      mongodb-atlas-cli.meta.license
      mongosh.meta.license
    ];
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms =
      let
        atlasPlatforms = mongodb-atlas-cli.meta.platforms;
        mongoshPlatforms = mongosh.meta.platforms;
      in
      lib.filter (p: lib.elem p atlasPlatforms) mongoshPlatforms;
  };

  name = "mongodb-atlas";

  paths = [
    mongodb-atlas-cli
    mongosh
  ];
}
