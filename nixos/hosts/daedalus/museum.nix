{ config, pkgs, ... }:

{
  imports = [ ../../services/museum.nix ];

  # Enable and configure the museum service
  services.museum = {
    enable = true;
    # Path to the YAML configuration (typically similar to local.yaml)
    configFile = "/etc/museum/local.yaml";
    # Directory for persistent data
    dataDir = "/var/lib/museum";
    # Optional log file; leave empty for stdout logging
    logFile = "/var/log/museum.log";

    # Database configuration
    db = {
      host = "localhost";
      port = 5432;
      name = "ente_db";
      user = "museum"; # or another DB user
      passwordFile = "/run/keys/museum-db-password"; # File containing DB password
      sslmode = "disable";
    };

    # Optional S3 (Minio) integration
    s3 = {
      enabled = true;
      endpoint = "http://localhost:9000";
      accessKey = "your_minio_access_key";
      secretKey = "your_minio_secret_key";
      bucket = "museum-bucket";
    };

    # Any extra configuration values to pass via environment
    extraConfig = {
      CUSTOM_OPTION = "customValue";
    };
  };

  # Enable PostgreSQL service if you plan to have museum create/use a local DB.
  services.postgresql.enable = true;
  services.postgresql.ensureDatabases = [ "ente_db" ];
  services.postgresql.ensureUsers = [
    {
      name = "museum";
      ensureDBOwnership = true;
    }
  ];

  # Enable Minio service for S3-compatible storage if needed
  services.minio.enable = true;
  services.minio.dataDir = [ "/var/lib/minio/data" ];
  services.minio.configDir = "/var/lib/minio/config";
  services.minio.certificatesDir = "/var/lib/minio/certs";
  services.minio.rootCredentialsFile = "/etc/nixos/minio-root-credentials"; # or use accessKey/secretKey options

  # You may also want to create the museum user/group if using the defaults.
  users.users.museum = {
    isSystemUser = true;
    home = "/var/lib/museum";
  };

  # After modifying the configuration, rebuild your system:
  # $ sudo nixos-rebuild switch
}
