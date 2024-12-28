{
  config,
  ...
}: {

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [
        "~/dotfiles/config/wallpapers/minimal/zerebro.jpg"
      ];

      wallpaper = [ 
        ",~/dotfiles/config/wallpapers/minimal/zerebro.jpg"
      ];
    };
  };

}