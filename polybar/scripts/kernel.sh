#!/usr/bin/env bash
icon=$'\uf720'
distro=$(. /etc/os-release 2>/dev/null; echo "$NAME $VERSION_ID" | xargs)
echo "%{B#a6d189}   %{F#000000}%{T2}$icon%{T-} ${distro}   %{F-}%{B-}"
