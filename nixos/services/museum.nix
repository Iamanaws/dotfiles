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

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to YAML config file. If not provided and local S3 is enabled, a default configuration will be used.";
    };

    env = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra environment variables for the museum service.";
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
        default = "ente_db";
        description = "Name of the user used by museum.";
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

      local.enable = mkEnableOption "Local PostgreSQL service.";
    };

    s3 = {
      local = {
        enable = mkEnableOption "Local S3 (Minio) service.";

        rootCredentialsFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            File containing the MINIO_ROOT_USER, default is "minioadmin", and
            MINIO_ROOT_PASSWORD (length >= 8), default is "minioadmin"; in the format of
            an EnvironmentFile=, as described by {manpage}`systemd.exec(5)`.
          '';
        };
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
      services.postgresql = lib.mkIf museumCfg.db.local.enable {
        enable = true;
        ensureDatabases = [ museumCfg.db.name ];
        ensureUsers = [
          {
            name = museumCfg.db.name;
            ensureDBOwnership = true;
          }
        ];
      };

      # Start Minio if local S3 is enabled.
      services.minio = lib.mkIf museumCfg.s3.local.enable {
        enable = true;
        dataDir = [ "${museumCfg.dataDir}/minio-data" ];
        rootCredentialsFile = museumCfg.s3.local.rootCredentialsFile;
      };

      environment.etc."museum" = {
        source =
          pkgs.runCommand "museum-config"
            {
              buildInputs = [ pkgs.museum ];
            }
            ''
              mkdir -p $out
              cp -R ${pkgs.museum}/share/museum/* $out/

              cat > $out/museum.yaml <<EOF
              ${builtins.readFile museumCfg.configFile}
              EOF
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
          ENTE_DB_USER = museumCfg.db.user;
          ENTE_DB_PASSWORD = if museumCfg.db.passwordFile then toString museumCfg.db.passwordFile else "";
          ENTE_DB_SSLMODE = museumCfg.db.sslmode;
        } // museumCfg.env;
        path = [
          pkgs.museum
          pkgs.postgresql
          pkgs.minio
        ];
      };

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
