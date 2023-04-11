CMD=`lsappinfo front`
CMD=`lsappinfo info -only name $CMD`
IFS='=' read -ra ADDR <<< "$CMD"
progname=${ADDR[1]}
progname=`echo $progname | sed s/\"//g`
showname=`echo $progname | cut -c 1-3`

# showname=`echo $showname | tr '[a-z]' '[A-Z]'`

string='My long string'
if [[ $progname == *"PowerPoint"* ]]; then
  showname="PPT"
elif [[ $progname == *"Word"* ]]; then
  showname="DOC"
elif [[ $progname == *"Exc"* ]]; then
  showname="XLS"
elif [[ $progname == *"Slack"* ]]; then
  showname="SLK"
elif [[ $progname == *"Google"* ]]; then
  showname="CHR"
elif [[ $progname == *"Outlook"* ]]; then
  showname="OUT"
elif [[ $progname == *"Teams"* ]]; then
  showname="TEA"
elif [[ $progname == *"Brave"* ]]; then
  showname="BRV"
fi

showname=`echo $showname | tr '[A-Z]' '[a-z]'`
# showname=`echo $showname | tr '[a-z]' '[A-Z]'`

space=`/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq .index`

echo "$space $showname"
