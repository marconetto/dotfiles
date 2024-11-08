#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

WS=$(aerospace list-workspaces --focused)

# labelfont="Monaco:Bold:11.0"
labelfont="SF Mono:SemiBold:11.0"
if [ "$WS" == "8" ]; then
    WS=""
    labelfont="Hack Nerd Font:Bold:11.0"

fi
# sketchybar --set "$NAME" label="$WS " label.font="$labelfont"
sketchybar --set "$NAME" label="$WS " label.font="$labelfont" width=50
