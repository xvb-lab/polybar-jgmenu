#!/usr/bin/env bash
# Updates: icona scudo che cambia se ci sono update

TRAYBG="#141d28"
ICON_OK=$'\ue8e8'        # scudo "no updates"
ICON_UPD=$'\ue78a'       # scudo "updates available"
CACHE="/tmp/polybar-updates-$USER"

if [ ! -f "$CACHE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -gt 600 ]; then
    apt list --upgradable 2>/dev/null | grep -c "upgradable" > "$CACHE" 2>/dev/null || echo 0 > "$CACHE"
fi

COUNT=$(cat "$CACHE" 2>/dev/null)
[ -z "$COUNT" ] && COUNT=0

if [ "$COUNT" -eq 0 ]; then
    icon=$ICON_OK
    color="#ffffff"
    echo "%{B$TRAYBG}   %{F$color}%{T2}$icon%{T-} %{F-}%{B-}"
else
    icon=$ICON_UPD
    color="#fab387"      # arancione
    echo "%{B$TRAYBG}   %{F$color}%{T2}$icon%{T-} $COUNT %{F-}%{B-}"
fi
