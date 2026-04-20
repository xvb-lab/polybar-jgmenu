#!/usr/bin/env bash
# Power button - red Frappé icon on semi-transparent red background
icon=$'\ue8c6'   # power_settings_new
fg="#e78284"     # Frappé red (icon)
bg="#cc7a2d2d"   # Frappé red 80% alpha (background)
echo "%{B$bg}%{F$fg}  %{T2}$icon%{T-}  %{F-}%{B-}"
