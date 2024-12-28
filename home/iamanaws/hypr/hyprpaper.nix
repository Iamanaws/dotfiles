{
  config,
  ...
}: {

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [
        "~/dotfiles/config/media/wallpapers/walls/zerebro.jpg"
      ];

      wallpaper = [ 
        ",~/dotfiles/config/media/wallpapers/walls/zerebro.jpg"
      ];
    };
  };

}