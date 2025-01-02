from libqtile import layout
from libqtile.config import Match
from .theme import colors

# Layouts and layout rules

layout_conf = {'border_width': 2,
                'margin': 4,
                'border_focus': colors['focus'][0],
                'border_normal': colors['inactive']
                } 

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_conf),
    layout.MonadWide(**layout_conf),
    layout.Bsp(**layout_conf),
    layout.Matrix(colums=2, **layout_conf),
    layout.RatioTile(**layout_conf),
    # layout.Columns(**layout_conf),
    # layout.Stack(num_stacks=2),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_conf = {'border_width': 2,
                'margin': 4,
                'border_focus': colors['color5'][0],
                'border_normal': colors['inactive']
                } 

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **floating_conf,
)