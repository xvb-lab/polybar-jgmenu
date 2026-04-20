#!/usr/bin/env bash
pkill -x polybar 2>/dev/null
while pgrep -x polybar >/dev/null; do sleep 0.2; done

polybar -c ~/.config/polybar/config.ini main >/tmp/polybar.log 2>&1 &
disown

sleep 1
for m in cpu memory temperature trash; do
    polybar-msg action "#${m}.module_hide" >/dev/null 2>&1
done
rm -f "/tmp/polybar-hw-state-$USER"
