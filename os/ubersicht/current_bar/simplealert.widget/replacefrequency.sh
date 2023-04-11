#!/bin/sh

cd "$(dirname "$0")"

file='simplealert.coffee'

val=$1

cat $file | sed "s/refreshFrequency: [a-z0-9]*/refreshFrequency: ${val}/" > "$file".tmp

# mv "$file".tmp $file
echo hello > message.txt


osascript -e 'tell application "Übersicht" to refresh widget id "simplealert-widget-simplealert-coffee"'

# /bin/sh clean.sh &
# sleep 5

# echo "" > message.txt

# osascript -e 'tell application "Übersicht" to refresh widget id "simplealert-widget-simplealert-coffee"'
