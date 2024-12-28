import os
from libqtile import widget, qtile
from .theme import colors
from .keys import terminal

def base(fg='text', bg='dark'): 
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }

def separator():
    return widget.Sep(**base(), linewidth=0, padding=6)

def icon(fg='text', bg='dark', fontsize=16, text="?", pdd=4):
    return widget.TextBox(
        **base(fg, bg),
        fontsize=fontsize,
        text=text,
        padding=pdd
    )

# Powerline Icons:
#  nf-ple-left_half_circle_thick
#  nf-ple-right_half_circle_thick

#  nf-oct-triangle_left
#  nf-oct-triangle_right

#  nf-fa-caret_left
#  nf-fa-caret_right

# 󰍞 nf-md-menu_left
# 󰍟 nf-md-menu_right

#  nf-pl-right_hard_divider
#  nf-pl-left_hard_divider

def powerline(fg='light', bg='dark'):
    return widget.TextBox(
        **base(fg, bg),
        text="",
        fontsize=36,
        padding=-1
    )

def workspaces():
    return [
        #separator(),
        widget.GroupBox(
            **base(fg='light'),
            font='CaskaydiaCove Nerd Font Mono',
            fontsize=24,
            margin_y=3,
            margin_x=0,
            padding_y=0,
            padding_x=2,
            borderwidth=1,
            active=colors['active'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border=colors['urgent'],
            this_current_screen_border=colors['focus'],
            this_screen_border=colors['grey'],
            other_current_screen_border=colors['dark'],
            other_screen_border=colors['dark'],
            disable_drag=True
        ),
        separator(),
        widget.Prompt(
            **base(fg='light')
            ),
        widget.WindowName(
            **base(fg='focus'), 
            fontsize=16 
        ),
        separator()
    ]

def updates():
    return [
        separator(),
        powerline('color1', 'dark'),
        icon(bg="color1", fontsize=14, text=' ', ),
        # widget.CheckUpdates(
        #     background=colors['color1'],
        #     colour_have_updates=colors['text'],
        #     colour_no_updates=colors['text'],
        #     no_update_string='0',
        #     display_format='{updates}',
        #     update_interval=60,
        #     custom_command='checkupdates',
        #     mouse_callbacks = {
        #         'Button1': lambda: qtile.cmd_spawn(
        #             terminal + ' -e sudo pacman -Syu'
        #         )},
        # )
        # widget.CheckUpdates(
        #     background=colors['color1'],
        #     colour_have_updates=colors['text'],
        #     colour_no_updates=colors['text'],
        #     no_update_string='0',
        #     display_format='{updates}',
        #     update_interval=30,
        #     custom_command='sudo nixos-rebuild dry-run --flake .#nixos | grep -c "will be built" || echo 0',
        #     mouse_callbacks={
        #         'Button1': lambda: qtile.cmd_spawn(
        #             terminal + ' -e sudo nixos-rebuild switch --flake .#nixos'
        #         )},
        # )
    ]

def network():
    return [
        powerline('color3', 'color1'),
        icon(bg="color3", fontsize=14, text=''),
        widget.Net(
            **base(bg='color3'), 
            interface='enp0s3',
            format='{down}↓↑{up}',
            prefix='M',
            use_bits=False
        )
    ]

def resources():
    # CPU: 󰘚 nf-md-chip,  nf-fae-chip
    # Memory: 󰍛 nf-md-memory
    return [
        powerline('color2', 'color3'),

        icon(bg="color2", fontsize=14, text=' '),
        widget.CPU(
            **base(bg='color2'),
            format='{load_percent}%'
            ),
        
        icon(bg="color2", fontsize=18, text='󰍛', pdd=5),
        widget.Memory(
            **base(bg='color2'),
            measure_mem='M',
            format='{MemUsed:.0f}{mm}',
            
        )
    ]

def layout():
    return [
        powerline('color6', 'color2'),
        widget.CurrentLayoutIcon(
            **base(bg='color6'), scale=0.60,
            custom_icon_paths = [
                os.path.expanduser("~/.config/qtile/icons")]
            ),
        widget.CurrentLayout(**base(bg='color6'))
    ]

def clock():
    # 󰃵 nf-md-calendar_text
    #  nf-fa-clock_o
    return [
        powerline('color5', 'color6'),
        icon(bg="color5", fontsize=16, text='󰃵'),
        widget.Clock(**base(bg='color5'), format='%d/%m/%Y   %H:%M', timezone=None)
    ]

def systray():
    return [
        powerline('dark', 'color5'),
        widget.Systray(
            background=colors['dark'],
            icon_size=14,
            padding=4
        )
    ]

def logout():
    # 󰍃 nf-md-logout
    return [
        widget.QuickExit(
        default_text=" 󰍃 ",
        background=colors['dark'],
        fontsize=14,
        countdown_format=" {} "
        ), 
        separator()
    ]


my_widgets = [
    *workspaces(),    
    *updates(),
    *network(),
    *resources(),
    *layout(),            
    *clock(),
    *systray(),
    *logout()    
]

widget_defaults = {
    'font': 'UbuntuMono Nerd Font Bold',
    'fontsize': 14,
    'padding': 5,
}
extension_defaults = widget_defaults.copy()

    # widget.Chord(
    #     chords_colors={
    #         "launch": ("#ff0000", "#ffffff"),
    #     },
    #     name_transform=lambda name: name.upper(),
    # ),
    # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
    # widget.TermalSensor()
