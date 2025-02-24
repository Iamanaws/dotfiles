{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../.
  ];

  sops = {
    age.keyFile = "/home/iamanaws/.config/sops/age/keys.txt";

    secrets = {
      passwd = {
        sopsFile = ./passwd;
        format = "binary";
      };
    };
  };
}
