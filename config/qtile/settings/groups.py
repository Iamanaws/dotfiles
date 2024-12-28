# Qtile workspaces

from libqtile.config import Group
from libqtile.command import lazy
from .keys import mod
# Icons: 
# nf-fae-python, 
# nf-md-firefox, 
# nf-dev-terminal, 
# nf-fa-code, 
# nf-seti-config, 
# nf-md-docker,
# nf-md-folder,
# nf-md-image, 
# nf-md-layers

groups = [
    Group("  ", layout='bsp'),
    Group(" 󰈹 ", layout='max'),
    Group("  ", layout='max'),
    Group("  ", layout='max'),
    Group("  ", layout='max'),
    Group(" 󰡨 ", layout='max'), 
    Group(" 󰉋 ", layout='max'),
    Group(" 󰋩 ", layout='max'),
    Group(" 󰌨 ", layout='max'),
    Group("", layout='max')
]

# Mod + num : Switch workspace
# Mod + Shift + num : Move active window to workspace
from libqtile.dgroups import simple_key_binder
dgroups_key_binder = simple_key_binder(mod)
