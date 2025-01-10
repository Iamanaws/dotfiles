{
  description = "This is my flake";

  inputs = {
    #### Nixpkgs ####

    # The “main” Nixpkgs channel (current), pinned for the entire system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Additional channels
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    #### NIXOS ####

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Flakes for system packages
    hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";

    #### DARWIN ####

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
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
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    # Shameless plug: looking for a way to nixify your themes and make
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,  
    nixpkgs-unstable,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Set the default system
    system = "x86_64-linux";

    # Import host configurations
    hosts = import ./hostnames.nix { inherit inputs; };

    # Import nixpkgs with unfree packages allowed
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    
    # Import nixpkgs with unfree packages allowed
    pkgsStable = import nixpkgs-stable {
      inherit system;
      config = { allowUnfree = true; };
    };

    # Import nixpkgs-unstable with unfree packages allowed
    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };

  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = import ./pkgs { inherit pkgs; };

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    # formatter = pkgs.alejandra;

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays { inherit inputs; };

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;

    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    ### NixOS Configurations ###
    nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.nixos) (hostName:
      let
        host = hosts.nixos.${hostName};
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs pkgs;
            systemType = host.systemType;
            allPkgs = {
              default  = pkgs;
              stable   = pkgsStable;
              unstable = pkgsUnstable;
            };
          };
          modules = host.modules;
        }
    );

    ### Darwin Configurations ###
    darwinConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.darwin) (hostName:
      let
        host = hosts.darwin.${hostName};
      in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = host.modules;
        }
    );

  };
}
