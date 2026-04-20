#!/usr/bin/env bash
icon=$'\ue8b5'
UP=$(uptime -p 2>/dev/null | sed 's/^up //; s/ years*/y/; s/ months*/M/; s/ weeks*/w/; s/ days*/d/; s/ hours*/h/; s/ minutes*/m/; s/, / /g')
[ -z "$UP" ] && UP="--"
echo "%{B#ffffff}%{F#0076ce}%{T2}$icon%{T-} ${UP}%{F-}   %{B-}"
