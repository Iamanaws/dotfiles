{
  config,
  pkgs,
  ...
}: {

  programs.waybar = {
    enable = true;
    package = pkgs.waybar; # pkgsUnstable.waybar;
    
    # settings = {

    # };

    # style = {

    # };

  };
  
}