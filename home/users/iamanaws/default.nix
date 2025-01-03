# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  ...
}: 

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./config
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.stable-packages
      outputs.overlays.hyprlock
      outputs.overlays.hypridle

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "iamanaws";
    homeDirectory = "/home/iamanaws";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    cutter
    gramps
    pcmanfm
  ];

  # Add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Copy Qtile config
  home.file = lib.optionalAttrs (systemType == "x11") {
    qtile_config = {
      source = ../config/qtile;
      target = ".config/qtile";
      recursive = true;
    };
  };

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    x11.enable = true;
  };

  # Configure GTK themes
  gtk = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
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
    defaultApplications = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
      "application/octet-stream" = [ "re.rizin.cutter.desktop" ];
      "application/pdf"          = [ "code.desktop" ];
      "application/json"         = [ "code.desktop" ];

      "image/*"       = [ "imv.desktop" ];
      "image/gif"     = [ "imv.desktop" ];
      "image/jpeg"    = [ "imv.desktop" ];
      "image/png"     = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
      "image/webp"    = [ "imv.desktop" ];

      "text/*"        = [ "code.desktop" ];
      "text/html"     = [ "code.desktop" ];
      "text/plain"    = [ "code.desktop" ];

      "video/*"       = [ "com.github.rafostar.Clapper.desktop" ];
      "video/mp4"     = [ "com.github.rafostar.Clapper.desktop" ];
      "video/mpeg"    = [ "com.github.rafostar.Clapper.desktop" ];
      "video/ogg"     = [ "com.github.rafostar.Clapper.desktop" ];
      "video/webm"    = [ "com.github.rafostar.Clapper.desktop" ];
    };
  };

  programs.rofi = lib.optionalAttrs (systemType == "x11" || systemType == "wayland") {
    enable = true;
    package = lib.optionalAttrs (systemType == "wayland") pkgs.rofi-wayland;
    # font = "CascadiaCode";
    theme = "Arc-Dark";
    extraConfig = {
      show-icons = true;
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "fnaicdffflnofjppbagibeoednhnbjhg" # floccus
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "lnjaiaapbakfhlbjenjkhffcdpoompki" # catppuccin github icons
      "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # material icons for git
    ];

    commandLineArgs = [
      # "--enable-features=UseOzonePlatform "
      # "--ozone-platform=x11"
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "iamanaws";
    userEmail = "78835633+Iamanaws@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      fetch.prune = true;
      fetch.prunetags = true;
      merge.conflictStyle = "zdiff3";
      push.autosetupremote = true;
      push.followtags = true;

      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      help.autocorrect = "prompt";

      #log.date = "iso";
      branch.sort = "-committerdate";
      tag.sort = "taggerdate";

      # better submodule logs
      status.submoduleSummary = true;
      diff.submodule = "log";

      # avoid data corruption
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };

    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };

    ignores = [
      ".env"

      ".DS_Store"
      # ".vscode"
      # ".idea"
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
