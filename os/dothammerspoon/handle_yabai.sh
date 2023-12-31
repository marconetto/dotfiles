#!/bin/sh

if [ "$1" == "restart" ]; then
  # https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
  /usr/local/bin/yabai --stop-service
  /usr/local/bin/yabai --start-service
  /usr/local/bin/skhd --stop-service
  /usr/local/bin/skhd --start-service
  # if restart is used but yabai is not running
  # it won't start yabai
else
  VAR=$(pgrep yabai)
  # VAR=$(ps aux | grep yabai | grep "[/]usr/local/bin/yabai")

  if [ -z "$VAR" ]; then
    echo "off"
  else
    echo "on"
  fi
fi
