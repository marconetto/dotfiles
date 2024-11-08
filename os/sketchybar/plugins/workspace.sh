#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

WS=$(aerospace list-workspaces --focused)

labelfont="SF Mono:SemiBold:12.0"
if [ "$WS" == "8" ]; then
    WS=""
    labelfont="Hack Nerd Font:Bold:12.0"

fi
sketchybar --set "$NAME" label="$WS " label.font="$labelfont" width=46
