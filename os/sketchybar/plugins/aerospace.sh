#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
# ICON='●'
# ICON='󱓻'
# ICON="$1."

all=$(aerospace list-windows --workspace "$1" | awk -F '|' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

readarray -t apps < <(aerospace list-windows --workspace "$1" | awk -F '|' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

icons=""
for app in "${apps[@]}"; do

    case $app in
    "Google Chrome")
        icon="󰊯"
        ;;
    "Preview")
        icon=""
        ;;
    "System Settings")
        icon=""
        ;;
    "WezTerm")
        icon=""
        ;;
    "Microsoft Outlook")
        icon="󰇰"
        ;;
    "Microsoft Teams")
        icon="󰻞"
        ;;
    "Microsoft PowerPoint")
        icon="󰈨"
        ;;
    "Microsoft Word")
        icon="󰈭"
        ;;
    "Microsoft Excel")
        icon="󰈜"
        ;;
    "Microsoft AutoUpdate")
        # do not show this annoying app
        # icon="󰚰"
        icon=""
        ;;
    *)
        icon="󱤆"
        ;;
    esac
    icons="$icons $icon"
done

# Trim leading space and display the result
icons=$(echo "$icons" | xargs)
# echo "$icons"
# echo "$FOCUSED_WORKSPACE $1 $NAME"
ICON="$icons"
ICON="$1 $icons"

if [ ! -z "$FOCUSED_WORKSPACE" ]; then
    echo "$FOCUSED_WORKSPACE" >~/.last_focused_workspace
else
    FOCUSED_WORKSPACE=$(cat ~/.last_focused_workspace)
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on icon="$ICON" background.color=0x99050505 icon.color='0xffFFA500' icon.font.size=13 #label="$1" label.drawing=on
    # sketchybar --set "$NAME" background.drawing=off icon="$ICON" icon.color='0xffdfbf8e'
else
    sketchybar --set "$NAME" background.drawing=on icon="$ICON" background.color=0x77050505 icon.color='0x99dfbf8e' icon.font.size=13
    # sketchybar --set "$NAME" background.drawing=off icon='○'
fi
# echo "A=$A"
# echo "---> $1 $FOCUSED_WORKSPACE $AEROSPACE_FOCUSED_WORKSPACE"
