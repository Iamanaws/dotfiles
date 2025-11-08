{ config, ... }:
{

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [ "~/repos/dotfiles/media/shared/wallpapers/tor/privacy_is_a_human_right.png" ];

      wallpaper = [ ",~/repos/dotfiles/media/shared/wallpapers/tor/privacy_is_a_human_right.png" ];
    };
  };

}
