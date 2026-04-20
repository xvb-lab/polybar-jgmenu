#!/usr/bin/env bash
icon=$'\ue872'
TRASH="$HOME/.local/share/Trash/files"
if [ -d "$TRASH" ]; then
    count=$(find "$TRASH" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)
    size=$(du -sh "$TRASH" 2>/dev/null | awk '{print $1}')
    [ -z "$size" ] && size="0"
else
    count=0; size="0"
fi
if [ "$count" -eq 0 ]; then
    color="#ffffff"
else
    color="#df8e1d"
fi
echo "%{B#141d28} %{F$color}%{T2}$icon%{T-} ${size} %{F-}   %{B-}"
