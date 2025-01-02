from libqtile.config import Screen
from libqtile import bar
from .widgets import my_widgets

def status_bar(widgets):
    return bar.Bar(widgets, 28)

screens = [Screen(top=status_bar(my_widgets))] 
