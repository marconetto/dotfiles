msgfile="pomodoro.widget/message.txt"
# msgfile="message.txt"

if [ -z "$(cat ${msgfile})" ] ; then
    echo ""
    exit

fi
originaltime=`cat $msgfile | awk '{print $1}'`
pomodoro=`cat $msgfile | awk '{print $2}'`


# V=`cat pomodoro.widget/message.txt`
# space=`/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq .index`

currenttime=`date +%s`
# echo $originaltime
# echo $currenttime

totalseconds=$(($currenttime - $originaltime))
# echo $totalseconds
totalminutes=$(($totalseconds / 60))
# echo $totalminutes
# V=`pwd`
# echo ""$V

remaining=$(($pomodoro - $totalminutes))
if [[ $remaining -le 0 ]]; then
    echo "DONE"
    # echo "⏱ DONE"
else
    # echo "⏰ "$remaining
    echo ""$remaining
    # echo "⏱ "$remaining
fi

# > simplealert.widget/message.txt
