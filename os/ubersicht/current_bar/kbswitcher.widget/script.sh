#!/bin/bash

VAR=`/usr/local/bin/xkbswitch -ge`
#VAR=`/usr/bin/osascript -e 'tell application "System Events" to tell process "SystemUIServer" to get the value of the first menu bar item of menu bar 1 whose description is "text input"'`


if [ "$VAR" = "ABC" ]; then
    echo "EN"
else
    echo "BR"
fi
