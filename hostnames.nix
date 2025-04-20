# hostnames.nix

{ ... }:

{
  nixos = {
    /*
      systemType: null | "x11" | "wayland";
      modules: [ path ];
    */

    alpha = {
      modules = [ ./nixos/hosts/alpha ];
    };

    archimedes = {
      systemType = "wayland";
      modules = [ ./nixos/hosts/archimedes ];
    };

    daedalus = {
      modules = [ ./nixos/hosts/daedalus ];
    };

    goliath = {
      systemType = "wayland";
      modules = [ ./nixos/hosts/goliath ];
    };

    pwnbox = {
      systemType = "wayland";
      modules = [ ./nixos/hosts/pwnbox ];
    };

    # vm-vbox = {
    #   systemType = "wayland";
    #   modules = [ ./hosts/vm-vbox.nix ];
    # };
  };

  darwin = {
    Charles = {
      modules = [ ./darwin/hosts/charles ];
    };
    Galileo = {
      modules = [ ./darwin/hosts/galileo ];
    };
  };

}
