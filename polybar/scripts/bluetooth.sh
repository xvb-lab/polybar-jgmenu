#!/usr/bin/env bash
icon=$'\ue1a7'
TRAYBG="#141d28"
TRAYFG="#ffffff"

POWERED=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2; exit}')
if [ "$POWERED" != "yes" ]; then
    color="#e78284"
else
    CONNECTED=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
    if [ "$CONNECTED" -gt 0 ]; then
        color="$TRAYFG"
    else
        color="#e5c890"
    fi
fi
echo "%{B$TRAYBG} %{F$color}%{T2}$icon%{T-} %{F-}%{B-}"
