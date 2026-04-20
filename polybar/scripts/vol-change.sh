#!/usr/bin/env bash
# Fast volume change with stamp touch (for hover effect)
pactl set-sink-volume @DEFAULT_SINK@ "$1" &
touch "/tmp/polybar-vol-stamp-$USER" &
exec polybar-msg action "#volume.hook.0" >/dev/null 2>&1 &
