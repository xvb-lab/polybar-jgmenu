#!/usr/bin/env bash
command -v wmctrl >/dev/null || exit 0

COLORS=("#ca9ee6" "#a6d189" "#ef9f76" "#e78284" "#8caaee" "#c6d0f5")
BG="#141d28"

OUT=""
i=0
# Usiamo wmctrl -l per il titolo, e -lx per la classe in parallelo
while IFS= read -r line; do
    wid=$(echo "$line" | awk '{print $1}')
    title=$(echo "$line" | awk '{for(i=4;i<=NF;i++) printf "%s ", $i}' | sed 's/ *$//')
    
    # Skip Desktop e vuoti
    [ -z "$title" ] && continue
    [ "$title" = "Desktop" ] && continue
    
    # Prendi solo prima parola del titolo (quella prima del " - " o spazio lungo)
    # Es: "Installazione fresca Linux Mint 23.4 XFCE - Claude — Mozilla Firefox" → "Mozilla Firefox"
    # Logica: se contiene " — " o " - ", prendi l'ultima parte (di solito è il nome dell'app)
    if echo "$title" | grep -q " — "; then
        appname=$(echo "$title" | awk -F' — ' '{print $NF}')
    elif echo "$title" | grep -q " - "; then
        appname=$(echo "$title" | awk -F' - ' '{print $NF}')
    else
        appname="$title"
    fi
    
    # Tronca se troppo lungo
    appname=$(echo "$appname" | cut -c 1-25 | sed 's/ *$//')
    
    idx=$((i % ${#COLORS[@]}))
    fg=${COLORS[$idx]}
    i=$((i+1))
    
    OUT+="%{A1:wmctrl -ia $wid:}%{B$BG}%{F$fg}  $appname  %{F-}%{B-}%{A} "
done < <(wmctrl -l | grep -v "polybar")

echo "%{O20}${OUT}"
