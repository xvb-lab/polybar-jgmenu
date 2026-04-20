#!/usr/bin/env bash
ver=$(uname -r | cut -d- -f1)
echo "%{B#e5c890}   %{F#000000}${ver}   %{F-}%{B-}"
