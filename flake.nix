{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs

    # The “main” Nixpkgs channel (current), pinned for the entire system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Additional channels
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    # Additional flakes
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Shameless plug: looking for a way to nixify your themes and make
    # nix-colors.url = "github:misterio77/nix-colors";

    # Flakes for system packages
    hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    hyprlock.url = "path:/home/iamanaws/hyprlock";
    hypridle.url = "path:/home/iamanaws/hypridle";

    # ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Set the default system
    system = "x86_64-linux";

    # Import host configurations
    hosts = import ./nixos/hostnames.nix;

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

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts) (name:
      let
        host = hosts.${name};
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
          modules = [ host.moduleFile ];
        }
    );

  };
}
