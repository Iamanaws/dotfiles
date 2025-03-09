{ config, pkgs, ... }:

{
  imports = [ ../../services/museum/museum.nix ];

  services.ente-web = {
    enable = true;
    env = {
      NEXT_PUBLIC_ENTE_ENDPOINT = "http://localhost:8080";
    };
  };

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
      bucket = "museum-bucket";
      createLocally = true;
    };
  };
}
