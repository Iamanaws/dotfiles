{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "kuyen-icons";
      package = pkgs.kuyen-icons;
    };

    settings = {
      global = {
        enable_posix_regex = true;
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "20x20";
        transparency = 10;
        frame_color = "#eceff1";
        font = "caskaydia-cove";
        corner_radius = 5;
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
