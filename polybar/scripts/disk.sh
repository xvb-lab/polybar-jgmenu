#!/usr/bin/env bash
icon=$'\uf80e'
usage=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')
used=$(df -h / | awk 'NR==2 {print $3}')
total=$(df -h / | awk 'NR==2 {print $2}')
if   [ "$usage" -lt 75 ]; then color="#ffffff"
elif [ "$usage" -lt 92 ]; then color="#e5c890"
else                          color="#e78284"
fi
echo "%{B#00468b}   %{F$color}%{T2}$icon%{T-} ${used}/${total} %{F-}   %{B-}"
