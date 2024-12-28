#!/usr/bin/env sh 

VBoxClient --vmsvga &

# Composer
picom &

# Network
nm-applet &

# Wallpaper
nitrogen --restore &
