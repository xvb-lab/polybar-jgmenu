#!/usr/bin/env bash
icon=$'\ue30d'
read _ a b c idle _ < /proc/stat
total1=$((a+b+c+idle)); idle1=$idle
sleep 0.4
read _ a b c idle _ < /proc/stat
total2=$((a+b+c+idle)); idle2=$idle
dt=$((total2-total1)); di=$((idle2-idle1))
[ "$dt" -le 0 ] && usage=0 || usage=$(( (dt-di)*100/dt ))
if   [ "$usage" -lt 50 ]; then color="#ffffff"
elif [ "$usage" -lt 85 ]; then color="#e5c890"; ~/.config/polybar/scripts/hw_toggle.sh show &
else                          color="#e78284"; ~/.config/polybar/scripts/hw_toggle.sh show &
fi
echo "%{B#141d28}   %{F$color}%{T2}$icon%{T-} ${usage}%%{F-}   %{B-}"
