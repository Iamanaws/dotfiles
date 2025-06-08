#!/usr/bin/env bash

brightness=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
dunstify -a "osd" -u low -h int:value:"$brightness" "󰃠 Brightness: ${brightness}%"
