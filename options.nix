{ lib, ... }:

with lib; {
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/doc/manual/development/option-types.section.md
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/doc/manual/development/option-declarations.section.md
  options = {
    options = {
      system = mkOption {
        type = types.parsedPlatform;
        default = "x86_64-linux";
        description =
          "The system architecture (e.g., x86_64-linux, aarch64-linux).";
      };
      type = mkOption {
        type = enum [ "server" "laptop" "desktop" ];
        default = "server";
        description = "The machine type (server, laptop, desktop).";
      };
      users = mkOption {
        type = types.listOf str;
        default = [ "iamanaws" ];
        description = "Machine users";
      };
      hostname = mkOption {
        type = types.str;
        default = "nixos";
        description = "Hostname of the machine.";
      };
      displayServer = mkOption {
        type = with types; nullOr (enum [ "wayland" "x11" ]);
        default = null;
        description = "Display server (wayland, x11, or null for headless).";
      };
    };
  };
}
