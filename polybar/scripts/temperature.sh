#!/usr/bin/env bash
icon=$'\ue1ff'
temp=$(sensors 2>/dev/null | awk '/^Package id 0:/ {gsub(/[+°C]/,"",$4); print int($4); exit}')
[ -z "$temp" ] && temp=$(awk '{printf "%d", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
[ -z "$temp" ] && temp=0
if   [ "$temp" -lt 65 ]; then color="#ffffff"
elif [ "$temp" -lt 85 ]; then color="#e5c890"; ~/.config/polybar/scripts/hw_toggle.sh show &
else                         color="#e78284"; ~/.config/polybar/scripts/hw_toggle.sh show &
fi
echo "%{B#141d28} %{F$color}%{T2}$icon%{T-} ${temp}°C %{F-}   %{B-}"
