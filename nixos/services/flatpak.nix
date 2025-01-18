{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpakgit.nixosModules.nix-flatpak
  ];

  # https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;
  xdg.portal.enable = true;
}