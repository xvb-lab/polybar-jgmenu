#!/usr/bin/env bash
icon=$'\ue312'   # keyboard
color="#ffffff"

LAYOUT=$(setxkbmap -query 2>/dev/null | awk '/^layout:/ {print toupper($2); exit}')
[ -z "$LAYOUT" ] && LAYOUT="??"

echo "%{F$color}%{T2}$icon%{T-} ${LAYOUT}%{F-}"
