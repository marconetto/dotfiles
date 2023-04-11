# CMD=`lsappinfo front`
# CMD=`lsappinfo info -only name $CMD`
# IFS='=' read -ra ADDR <<< "$CMD"
# progname=${ADDR[1]}
# progname=`echo $progname | sed s/\"//g`
# showname=`echo $progname | cut -c 1-3`
# showname=`echo $showname | tr '[a-z]' '[A-Z]'`

# string='My long string'
# if [[ $progname == *"PowerPoint"* ]]; then
  # showname="PPT"
# elif [[ $progname == *"Word"* ]]; then
  # showname="DOC"
# elif [[ $progname == *"Exc"* ]]; then
  # showname="XLS"
# elif [[ $progname == *"Slack"* ]]; then
  # showname="SLK"
# elif [[ $progname == *"Google"* ]]; then
  # showname="CHR"
# elif [[ $progname == *"Brave"* ]]; then
  # showname="BRV"
# fi

# space=`/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq .index`


VAL=`pmset -g batt | grep -o '[0-9]*%; [a-zA-Z]*' | sed s/%// | sed s/\;//`
IFS=' ' read -ra ADDR <<< "$VAL"
perc=${ADDR[0]}
status=${ADDR[1]}

if [[ $status == "charged" && "$perc" == "100" ]]; then
   perc="$perc"
   perc="f"
elif [[ $status == "charged" && "$perc" != "100" ]]; then
   perc="$perc"c
elif [[ $status == "charging" || $status == "finishing" ]]; then
   perc="$perc"c
elif [[ $status == "discharging" && "$perc" -lt 10 ]]; then
   perc="$perc!!!"
elif [[ $status == "discharging"  ]]; then
   perc="$perc"d
elif [[ $status == "AC" ]]; then
   perc="$perc"a
fi

echo "$perc $status"
