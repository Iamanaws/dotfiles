{
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

let
  dunst-scripts = pkgs.symlinkJoin {
    name = "dunst-scripts";
    paths = [
      (pkgs.writeShellScriptBin "audio.sh" ''
        ${builtins.readFile ./scripts/audio.sh}
      '')
      (pkgs.writeShellScriptBin "brightness.sh" ''
        ${builtins.readFile ./scripts/brightness.sh}
      '')
      (pkgs.writeShellScriptBin "date.sh" ''
        ${builtins.readFile ./scripts/date.sh}
      '')
      (pkgs.writeShellScriptBin "battery.sh" ''
        ${builtins.readFile ./scripts/battery.sh}
      '')
      (pkgs.writeShellScriptBin "cpu-mem.sh" ''
        ${builtins.readFile ./scripts/cpu-mem.sh}
      '')
    ];
  };
in
{
  home.packages = with pkgs; [ dunst-scripts ];

  services.dunst = lib.optionalAttrs (systemType != null) {
    enable = true;

    settings = {
      global = {
        enable_posix_regex = true;
        width = "(200,350)";
        height = 300;
        origin = "top-right";
        offset = "10x10";
        transparency = 10;
        frame_color = "#eceff1";
        font = "CaskaydiaCove NF";
        corner_radius = 5;
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };

      osd = {
        set_stack_tag = "osd";
      };
    };
  };
}
