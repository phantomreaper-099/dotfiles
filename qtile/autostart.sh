#!/bin/sh
nm-applet &
dunst &
export QT_QPA_PLATFORMTHEME=qt5ct
blueman-applet &
birdtray &
nitrogen --random --set-scaled ~/MyFiles/Wallpapers 
picom &
~/.local/bin/eww open-many apps stats music keybind
