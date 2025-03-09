{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.museum;
in
{
  options.services.museum = {
    enable = mkEnableOption "Museum (Ente Server) service";

    user = mkOption {
      type = types.str;
      default = "museum";
      description = "User under which museum runs.";
    };

    group = mkOption {
      type = types.str;
      default = "museum";
      description = "Group under which museum runs.";
    };

    configFile = mkOption {
      type = types.path;
      default = "/etc/museum/local.yaml";
      description = "Path to the museum YAML configuration file. This file typically follows the default (local.yaml).";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/museum";
      description = "Directory where museum stores its persistent data.";
    };

    logFile = mkOption {
      type = types.str;
      default = "";
      description = "Path to a log file. If empty, museum will log to stdout.";
    };

    db = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "PostgreSQL host for museum.";
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL port number.";
      };

      name = mkOption {
        type = types.str;
        default = "ente_db";
        description = "Name of the database used by museum.";
      };

      user = mkOption {
        type = types.str;
        default = "";
        description = "Database user for museum. Can also be set via the ENTE_DB_USER environment variable.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a file containing the database password.";
      };

      sslmode = mkOption {
        type = types.str;
        default = "disable";
        description = "SSL mode to use when connecting to PostgreSQL.";
      };
    };

    s3 = {
      enabled = mkOption {
        type = types.bool;
        default = false;
        description = "Enable S3 (Minio) integration for museum.";
      };

      endpoint = mkOption {
        type = types.str;
        default = "http://localhost:9000";
        description = "S3 (Minio) endpoint URL.";
      };

      accessKey = mkOption {
        type = types.str;
        default = "";
        description = "S3 access key.";
      };

      secretKey = mkOption {
        type = types.str;
        default = "";
        description = "S3 secret key.";
      };

      bucket = mkOption {
        type = types.str;
        default = "";
        description = "Name of the S3 bucket used by museum.";
      };
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = { };
      description = "Additional museum configuration options (key-value pairs) that will be available via the environment.";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.museum = {
      description = "Museum (Ente Server) service";
      after = [
        "network.target"
        "postgresql.service"
        "minio.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.museum}/bin/museum --config ${cfg.configFile}";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";

        Environment = {
          # Logging
          ENTE_LOG_FILE = cfg.logFile;
          # Database settings
          ENTE_DB_HOST = cfg.db.host;
          ENTE_DB_PORT = toString cfg.db.port;
          ENTE_DB_NAME = cfg.db.name;
          ENTE_DB_USER = cfg.db.user;
          ENTE_DB_PASSWORD_FILE = if cfg.db.passwordFile != null then toString cfg.db.passwordFile else "";
          ENTE_DB_SSLMODE = cfg.db.sslmode;
          # S3/Minio settings (even if not enabled, you can override these)
          ENTE_S3_ENABLED = if cfg.s3.enabled then "true" else "false";
          ENTE_S3_ENDPOINT = cfg.s3.endpoint;
          ENTE_S3_ACCESS_KEY = cfg.s3.accessKey;
          ENTE_S3_SECRET_KEY = cfg.s3.secretKey;
          ENTE_S3_BUCKET = cfg.s3.bucket;
          # Additional options can be passed as needed.
        };
      };

      path = [
        pkgs.museum
        pkgs.postgresql
        pkgs.minio
      ];
    };

    # Create the museum user and group (if using the defaults)
    users.users = lib.mkIf (cfg.user == "museum") {
      museum = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "museum") {
      museum = { };
    };

    # Ensure the data directory exists with proper ownership and permissions.
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} ${cfg.user} ${cfg.group} 0750 -"
    ];
  };

  meta.maintainers = with maintainers; [ iamanaws ];
}
