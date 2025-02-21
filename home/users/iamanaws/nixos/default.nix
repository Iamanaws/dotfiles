{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    ../.
    ../config/shell/bash.nix
  ];

  home = {
    username = "iamanaws";
    homeDirectory = "/home/iamanaws";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    cutter
    gramps
    pcmanfm
  ];

  # Add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Copy Qtile config
  home.file = lib.optionalAttrs (systemType == "x11") {
    qtile_config = {
      source = ../config/qtile;
      target = ".config/qtile";
      recursive = true;
    };
  };

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    x11.enable = true;
  };

  # Configure GTK themes
  gtk = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
    enable = true;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
    iconTheme = {
      name = "kuyen-icons";
      package = pkgs.kuyen-icons;
    };
  };

  # mimeApps - find / -name '*.desktop'
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
      "application/octet-stream" = [ "re.rizin.cutter.desktop" ];
      "application/pdf" = [ "code.desktop" ];
      "application/json" = [ "code.desktop" ];

      "image/*" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];

      "text/*" = [ "code.desktop" ];
      "text/html" = [ "code.desktop" ];
      "text/plain" = [ "code.desktop" ];

      "video/*" = [ "com.github.rafostar.Clapper.desktop" ];
      "video/mp4" = [ "com.github.rafostar.Clapper.desktop" ];
      "video/mpeg" = [ "com.github.rafostar.Clapper.desktop" ];
      "video/ogg" = [ "com.github.rafostar.Clapper.desktop" ];
      "video/webm" = [ "com.github.rafostar.Clapper.desktop" ];
    };
  };

  programs.rofi = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
    enable = true;
    package = lib.optionalAttrs (systemType == "wayland") pkgs.rofi-wayland;
    # font = "CascadiaCode";
    theme = "Arc-Dark";
    extraConfig = {
      show-icons = true;
    };
  };
}
