#!/usr/bin/env bash
command -v wmctrl >/dev/null || exit 0

COLORS=("#ca9ee6" "#a6d189" "#ef9f76" "#e78284" "#8caaee" "#c6d0f5")

OUT=""
while IFS= read -r line; do
    wid=$(echo "$line" | awk '{print $1}')
    # $3 in -lx è WM_CLASS nel formato "nome.Classe"
    wmclass=$(echo "$line" | awk '{print $3}')
    # Prendi la parte dopo il punto (più user-friendly)
    appname=$(echo "$wmclass" | awk -F'.' '{print $NF}')
    [ -z "$appname" ] && continue
    [ "$appname" = "Xfdesktop" ] && continue
    [ "$appname" = "N/A" ] && continue

    # Colore deterministico
    wid_num=$((16#${wid:2}))
    idx=$((wid_num % ${#COLORS[@]}))
    bg=${COLORS[$idx]}

    OUT+="%{A1:wmctrl -ia $wid:}%{B$bg}%{F#000000}  $appname  %{F-}%{B-}%{A} "
done < <(wmctrl -lx | grep -v "polybar")

echo "%{O20}$OUT"
