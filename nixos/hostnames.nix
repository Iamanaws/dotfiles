# hostnames.nix
{
  /***
    systemType: null | "x11" | "wayland";
    moduleFile: path;
    system: string (default: "x86_64-linux");
      Options:
        - "x86_64-linux" - "aarch64-linux" - "i686-linux"
        - "x86_64-darwin" - "aarch64-darwin"
 */

  # nixos = {
  #   systemType = null;
  #   moduleFile = ./nixos/backup.nix;
  # };
  # server = {
  #   systemType = null;
  #   moduleFile = ./hosts/core.nix;
  # };
  desktop = {
    systemType = "x11";
    moduleFile = ./hosts/desktop.nix;
  };
  laptop = {
    systemType = "wayland";
    moduleFile = ./hosts/laptop.nix;
  };
}