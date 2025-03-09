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
        description = "Name of the database and user used by museum.";
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
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = "If true, a local PostgreSQL instance will be enabled and the database/user created automatically.";
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
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = "If true, a local Minio instance will be enabled for S3 object storage.";
      };
    };
  };

  config = mkIf cfg.enable {

    # Enable local PostgreSQL if requested.
    services.postgresql = lib.mkIf cfg.db.createLocally {
      enable = true;
      ensureDatabases = [ cfg.db.name ];
      ensureUsers = [
        {
          name = cfg.db.name;
          ensureDBOwnership = true;
        }
      ];
    };

    # Enable local Minio if S3 and createLocally are true.
    services.minio = lib.mkIf (cfg.s3.enabled && cfg.s3.createLocally) {
      enable = true;
      dataDir = [ "${cfg.dataDir}/minio-data" ];
      configDir = "/var/lib/minio/config";
      certificatesDir = "/var/lib/minio/certs";
      accessKey = cfg.s3.accessKey;
      secretKey = cfg.s3.secretKey;
    };

    # Also generate configurations/local.yaml.
    environment.etc."museum/configurations/local.yaml".text = ''
      # This file is required by museum.
      log-file: "${cfg.logFile}"
      db:
        host: "${cfg.db.host}"
        port: ${toString cfg.db.port}
        name: "${cfg.db.name}"
        sslmode: "${cfg.db.sslmode}"
      s3:
        enabled: ${if cfg.s3.enabled then "true" else "false"}
        endpoint: "${cfg.s3.endpoint}"
        accessKey: "${cfg.s3.accessKey}"
        secretKey: "${cfg.s3.secretKey}"
        bucket: "${cfg.s3.bucket}"
      key:
        encryption: yvmG/RnzKrbCb9L3mgsmoxXr9H7i2Z4qlbT0mL3ln4w=
        hash: KXYiG07wC7GIgvCSdg+WmyWdXDAn6XKYJtp/wkEU7x573+byBRAYtpTP0wwvi8i/4l37uicX1dVTUzwH3sLZyw==
      jwt:
        secret: i2DecQmfGreG6q1vBj5tCokhlN41gcfS2cjOs9Po-u8=   
    '';

    # Adjust the systemd service: set WorkingDirectory to /etc/museum so museum finds its files.
    systemd.services.museum = {
      description = "Museum (Ente Server) service";
      after = [
        "network.target"
        "postgresql.service"
        "minio.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.museum}/bin/museum";
        # Set WorkingDirectory to where we placed our configuration files.
        WorkingDirectory = "/etc/museum";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
      environment = {
        # Optional: pass environment variables if museum uses them too.
        ENTE_LOG_FILE = cfg.logFile;
        ENTE_DB_HOST = cfg.db.host;
        ENTE_DB_PORT = toString cfg.db.port;
        ENTE_DB_NAME = cfg.db.name;
        ENTE_DB_USER = cfg.db.name;
        ENTE_DB_PASSWORD =
          if cfg.db.passwordFile != null then toString cfg.db.passwordFile else "passwd123";
        ENTE_DB_SSLMODE = cfg.db.sslmode;
        ENTE_S3_ENABLED = if cfg.s3.enabled then "true" else "false";
        ENTE_S3_ENDPOINT = cfg.s3.endpoint;
        ENTE_S3_ACCESS_KEY = cfg.s3.accessKey;
        ENTE_S3_SECRET_KEY = cfg.s3.secretKey;
        ENTE_S3_BUCKET = cfg.s3.bucket;
      };
      path = [
        pkgs.museum
        pkgs.postgresql
        pkgs.minio
      ];
    };

    # Create the museum user and group if using defaults.
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

    # Ensure the data directory exists with proper permissions.
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} ${cfg.user} ${cfg.group} 0750 -"
    ];
  };

  meta.maintainers = with maintainers; [ iamanaws ];
}
