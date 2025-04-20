{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "gcknhkkoolaabfmlnjonogaaifnjlfnp" # foxyproxy
      "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "lnjaiaapbakfhlbjenjkhffcdpoompki" # catppuccin github icons
      "gbmdgpbipfallnflgajpaliibnhdgobh" # json viewer
    ];
  };
}
