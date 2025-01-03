{
  config,
  pkgs,
  ...
}: {

  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    
    # settings = {

    # };

    # style = {

    # };

  };
  
}