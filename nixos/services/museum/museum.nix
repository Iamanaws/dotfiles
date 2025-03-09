{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  museumCfg = config.services.museum;
  enteWebCfg = config.services.ente-web;
  enteWeb = pkgs.ente-web.override {
    extraBuildEnv = enteWebCfg.env;
  };
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

  options.services.ente-web = {
    enable = mkEnableOption "Ente Web service (Ente Web interface)";
    user = mkOption {
      type = types.str;
      default = "museum";
      description = "User for the ente-web service.";
    };
    group = mkOption {
      type = types.str;
      default = "museum";
      description = "Group for the ente-web service.";
    };
    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port on which the ente-web service is served.";
    };
    env = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra environment variables for the ente-web service.";
    };
  };

  config = mkMerge [
    (mkIf museumCfg.enable {
      # --- Museum Service Configuration ---

      # Enable local PostgreSQL if requested.
      services.postgresql = lib.mkIf museumCfg.db.createLocally {
        enable = true;
        ensureDatabases = [ museumCfg.db.name ];
        ensureUsers = [
          {
            name = museumCfg.db.name;
            ensureDBOwnership = true;
          }
        ];
      };

      # Enable local Minio if S3 and createLocally are true.
      services.minio = lib.mkIf (museumCfg.s3.enabled && museumCfg.s3.createLocally) {
        enable = true;
        dataDir = [ "${museumCfg.dataDir}/minio-data" ];
        configDir = "/var/lib/minio/config";
        certificatesDir = "/var/lib/minio/certs";
        accessKey = museumCfg.s3.accessKey;
        secretKey = museumCfg.s3.secretKey;
      };

      # Copy museum files into /etc/museum.
      environment.etc."museum" = {
        source =
          pkgs.runCommand "museum-dir"
            {
              buildInputs = [ pkgs.museum ];
            }
            ''
              mkdir -p $out
              cp -R ${pkgs.museum}/share/museum/* $out/
            '';
      };

      # Adjust the systemd service for museum.
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
          WorkingDirectory = "/etc/museum";
          User = museumCfg.user;
          Group = museumCfg.group;
          Restart = "on-failure";
        };
        environment = {
          ENTE_LOG_FILE = museumCfg.logFile;
          ENTE_DB_HOST = museumCfg.db.host;
          ENTE_DB_PORT = toString museumCfg.db.port;
          ENTE_DB_NAME = museumCfg.db.name;
          ENTE_DB_USER = museumCfg.db.name;
          ENTE_DB_PASSWORD =
            if museumCfg.db.passwordFile != null then toString museumCfg.db.passwordFile else "passwd123";
          ENTE_DB_SSLMODE = museumCfg.db.sslmode;
          ENTE_S3_ENABLED = if museumCfg.s3.enabled then "true" else "false";
          ENTE_S3_ENDPOINT = museumCfg.s3.endpoint;
          ENTE_S3_ACCESS_KEY = museumCfg.s3.accessKey;
          ENTE_S3_SECRET_KEY = museumCfg.s3.secretKey;
          ENTE_S3_BUCKET = museumCfg.s3.bucket;
        };
        path = [
          pkgs.museum
          pkgs.postgresql
          pkgs.minio
        ];
      };

      # Create museum user/group if using defaults.
      users.users = lib.mkIf (museumCfg.user == "museum") {
        museum = {
          isSystemUser = true;
          group = museumCfg.group;
          home = museumCfg.dataDir;
        };
      };

      users.groups = lib.mkIf (museumCfg.group == "museum") {
        museum = { };
      };

      # Ensure the data directory exists.
      systemd.tmpfiles.rules = [
        "d ${museumCfg.dataDir} ${museumCfg.user} ${museumCfg.group} 0750 -"
      ];
    })
    (mkIf enteWebCfg.enable {
      # --- Ente Web Service Configuration ---
      #
      # Launch a systemd service that serves the static files built by the
      # ente-web package using a simple HTTP server.
      systemd.services.ente-web = {
        description = "Ente Web service (Ente Web interface)";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.nodePackages.http-server}/bin/http-server ${enteWeb} -p ${toString enteWebCfg.port}";
          User = enteWebCfg.user;
          Group = enteWebCfg.group;
          Restart = "on-failure";
        };
      };
    })
  ];

  meta.maintainers = with maintainers; [ iamanaws ];
}
