#!/usr/bin/env bash

cat << 'FAV'
Firefox,firefox,firefox
Terminal,xfce4-terminal,utilities-terminal
Files,thunar,folder
^sep()
Recent Apps,^checkout(recentapps),document-open-recent
All Applications,^checkout(xdgmenu),applications-other
^sep()
Settings,xfce4-settings-manager,preferences-desktop
Lock Screen,xflock4,system-lock-screen
Log Out,xfce4-session-logout,system-log-out
FAV

echo "^tag(recentapps)"
~/.config/jgmenu/recent-apps.sh

echo "^tag(xdgmenu)"
~/.config/jgmenu/wrap-apps.py
