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
    logFile = "";
    s3 = {
      bucket = "museum-bucket";
      createLocally = true;
    };
  };
}
