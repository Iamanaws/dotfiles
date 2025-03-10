{ config, pkgs, ... }:

{
  imports = [ ../../../services/museum.nix ];

  services.ente-web = {
    enable = true;
    env = {
      NEXT_PUBLIC_ENTE_ENDPOINT = "http://localhost:8080";
    };
  };

  services.museum = {
    enable = true;
    configFile = ./museum.yaml;

    s3.local = {
      enable = true;
      # rootCredentialsFile = <path>;
      browser = false;
    };

    env = {
      ENTE_DB_PASSWORD = "passwd123";
    };
  };

  environment.systemPackages = with pkgs; [
    ente-cli
  ];
}
