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

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"    "aarch64-linux"   "i686-linux"
      "x86_64-darwin"   "aarch64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Import hostnames.nix
    hosts = import ./nixos/hostnames.nix;
    
  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });


    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

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
    nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts) (hostName:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./nixos/hosts/${hostName} 
        ];
      }
    );

  };
}
