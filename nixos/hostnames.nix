# hostnames.nix

{ inputs }:

{
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
    systemType = "x11";
    modules = [ ./hosts/goliath ];
  };

  archimedes = {
    systemType = "wayland";
    modules = [ 
      ./hosts/archimedes
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    ];
  };

  # vm-vbox = {
  #   systemType = "wayland";
  #   modules = [ ./hosts/vm-vbox.nix ];
  # };
}