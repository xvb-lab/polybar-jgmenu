#!/usr/bin/env bash
TRAYBG="#141d28"
TRAYFG="#ffffff"
DT=$(date '+%a %d - %H:%M')
echo "%{B$TRAYBG}%{F$TRAYFG}%{T3}${DT}%{T-}   %{F-}%{B-}"
