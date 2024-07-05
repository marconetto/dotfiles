#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=off icon='●' icon.color='0xffdfbf8e'
else
  sketchybar --set "$NAME" background.drawing=off icon='●' icon.color='0x44dfbf8e'
  # sketchybar --set "$NAME" background.drawing=off icon='○'
fi
