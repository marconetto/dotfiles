DEFAULT_NAME="spotify"

PLAYING_COLOR=0xffa6da95
PAUSED_COLOR=0xffffa217

MAIN_PLAYING_ICON=󱑽
MAIN_PAUSED_ICON=󰐎

PLAYER_PAUSED_ICON=󰏤
PLAYER_PLAYING_ICON=

turnoff() {

  sketchybar --set "$DEFAULT_NAME.playpause" icon="$XICON" label="$ICON" label.drawing=off icon.drawing=off

}
update_playpause_icon() {

  running=$(osascript -e 'application "Spotify" is running')
  if [ "$running" = "false" ]; then
    turnoff
    return
  else
    PLAYER_STATE=$(osascript -e 'tell application "Spotify" to player state')
    case "$PLAYER_STATE" in
    "playing" | "Playing")
      ICON=$PLAYER_PLAYING_ICON
      ;;
    "paused" | "Paused")
      ICON=$PLAYER_PAUSED_ICON
      ;;
    *)
      # ICON=$PLAYER_PAUSED_ICON
      turnoff
      return
      ;;
    esac
  fi

  XICON=""

  sketchybar --set "$DEFAULT_NAME.playpause" icon="$XICON" label="$ICON" label.drawing=on icon.drawing=on
}

update_playpause_icon
