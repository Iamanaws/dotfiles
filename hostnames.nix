# hostnames.nix

{ inputs }:

{
  nixos = {
    goliath = {
      modules = [ 
        ./nixos/hosts/goliath
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];
    };

    archimedes = {
      modules = [ 
        ./nixos/hosts/archimedes
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
      ];
    };

    # vm-vbox = {
    #   systemType = "wayland";
    #   modules = [ ./hosts/vm-vbox.nix ];
    # };
  };

  darwin = {
    Galileo = {
      modules = [
        ./darwin/hosts/galileo
      ];
    };
  };
  
}
