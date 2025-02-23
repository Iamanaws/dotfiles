{
  description = "iamanaws' nix flake";

  inputs = {
    #### Nixpkgs ####

    # Nixpkgs source, pinned for the entire system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #### NIXOS ####

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Flakes for system packages
    hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    #### DARWIN ####

    nix-darwin = {
      # url = "github:LnL7/nix-darwin";
      url = "github:Iamanaws/nix-darwin/controlcenter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    #### Home manager ####
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Import host configurations
      hosts = import ./hostnames.nix { inherit inputs; };

      # The set of systems to provide outputs for
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs allSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
          }
        );
    in
    {
      # Custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        { pkgs }:
        {
          default = import ./pkgs { inherit pkgs; };
        }
      );

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Formatter for nix files, use 'nix fmt'
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

      ### NixOS Configurations ###
      nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.nixos) (
        hostName:
        let
          host = hosts.nixos.${hostName};
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            systemType = host.systemType;
          };
          modules = host.modules;
        }
      );

      ### Darwin Configurations ###
      darwinConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.darwin) (
        hostName:
        let
          host = hosts.darwin.${hostName};
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs outputs;
            systemType = null;
          };
          modules = host.modules;
        }
      );
    };
}
