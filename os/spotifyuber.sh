DIR_SIMPLE_ALERT="$HOME/Library/Application Support/Übersicht/widgets/simplealert.widget/"

truncate_string() {
  local input=$1
  local length=${#input}

  if [ "$length" -le 25 ]; then
    echo "$input"
  else
    echo "${input:0:25}..."
  fi
}

showmesg() {
  msg="$1"
  msgtime=${2:-0.5}
  echo "$1" >"$DIR_SIMPLE_ALERT"/message.txt
  HS=/usr/local/bin/hs
  command="require('init'); show_alert(\"$msg\", 1.0)"
  #  echo "$command" >>"$HOME"/cmd.txt

  "$HS" -c "$command"
  # $HS -c \"require("init"); show_alert(""$msg"", 0.5)\"
  # osascript -e 'tell application "Übersicht" to set hidden of widget id "simplealert-widget-simplealert-coffee" to false'
  # osascript -e 'tell application "Übersicht" to refresh widget id "simplealert-widget-simplealert-coffee"'
  # sleep "$msgtime"
  # osascript -e 'tell application "Übersicht" to set hidden of widget id "simplealert-widget-simplealert-coffee" to true'
}

get_current_track() {
  track=$(osascript -e 'tell application "Spotify" to name of current track')
  track=$(truncate_string "$track")
  echo "$track"
}

operation=$@

running=$(osascript -e 'application "Spotify" is running')
msgtime=0.5

if [ "$running" = "false" ]; then
  echo "Spotify is not running"
  showmesg "Spotify is not running"
  exit 1
fi

if [ "$operation" = "play" ]; then
  osascript -e 'tell application "Spotify" to playpause'
  msg="⏵/⏸ "
  state=$(osascript -e 'tell application "Spotify" to player state')
  msg="$msg : $state"
elif [ "$operation" = "next" ]; then
  osascript -e 'tell application "Spotify" to next track'
  msg="⏭  next: "
  msg="$msg $(get_current_track)"
  showmesg "$msg" "$msgtime"

elif [ "$operation" = "previous" ]; then
  osascript -e 'tell application "Spotify" to previous track'
  msg="⏮  prev: "
  msg="$msg $(get_current_track)"
  showmesg "$msg" "$msgtime"
elif [ "$operation" = "track" ]; then
  msg="⏵   "
  msgtime=2
  msg="$msg $(get_current_track)"
  showmesg "$msg" "$msgtime"
fi
