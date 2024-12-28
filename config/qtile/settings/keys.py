# Qtile keybindings

from libqtile.config import Key
from libqtile.command import lazy

mod = "mod4"
mod2 = "mod1"
terminal = "kitty"
browser = "brave"
explorer = "pcmanfm"
codeEditor = "code"
screenshot = "flameshot" 

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack
    ([mod], "Left", lazy.layout.left()),
    ([mod], "Right", lazy.layout.right()),
    ([mod], "Down", lazy.layout.down()),
    ([mod], "Up", lazy.layout.up()),

    ([mod], "space", lazy.layout.next()),
    ([mod2], "Tab", lazy.layout.next()),

    # Move windows in current stack
    ([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    ([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    ([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    ([mod, "shift"], "Up", lazy.layout.shuffle_up()),

    # Grow windows
    ([mod, "control"], "Left", lazy.layout.grow_left(), lazy.layout.shrink()),
    ([mod, "control"], "Right", lazy.layout.grow_right(), lazy.layout.grow()),
    ([mod, "control"], "Down", lazy.layout.grow_down()),
    ([mod, "control"], "Up", lazy.layout.grow_up()),
    
    # Shrink windows
    ([mod, "control", "shift"], "Left", lazy.layout.shrink_left()),
    ([mod, "control", "shift"], "Right", lazy.layout.shrink_right()),
    ([mod, "control", "shift"], "Down", lazy.layout.shrink_down()),
    ([mod, "control", "shift"], "Up", lazy.layout.shrink_up()),

    # Toggle fullscreen and floating
    ([mod], "f", lazy.window.toggle_fullscreen()),
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Toggle split
    ([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Toggle between different layouts as defined below
    ([mod, "control"], "Tab", lazy.next_layout()),
    ([mod, "control", "shift"], "Tab", lazy.prev_layout()),

    # Kill windows
    ([mod, "shift"], "w", lazy.window.kill()),

    # Reload/Restart Qtile
    ([mod, "control"], "r", lazy.reload_config()),
    ([mod, "control", "shift"], "r", lazy.restart()),

    # Log out
    ([mod, "control"], "q", lazy.shutdown()),

    # ------------ App Configs ------------
    
    # Apps Launcher
    ([mod2], "space", lazy.spawn("rofi -show drun")),
    ([mod], "r", lazy.spawncmd()),

    # Terminal
    ([mod], "Return", lazy.spawn(terminal)),

    # Windor nav
    ([mod2, "shift"], "space", lazy.spawn("rofi -show")),

    #Browser
    ([mod], "w", lazy.spawn(browser)),

    # File Explorer
    ([mod], "e", lazy.spawn(explorer)),

    # Code Editor
    ([mod], "c", lazy.spawn(codeEditor)),

    # Screenshot
    ([mod], "s", lazy.spawn(f"{screenshot} gui")),
    ([mod, "shift"], "s", lazy.spawn(f"{screenshot} screen"))    
]]
