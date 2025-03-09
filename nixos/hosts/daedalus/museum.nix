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
    configFile = ./museum.yaml;

    s3 = {
      local.enable = true;
    };

    env = {
      ENTE_DB_PASSWORD = "passwd123";
    };
  };
}
