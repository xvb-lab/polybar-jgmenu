#!/usr/bin/env bash
# Power manager icon (for vassoio)
icon=$'\uf102'   # bolt / lightning (U+E1A7) — se non ti piace cambiamo codepoint
TRAYBG="#141d28"
TRAYFG="#ffffff"
echo "%{B$TRAYBG} %{F$TRAYFG}%{T2}$icon%{T-} %{F-}%{B-}"
