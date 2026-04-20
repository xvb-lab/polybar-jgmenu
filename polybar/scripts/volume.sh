#!/usr/bin/env bash
SINK=$(pactl get-default-sink 2>/dev/null)
[ -z "$SINK" ] && { echo "vol?"; exit 0; }

VOL=$(pactl get-sink-volume "$SINK" | grep -oP '\d+(?=%)' | head -1)
MUTE=$(pactl get-sink-mute "$SINK" | awk '{print $2}')
STAMP="/tmp/polybar-vol-stamp-$USER"

TRAYBG="#141d28"
TRAYFG="#ffffff"

if [ "$MUTE" = "yes" ] || [ "$VOL" -eq 0 ]; then
    icon=$'\ue04f'; color="#e78284"
elif [ "$VOL" -lt 34 ]; then
    icon=$'\ue04e'; color="$TRAYFG"
elif [ "$VOL" -lt 67 ]; then
    icon=$'\ue04d'; color="$TRAYFG"
else
    icon=$'\ue050'; color="$TRAYFG"
fi

show_pct=0
if [ -f "$STAMP" ]; then
    age=$(( $(date +%s) - $(stat -c %Y "$STAMP") ))
    [ "$age" -lt 3 ] && show_pct=1
fi

if [ "$show_pct" -eq 1 ]; then
    echo "%{B$TRAYBG} %{F$color}%{T2}$icon%{T-} ${VOL}%%{F-}%{B-}"
else
    echo "%{B$TRAYBG} %{F$color}%{T2}$icon%{T-} %{F-}%{B-}"
fi
