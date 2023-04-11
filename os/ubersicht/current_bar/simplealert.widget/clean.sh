#!/bin/sh

sleep 5

echo "" > message.txt

osascript -e 'tell application "Übersicht" to refresh widget id "simplealert-widget-simplealert-coffee"'

