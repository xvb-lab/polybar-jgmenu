#!/usr/bin/env bash
LOG="$HOME/.cache/jgmenu-recent-apps"
if [ ! -s "$LOG" ]; then
    echo "No recent apps,false,applications-other"
    exit 0
fi

# Inverte il log (ultimi prima), rimuove duplicati mantenendo la prima occorrenza
tac "$LOG" | awk -F'|' '!seen[$2]++ {printf "%s,~/.config/jgmenu/runapp.sh \"%s\" \"%s\" -- %s,%s\n", $2, $2, $3, $4, $3}' | head -10
