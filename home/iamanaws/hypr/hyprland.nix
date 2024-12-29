{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    xwayland.enable = true;
    systemd.enable = false;

    settings = {
      
      ### MONITORS ##
      
      monitor = ",preferred,auto,auto";

      xwayland = {
        force_zero_scaling = true;
      };


      ### PROGRAMS ###

      "$terminal" = "kitty";
      "$browser" = "brave";
      "$explorer" = "pcmanfm";
      "$codeEditor" = "code";
      "$screenshot" = "flameshot";
      "$menu" = "rofi -show";
      "$colorPicker" = "hyprpicker -a";


      ### AUTOSTART ###hyprpaper

      # exec-once = $terminal
      # exec-once = nm-applet &
      exec-once = [
        "hyprpaper"
        "hypridle"
        # "waybar"
        "systemctl --user start hyprpolkitagent"
        "systemd-inhibit --who=\"Hyprland config\" --why=\"hyprlock/wlogout keybind\" --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit"
      ];
      
      exec-shutdown = [
        "kill -9 \"$(cat /tmp/.hyprland-systemd-inhibit)\""
      ];


      ### ENVIRONMENT VARIABLES ###

      env = [
        "HYPRCURSOR_SIZE,24"

        "XCURSOR_SIZE,24"
        "GDK_SCALE,2"
      ];


      ### LOOK AND FEEL ###

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        "col.active_border" = lib.mkForce "rgba(33ccffee) rgba(00ff99ee) 60deg";
        "col.inactive_border" = lib.mkForce "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
            enabled = false;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            enabled = false;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          "workspaces,1,1.94,almostLinear,fade"
          "workspacesIn,1,1.21,almostLinear,fade"
          "workspacesOut,1,1.94,almostLinear,fade"
        ];

      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
          pseudotile = true;
          preserve_split = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
          new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          middle_click_paste = false;
          vfr = true;
      };


      ### INPUT ###

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
          kb_layout = "latam";

          follow_mouse = 1;

          sensitivity = 0.8; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
              natural_scroll = true;
          };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
          workspace_swipe = true;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      # elan06c6:00-04f3:3193-mouse, elan06c6:00-04f3:3193-touchpad, tpps/2-elan-trackpoint
      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
        {
            name = "tpps/2-elan-trackpoint";
            sensitivity = 0.5;
        }
      ];

      ### KEYBINDINGS ###
      
      # SHIFT CAPS CTRL/CONTROL ALT MOD2 MOD3 SUPER/WIN/LOGO/MOD4 MOD5
      "$mod" = "SUPER";
      "$mod1" = "ALT";

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mod, return, exec, $terminal"
        "$mod, W, exec, $browser"
        "$mod, E, exec, $explorer"
        "$mod, C, exec, $codeEditor"
        "$mod SHIFT, C, exec, $colorPicker"
        "$mod, I, exec, hyprsysteminfo"
        
        "$mod, R, exec, $menu drun"
        "$mod1, space, exec, $menu drun"
        "$mod1 SHIFT, space, exec, $menu"

        "$mod SHIFT, W, killactive,"
        "$mod, M, exit,"
        "$mod, L, exec, loginctl lock-session"
        ", XF86XK_ModeLock, exec, loginctl lock-session"
        ", XF86PowerOff, exec, loginctl lock-session" # wlogout

        "$mod, V, togglefloating,"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"

        # Move focus with $mod + arrow keyshyprpicker
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with $mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ] 
      ++ (
        #### WORKSPACES ####

        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );

      # https://wiki.hyprland.org/Configuring/Binds/#bind-flags
      # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # o -> longPress, will trigger on long press of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse, see below.
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      # s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
      # d -> has description, will allow you to write a description for your bind.
      # p -> bypasses the app's requests to inhibit keybinds.

      # Move/resize windows with $mod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:1, movewindow"
        "$mod, mouse:3, resizewindow"
      ];

      # >= v0.46.0
      bindo = [
        ", XF86PowerOff, exec, shutdown now"
      ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      bindl = [
        # Muting and unmuting audio and microphone
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        
        # Play/pause, next, previous
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"

        # Lock on lid open and close
        # ", switch:on:Lid Switch, exec, loginctl lock-session"
        ", switch:off:Lid Switch, exec, systemctl suspend"
      ];


      ### WINDOWS AND WORKSPACES ###

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule v1
      # windowrule = "float, ^(kitty)$";

      # Example windowrule v2
      # windowrulev2 = "float,class:^(kitty)$,title:^(kitty)$";

      windowrulev2 = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

    };
  };

}