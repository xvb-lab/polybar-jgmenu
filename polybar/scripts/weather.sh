#!/usr/bin/env bash
CACHE="/tmp/polybar-weather-$USER"
LOC="London"

# Refresh cache every 30 min
if [ ! -f "$CACHE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -gt 1800 ]; then
    curl -fsS --max-time 5 "https://wttr.in/${LOC}?format=%t|%C|%S|%s" > "${CACHE}.new" 2>/dev/null \
        && mv "${CACHE}.new" "$CACHE"
fi

if [ -s "$CACHE" ]; then
    temp=$(cut -d'|' -f1 "$CACHE" | tr -d '+ °C')
    cond=$(cut -d'|' -f2 "$CACHE")
    sunrise=$(cut -d'|' -f3 "$CACHE")
    sunset=$(cut -d'|' -f4 "$CACHE")
else
    echo "weather?"; exit 0
fi

now_ep=$(date +%s)
sun_ep=$(date -d "$sunrise" +%s 2>/dev/null)
set_ep=$(date -d "$sunset"  +%s 2>/dev/null)
is_day=0
if [ -n "$sun_ep" ] && [ -n "$set_ep" ] \
   && [ "$now_ep" -ge "$sun_ep" ] && [ "$now_ep" -lt "$set_ep" ]; then
    is_day=1
fi

tnum=$(echo "$temp" | grep -oE '\-?[0-9]+' | head -1)
[ -z "$tnum" ] && tnum=18
if   [ "$tnum" -lt 18 ]; then color="#94dcf7"
elif [ "$tnum" -lt 25 ]; then color="#94dcf7"
else                          color="#94dcf7"
fi

shopt -s nocasematch
case "$cond" in
    *Sunny*|*Clear*)
        if [ "$is_day" -eq 1 ]; then icon=$'\ue430'; else icon=$'\ue3a8'; fi ;;
    *Cloud*|*Overcast*|*Mist*|*Fog*)  icon=$'\ue2bd' ;;
    *Rain*|*Drizzle*|*Shower*)        icon=$'\ue2c2' ;;
    *Snow*|*Sleet*)                   icon=$'\ueb3b' ;;
    *)                                icon=$'\ue430' ;;
esac

echo "%{F$color}%{T2}$icon%{T-} ${temp}°C%{F-}  "
