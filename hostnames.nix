# hostnames.nix

{ inputs }:

{
  nixos = {
    /***
      systemType: null | "x11" | "wayland";
      moduleFile: path;
      system: string (default: "x86_64-linux");
        Options:
          - "x86_64-linux"  - "aarch64-linux"   - "i686-linux"
          - "x86_64-darwin" - "aarch64-darwin"
    */

    # server = {
    #   systemType = null;
    #   moduleFile = ./roles/server;
    # };

    goliath = {
      systemType = "wayland";
      modules = [ 
        ./nixos/hosts/goliath
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];
    };

    archimedes = {
      systemType = "wayland";
      modules = [ 
        ./nixos/hosts/archimedes
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
      ];
    };

    alpha = {
      systemType = null;
      modules = [
        ./nixos/hosts/alpha
      ];
    };

    # vm-vbox = {
    #   systemType = "wayland";
    #   modules = [ ./hosts/vm-vbox.nix ];
    # };
  };

  darwin = {
    # Example: Galileo
    Galileo = {
      modules = [
        ./darwin/hosts/galileo
      ];
    };
  };
  
}
