#!/usr/bin/env bash
icon=$'\ue322'
usage=$(free | awk '/^Mem:/ {printf "%d", $3/$2*100}')
if   [ "$usage" -lt 70 ]; then color="#ffffff"
elif [ "$usage" -lt 90 ]; then color="#e5c890"; ~/.config/polybar/scripts/hw_toggle.sh show &
else                          color="#e78284"; ~/.config/polybar/scripts/hw_toggle.sh show &
fi
echo "%{B#141d28} %{F$color}%{T2}$icon%{T-} ${usage}%%{F-}   %{B-}"
