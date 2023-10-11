#!/bin/sh

if [ $1 == "restart" ]; then
    # https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
    /usr/local/bin/yabai --restart-service
    # https://github.com/koekeishiya/skhd
    /usr/local/bin/skhd --restart-service
else
    VAR=$(ps aux | grep yabai | grep "[/]usr/local/bin/yabai")

    if [ $VAR == "0" ]; then
        echo "off"
    else
        echo "on"
    fi
fi
