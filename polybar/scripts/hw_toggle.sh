#!/usr/bin/env bash
STATE="/tmp/polybar-hw-state-$USER"

if [ "$1" = "click" ]; then
    for m in cpu memory temperature trash; do
        polybar-msg action "#${m}.module_toggle" >/dev/null 2>&1
    done
    if [ -f "$STATE" ]; then rm -f "$STATE"; else touch "$STATE"; fi
    exit 0
fi

if [ "$1" = "show" ]; then
    if [ ! -f "$STATE" ]; then
        for m in cpu memory temperature trash; do
            polybar-msg action "#${m}.module_show" >/dev/null 2>&1
        done
        touch "$STATE"
    fi
    exit 0
fi

if [ -f "$STATE" ]; then
    icon=$'\ue5cc'
else
    icon=$'\ue5cb'
fi
echo "%{B#ffffff}%{F#0076ce} %{T2}$icon%{T-} %{F-}%{B-}"
