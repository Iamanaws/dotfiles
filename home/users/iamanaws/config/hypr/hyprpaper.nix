{ config, ... }: {

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [ "~/dotfiles/media/shared/wallpapers/walls/zerebro.jpg" ];

      wallpaper = [ ",~/dotfiles/media/shared/wallpapers/walls/zerebro.jpg" ];
    };
  };

}
