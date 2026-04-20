#!/usr/bin/env bash
TRAYBG="#141d28"
TRAYFG="#ffffff"

if [ "$1" = "toggle" ]; then
    DND=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb 2>/dev/null)
    if [ "$DND" = "true" ]; then
        xfconf-query -c xfce4-notifyd -p /do-not-disturb -s false
    else
        xfconf-query -c xfce4-notifyd -p /do-not-disturb -s true
    fi
    exit 0
fi

DND=$(xfconf-query -c xfce4-notifyd -p /do-not-disturb 2>/dev/null)
if [ "$DND" = "true" ]; then
    icon=$'\ue7f6'; color="#e78284"
else
    icon=$'\ue7f4'; color="$TRAYFG"
fi
echo "%{B$TRAYBG} %{F$color}%{T2}$icon%{T-} %{F-}%{B-}"
