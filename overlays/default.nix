# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  hyprlock = final: prev: {
    hyprlock-custom = inputs.hyprlock.packages.${final.system}.hyprlock;
  };
  hypridle = final: prev: {
    hypridle-custom = inputs.hypridle.packages.${final.system}.hypridle;
  };
}