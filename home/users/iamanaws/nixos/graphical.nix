{
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  config = lib.optionalAttrs (systemType != null) {

    home.packages = with pkgs; [
      bitwarden
      cutter
      # gramps
      pcmanfm
    ];

    home.pointerCursor = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      x11.enable = true;
    };

    # Configure GTK themes
    gtk = {
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
      defaultApplications = {
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

    programs.rofi = {
      enable = true;
      # font = "CascadiaCode";
      theme = "Arc-Dark";
      extraConfig = {
        show-icons = true;
      };
    };

  };
}
