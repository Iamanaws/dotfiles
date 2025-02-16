{ config, lib, pkgs, hostConfig, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;

    settings = {

      ### MONITORS ##
      # monitor = name, resolution, position, scale
      monitor = if hostConfig.options.hostname == "goliath" then [
        "DP-3, 1920x1080@143.98Hz, 0x0, auto"
        "HDMI-A-4, 1920x1080@100.00Hz, 1920x0, auto"
      ] else
        ",preferred,auto,auto";

      xwayland = { force_zero_scaling = true; };

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
        ''
          systemd-inhibit --who="Hyprland config" --why="hyprlock/wlogout keybind" --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit''
      ];

      exec-shutdown = [ ''kill -9 "$(cat /tmp/.hyprland-systemd-inhibit)"'' ];

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
      master = { new_status = "master"; };

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

        touchpad = { natural_scroll = true; };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = { workspace_swipe = true; };

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
      bindd = [
        "$mod, return, open terminal, exec, $terminal"
        "$mod, W, open browser, exec, $browser"
        "$mod, E, open file explorer, exec, $explorer"
        "$mod, C, open code editor, exec, $codeEditor"
        "$mod SHIFT, C, open color picker, exec, $colorPicker"
        "$mod, I, show system info, exec, hyprsysteminfo"

        "$mod, R, open app menu, exec, $menu drun"
        "$mod1, space, open app menu, exec, $menu drun"
        "$mod1 SHIFT, space, open full menu, exec, $menu"

        "$mod SHIFT, W, close active window, killactive,"
        "$mod, M, exit session, exit,"
        "$mod, L, lock session, exec, loginctl lock-session"

        "$mod, V, toggle floating window, togglefloating,"
        "$mod, P, toggle pseudo mode, pseudo, # dwindle"
        "$mod, J, toggle split mode, togglesplit, # dwindle"

        # Move focus with $mod + arrow keyshyprpicker
        "$mod, left, focus left, movefocus, l"
        "$mod, right, focus right, movefocus, r"
        "$mod, up, focus up, movefocus, u"
        "$mod, down, focus down, movefocus, d"

        # Example special workspace (scratchpad)
        "$mod, S, toggle scratchpad workspace, togglespecialworkspace, magic"
        "$mod SHIFT, S, move window to scratchpad, movetoworkspace, special:magic"

        # Scroll through existing workspaces with $mod + scroll
        "$mod, mouse_down, switch to next workspace, workspace, e+1"
        "$mod, mouse_up, switch to previous workspace, workspace, e-1"
      ] ++ (
        #### WORKSPACES ####

        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = toString (i + 1);
          in [
            "$mod, code:1${toString i}, workspace ${ws}, workspace, ${ws}"
            "$mod SHIFT, code:1${
              toString i
            }, move to workspace ${ws}, movetoworkspace, ${ws}"
          ]) 9));

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
      binddm = [
        "$mod, mouse:1, move window, movewindow"
        "$mod, mouse:3, resize window, resizewindow"
      ];

      binddr = [
        # ", XF86XK_ModeLock, exec, loginctl lock-session"
        ", XF86PowerOff, lock session, exec, loginctl lock-session" # wlogout
      ];

      # >= v0.46.0
      binddlo = [ ", XF86PowerOff, shutdown system, exec, shutdown now" ];

      binddel = [
        # Laptop multimedia keys for volume and LCD brightness
        ", XF86AudioRaiseVolume, increase volume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, decrease volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, increase brightness, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, decrease brightness, exec, brightnessctl s 10%-"
        "SHIFT, XF86MonBrightnessUp, fine increase brightness, exec, brightnessctl s 5%+"
        "SHIFT, XF86MonBrightnessDown, fine decrease brightness, exec, brightnessctl s 5%-"
      ];

      binddl = [
        # Muting and unmuting audio and microphone
        ", XF86AudioMute, toggle audio mute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, toggle microphone mute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Play/pause, next, previous
        ", XF86AudioNext, play next track, exec, playerctl next"
        ", XF86AudioPause, toggle play/pause, exec, playerctl play-pause"
        ", XF86AudioPlay, toggle play/pause, exec, playerctl play-pause"
        ", XF86AudioPrev, play previous track, exec, playerctl previous"

        # Lock on lid open and close
        # ", switch:on:Lid Switch, suspend system, exec, systemctl suspend"
        # ", switch:off:Lid Switch, lock session, exec, loginctl lock-session"
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
