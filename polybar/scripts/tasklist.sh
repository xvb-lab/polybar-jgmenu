#!/usr/bin/env bash
command -v wmctrl >/dev/null || exit 0

COLORS=("#ca9ee6" "#a6d189" "#ef9f76" "#e78284" "#8caaee" "#c6d0f5")
BG="#141d28"

OUT=""
i=0
while IFS= read -r line; do
    wid=$(echo "$line" | awk '{print $1}')
    wmclass=$(echo "$line" | awk '{print $3}')
    appname=$(echo "$wmclass" | awk -F'.' '{print $NF}')
    [ -z "$appname" ] && continue
    [ "$appname" = "Xfdesktop" ] && continue
    [ "$appname" = "N/A" ] && continue

    # Ciclico: 1ª → color[0], 2ª → color[1], ..., 7ª → color[0]
    idx=$((i % ${#COLORS[@]}))
    fg=${COLORS[$idx]}
    i=$((i+1))

    OUT+="%{A1:wmctrl -ia $wid:}%{B$BG}%{F$fg}  $appname  %{F-}%{B-}%{A} "
done < <(wmctrl -lx | grep -v "polybar")

echo "%{O20}${OUT}"
