#!/bin/sh

if [ $1 == "restart" ]; then
    /usr/local/bin/brew services restart yabai
    /usr/local/bin/brew services restart skhd
else
    VAR=`ps aux | grep yabai | grep opt | wc -l`

    if [ $VAR == "0" ]; then
        echo "off"
    else
        echo "on"
    fi
fi
