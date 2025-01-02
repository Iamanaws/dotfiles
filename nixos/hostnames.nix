# hostnames.nix

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
  
  archimedes = {
    system = "x86_64-linux";
    hostname = "archimedes";
    type = "laptop";
    username = "iamanaws";
    displayServer = "wayland";
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
  };

  goliath = {
    system = "x86_64-linux";
    hostname = "goliath";
    type = "desktop";
    username = "iamanaws";
    displayServer = "x11";
  };

  # vm-vbox = {
  #   systemType = "wayland";
  #   modules = [ ./hosts/vm-vbox.nix ];
  # };

}