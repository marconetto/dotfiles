#!/bin/sh
maxwidth=2
# padchar="·"
# padchar="–"
# padchar="⋅"
# padchar="⋰"
# padchar="▪"
# padchar="■"
# padchar="◜"
# padchar="k"
padchar="◦"
# padchar="⠄"

PREF_NETS="$HOME/.pref_nets"

if [ ! -f "$PREF_NETS" ]; then
    echo "X"
    exit 1
fi

TR="/usr/local/opt/coreutils/libexec/gnubin/tr"
netname=`/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | sed -e 's/^  *SSID: //p' -e d | $TR -d '\n'`


AWK=/usr/local/bin/awk
nickname=`cat "$PREF_NETS" | grep "$netname " |  $AWK {'print $2'}  `

netname=$nickname
if [ "$netname" == "" ] ;then
    netname="nd"
fi


VPNAPP="/opt/cisco/anyconnect/bin/vpn"
SEQ="/usr/local/opt/coreutils/libexec/gnubin/seq"

if [ ! -f "$VPNAPP" ]; then
    vpnconnected="Disconnected"
else
    vpnconnected=`/opt/cisco/anyconnect/bin/vpn state | grep state | head -1 | sed 's/.*\\: //' | tr -d '\n' `
fi


chrlen=${#netname}
# something strage happens counting with and utf-8
# so putting this before adding the utf-8
# TODO?  use wc -m to count chars..
# if [[ "$vpnconnected" == "Connected" ]]; then
    # netname="↑"$netname
# else
    # netname="↓"$netname

# fi



if [[ "$chrlen" -gt "$maxwidth" ]]; then
    V=`echo $netname | cut -c 1-$maxwidth`
elif [[ "$chrlen" -lt "$maxwidth" ]]; then
    let increase=maxwidth-chrlen+1
    pad=`$SEQ -s $padchar $increase | sed 's/[0-9]//g'`
    V=$netname$pad
else
    V=$netname
fi

echo "$V"
