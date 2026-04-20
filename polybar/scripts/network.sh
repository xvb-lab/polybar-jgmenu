#!/usr/bin/env bash
# Network states:
#   VERDE   = connesso a internet (ha default route + ping ok)
#   GIALLO  = connesso a rete (IP/gateway) ma no internet (captive portal, DNS down)
#   ROSSO   = disconnesso (no link, no IP)

TRAYBG="#141d28"
LAN_ICON=$'\ueb2f'
WIFI_ICON=$'\ue63e'
CACHE="/tmp/polybar-net-check-$USER"

IFACE=$(ip -4 route show default 2>/dev/null | awk '{print $5; exit}')

# Funzione: determina icona in base all'interfaccia attiva o fisicamente disponibile
get_icon() {
    if [ -n "$IFACE" ]; then
        [ -d "/sys/class/net/$IFACE/wireless" ] && echo "$WIFI_ICON" || echo "$LAN_ICON"
        return
    fi
    for p in /sys/class/net/*/; do
        n=$(basename "$p")
        [ "$n" = "lo" ] && continue
        [ -d "${p}wireless" ] && continue
        [ "$(cat ${p}carrier 2>/dev/null)" = "1" ] && { echo "$LAN_ICON"; return; }
    done
    for p in /sys/class/net/*/; do
        [ -d "${p}wireless" ] || continue
        [ "$(cat ${p}operstate 2>/dev/null)" = "up" ] && { echo "$WIFI_ICON"; return; }
    done
    ls /sys/class/net/*/wireless 2>/dev/null >/dev/null && echo "$WIFI_ICON" || echo "$LAN_ICON"
}

icon=$(get_icon)

if [ -z "$IFACE" ]; then
    # Disconnesso
    color="#e78284"
else
    # Ha default route: controlla internet
    # Cache del check internet per 15 sec (risparmia CPU/rete)
    NEED_CHECK=1
    if [ -f "$CACHE" ]; then
        age=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
        [ "$age" -lt 15 ] && NEED_CHECK=0
    fi

    if [ "$NEED_CHECK" = "1" ]; then
        if ping -c1 -W1 -n 1.1.1.1 >/dev/null 2>&1; then
            echo "ok" > "$CACHE"
        else
            echo "no" > "$CACHE"
        fi
    fi

    if [ "$(cat $CACHE 2>/dev/null)" = "ok" ]; then
        color="#a6d189"   # verde = internet ok
    else
        color="#e5c890"   # giallo = rete ma no internet
    fi
fi

echo "%{B$TRAYBG} %{F$color}%{T2}$icon%{T-} %{F-}%{B-}"
