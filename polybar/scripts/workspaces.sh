#!/usr/bin/env bash
if [ "$1" = "switch" ]; then
    wmctrl -s "$2"
    exit 0
fi

CURRENT=$(wmctrl -d 2>/dev/null | awk '/\*/ {print $1}')
TOTAL=$(wmctrl -d 2>/dev/null | wc -l)
[ -z "$CURRENT" ] && CURRENT=0
[ -z "$TOTAL" ] && TOTAL=4

OUT=""
for i in $(seq 0 $((TOTAL-1))); do
    n=$((i+1))
    if [ "$i" = "$CURRENT" ]; then
        OUT+="%{A1:$HOME/.config/polybar/scripts/workspaces.sh switch $i:}%{F#ffffff}%{T3}$n%{T-}%{F-}%{A}  "
    else
        OUT+="%{A1:$HOME/.config/polybar/scripts/workspaces.sh switch $i:}%{F#737994}$n%{F-}%{A}  "
    fi
done

echo "${OUT}%{O20}"
