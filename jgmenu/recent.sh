#!/usr/bin/env bash
# Genera lista dei 15 file recenti in formato jgmenu CSV
XBEL="$HOME/.local/share/recently-used.xbel"
[ ! -f "$XBEL" ] && { echo "No recent files,false,document"; exit 0; }

# Estrae href + modified, ordina per data decrescente, prende i primi 15
grep -oE 'href="[^"]*"[[:space:]]+added="[^"]*"[[:space:]]+modified="[^"]*"' "$XBEL" \
    | awk -F'"' '{print $6"|"$2}' \
    | sort -r \
    | head -15 \
    | while IFS='|' read -r date url; do
        # Decodifica URL (file:// -> percorso)
        file=$(echo "$url" | sed 's|^file://||' | python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))" 2>/dev/null)
        [ -z "$file" ] && continue
        [ ! -e "$file" ] && continue
        name=$(basename "$file")
        # Formato CSV: Nome,comando,icona
        echo "${name},xdg-open \"$file\",text-x-generic"
    done
