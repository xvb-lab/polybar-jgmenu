#!/usr/bin/env bash
# Traccia l'uso + lancia l'app
# Usage: runapp.sh <nome> <icona> -- <comando e args...>
NAME="$1"; ICON="$2"; shift 2
[ "$1" = "--" ] && shift

LOG="$HOME/.cache/jgmenu-recent-apps"
echo "$(date +%s)|$NAME|$ICON|$*" >> "$LOG"

# Esegue tramite shell per gestire comandi con argomenti/pipe
setsid bash -c "$*" >/dev/null 2>&1 &
disown
