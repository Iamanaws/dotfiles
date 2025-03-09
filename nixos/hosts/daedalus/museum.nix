{ config, pkgs, ... }:

{
  imports = [ ../../services/museum/museum.nix ];

  services.museum = {
    enable = true;
    dataDir = "/var/lib/museum";
    logFile = ""; # leave empty to log to stdout
    db = {
      host = "localhost";
      port = 5432;
      name = "ente_db";
      sslmode = "disable";
      createLocally = true;
    };
    s3 = {
      enabled = true;
      endpoint = "http://localhost:9000";
      accessKey = "your-minio-access-key";
      secretKey = "your-minio-secret-key";
      bucket = "museum-bucket";
      createLocally = true;
    };
  };
}
