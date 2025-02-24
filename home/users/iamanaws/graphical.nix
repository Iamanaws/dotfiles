{
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  config = lib.optionalAttrs (systemType != null) {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
        "dphilobhebphkdjbpfohgikllaljmgbn" # simplelogin
        "fnaicdffflnofjppbagibeoednhnbjhg" # floccus
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        "oldceeleldhonbafppcapldpdifcinji" # language tool
        "lnjaiaapbakfhlbjenjkhffcdpoompki" # catppuccin github icons
        "gbmdgpbipfallnflgajpaliibnhdgobh" # json viewer
        "gaiceihehajjahakcglkhmdbbdclbnlf" # video speed controller
        "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
      ];

      commandLineArgs = [
        # "--enable-features=UseOzonePlatform "
        # "--ozone-platform=x11"
      ];
    };
  };
}
