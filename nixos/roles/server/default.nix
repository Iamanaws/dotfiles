# minimal.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../core ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 53 ];
  };

  services.openssh = {
    enable = true;
    ports = [ 3939 ];
    allowSFTP = false;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;

      "AllowTcpForwarding" = "yes";
      "AllowAgentForwarding" = "no";
      "AllowStreamLocalForwarding" = "no";
      "AuthenticationMethods" = "publickey";
    };
  };
}
