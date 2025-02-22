# hostnames.nix

{ ... }:

{
  nixos = {
    /*
      systemType: null | "x11" | "wayland";
      modules: [ path ];
    */

    goliath = {
      systemType = "wayland";
      modules = [ ./nixos/hosts/goliath ];
    };

    archimedes = {
      systemType = "wayland";
      modules = [ ./nixos/hosts/archimedes ];
    };

    alpha = {
      modules = [ ./nixos/hosts/alpha ];
    };

    # vm-vbox = {
    #   systemType = "wayland";
    #   modules = [ ./hosts/vm-vbox.nix ];
    # };
  };

  darwin = {
    Galileo = {
      modules = [ ./darwin/hosts/galileo ];
    };
    Charles = {
      modules = [ ./darwin/hosts/charles ];
    };
  };

}
