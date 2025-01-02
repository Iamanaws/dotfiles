# Qtile config file

import sys
import os
from libqtile import hook
from libqtile.log_utils import logger
import subprocess
from os import path

# # Add the parent directory containing the `settings` module to the Python path
# current_directory = os.path.dirname(__file__)
# sys.path.append(os.path.join(current_directory))

# Import settings modules
from settings.keys import mod, keys
from settings.groups import groups, dgroups_key_binder
from settings.layouts import layouts, floating_layout
from settings.widgets import widget_defaults, extension_defaults
from settings.screens import screens
from settings.mouse import mouse
#from settings.path import qtile_path

# @hook.subscribe.startup_once
# def autostart():
#     home = path.expanduser('~/.config/qtile/autostart.sh')
#     subprocess.call([home])

main = None
# dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = "urgent"
reconfigure_screens = True
auto_minimize = False
wl_input_rules = None
wmname = "LG3D"