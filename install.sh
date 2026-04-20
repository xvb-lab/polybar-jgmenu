#!/usr/bin/env bash
# =========================================================
#  Polybar Dell rice — install script
#  For Linux Mint XFCE / Debian-based systems
# =========================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==========================================================="
echo "  Polybar Dell rice installer"
echo "  From: $REPO_DIR"
echo "==========================================================="

# ---------------------------------------------------------
# 1. Check we're in the right directory
# ---------------------------------------------------------
if [ ! -d "$REPO_DIR/polybar" ] || [ ! -d "$REPO_DIR/jgmenu" ]; then
    echo "❌ Error: polybar/ and jgmenu/ folders not found in $REPO_DIR"
    echo "   Run this script from the repo root."
    exit 1
fi

if [ ! -f "$REPO_DIR/polybar/assets/dell.svg" ]; then
    echo "❌ Error: polybar/assets/dell.svg not found"
    exit 1
fi

# ---------------------------------------------------------
# 2. Install apt packages
# ---------------------------------------------------------
echo ""
echo "==> Installing system packages..."
sudo apt update
sudo apt install -y \
    polybar \
    jgmenu \
    fontforge \
    python3-fontforge \
    sqlite3 \
    wmctrl \
    xdotool \
    curl \
    network-manager-gnome \
    xfce4-power-manager \
    blueman \
    lm-sensors \
    fonts-roboto \
    gnome-calendar \
    papirus-icon-theme

# ---------------------------------------------------------
# 3. Install Material Symbols Outlined font
# ---------------------------------------------------------
echo ""
echo "==> Installing Material Symbols Outlined font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/MaterialSymbolsOutlined.ttf" ]; then
    curl -fsSL -o "$FONT_DIR/MaterialSymbolsOutlined.ttf" \
        "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf"
fi

SIZE=$(stat -c %s "$FONT_DIR/MaterialSymbolsOutlined.ttf" 2>/dev/null || echo 0)
if [ "$SIZE" -lt 1000000 ]; then
    echo "⚠  Material Symbols font download seems incomplete (size: $SIZE bytes)"
else
    echo "  ✓ Material Symbols installed ($((SIZE/1024/1024))MB)"
fi

# ---------------------------------------------------------
# 4. Generate Dell Logo font from SVG via FontForge
# ---------------------------------------------------------
echo ""
echo "==> Generating Dell Logo font from SVG..."
fontforge -script - << PY_EOF
import fontforge, psMat, os
svg = "$REPO_DIR/polybar/assets/dell.svg"
out = os.environ['HOME'] + "/.local/share/fonts/DellLogo.ttf"

font = fontforge.font()
font.fontname   = "DellLogo"
font.familyname = "Dell Logo"
font.fullname   = "Dell Logo"
font.em         = 1024
font.ascent     = 819
font.descent    = 205

g = font.createChar(0xE900, "dell")
g.importOutlines(svg)

bb = g.boundingBox()
h = bb[3] - bb[1]
if h > 0:
    g.transform(psMat.scale(800.0 / h))
bb = g.boundingBox()
g.transform(psMat.translate(-bb[0], -bb[1]))
bb = g.boundingBox()
g.width = int(bb[2] + 100)

font.generate(out)
print("  ✓ Dell Logo font generated")
PY_EOF

# ---------------------------------------------------------
# 5. (Optional) Google Sans - user must install manually
# ---------------------------------------------------------
echo ""
if fc-list | grep -qi "google sans"; then
    echo "==> Google Sans: already installed ✓"
else
    echo "⚠  Google Sans not found in system fonts."
    echo "   The config uses Google Sans as UI font. You have two options:"
    echo ""
    echo "   A) Install Google Sans manually:"
    echo "      Download TTF files and place them in $FONT_DIR"
    echo "      (e.g. from https://github.com/mobiledesres/Google-Sans-web-fonts)"
    echo ""
    echo "   B) Fall back to Ubuntu font (automatic)."
    echo ""
    read -p "   Fall back to Ubuntu font now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        FALLBACK_FONT=1
    fi
fi

# ---------------------------------------------------------
# 6. Refresh font cache
# ---------------------------------------------------------
fc-cache -f "$FONT_DIR"
echo "  ✓ Font cache refreshed"

# ---------------------------------------------------------
# 7. Copy polybar config + scripts
# ---------------------------------------------------------
echo ""
echo "==> Installing polybar config..."
mkdir -p "$HOME/.config/polybar/scripts" "$HOME/.config/polybar/assets"

cp "$REPO_DIR/polybar/config.ini"   "$HOME/.config/polybar/config.ini"
cp "$REPO_DIR/polybar/launch.sh"    "$HOME/.config/polybar/launch.sh"
cp "$REPO_DIR/polybar/assets/"*     "$HOME/.config/polybar/assets/"
cp "$REPO_DIR/polybar/scripts/"*    "$HOME/.config/polybar/scripts/"

chmod +x "$HOME/.config/polybar/launch.sh"
chmod +x "$HOME/.config/polybar/scripts/"*.sh

# Apply fallback font if chosen
if [ -n "$FALLBACK_FONT" ]; then
    sed -i 's|Google Sans:size=9|Ubuntu:size=9|; s|Google Sans:weight=bold:size=10|Ubuntu:weight=bold:size=10|' \
        "$HOME/.config/polybar/config.ini"
    echo "  ✓ Fallback to Ubuntu font applied"
fi

echo "  ✓ Polybar installed at ~/.config/polybar/"

# ---------------------------------------------------------
# 8. Copy jgmenu config + scripts
# ---------------------------------------------------------
echo ""
echo "==> Installing jgmenu config..."
mkdir -p "$HOME/.config/jgmenu"

cp "$REPO_DIR/jgmenu/jgmenurc"        "$HOME/.config/jgmenu/jgmenurc"
cp "$REPO_DIR/jgmenu/menu.sh"         "$HOME/.config/jgmenu/menu.sh"
cp "$REPO_DIR/jgmenu/recent-apps.sh"  "$HOME/.config/jgmenu/recent-apps.sh"
cp "$REPO_DIR/jgmenu/runapp.sh"       "$HOME/.config/jgmenu/runapp.sh"
cp "$REPO_DIR/jgmenu/wrap-apps.py"    "$HOME/.config/jgmenu/wrap-apps.py"

chmod +x "$HOME/.config/jgmenu/"*.sh "$HOME/.config/jgmenu/"*.py

echo "  ✓ jgmenu installed at ~/.config/jgmenu/"

# ---------------------------------------------------------
# 9. Autostart polybar + disable xfce4-panel
# ---------------------------------------------------------
echo ""
echo "==> Setting up autostart..."
mkdir -p "$HOME/.config/autostart"

cat > "$HOME/.config/autostart/polybar.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Polybar
Exec=/bin/bash -lc "sleep 1 && ~/.config/polybar/launch.sh"
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

cat > "$HOME/.config/autostart/xfce4-panel.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=xfce4-panel
Exec=true
Hidden=true
NoDisplay=true
X-GNOME-Autostart-enabled=false
EOF

echo "  ✓ Polybar added to autostart"
echo "  ✓ xfce4-panel autostart disabled"

# ---------------------------------------------------------
# 10. Setup xfce4-notifyd for polybar notification toggle
# ---------------------------------------------------------
echo ""
echo "==> Enabling notification log..."
xfconf-query -c xfce4-notifyd -p /notification-log -s true 2>/dev/null \
    || xfconf-query -c xfce4-notifyd -p /notification-log -n -t bool -s true
echo "  ✓ Notification logging enabled"

# ---------------------------------------------------------
# 11. Optional: set solid desktop background
# ---------------------------------------------------------
echo ""
read -p "Set desktop background to solid #1d2c3b? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    MONITOR=$(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep -oP 'monitor\w+/workspace\d+' | head -1 | cut -d/ -f1)
    if [ -n "$MONITOR" ]; then
        for ws in 0 1 2 3; do
            BASE="/backdrop/screen0/${MONITOR}/workspace${ws}"
            xfconf-query -c xfce4-desktop -p "${BASE}/image-style" -s 0 2>/dev/null || true
            xfconf-query -c xfce4-desktop -p "${BASE}/color-style" -s 0 2>/dev/null || true
            xfconf-query -c xfce4-desktop -p "${BASE}/last-image"  -s "" 2>/dev/null || true
            xfconf-query -c xfce4-desktop -p "${BASE}/rgba1" -n \
                -t double -t double -t double -t double \
                -s 0.114 -s 0.172 -s 0.231 -s 1.0 2>/dev/null || true
        done
        xfdesktop --reload 2>/dev/null || true
        echo "  ✓ Desktop background set"
    else
        echo "  ⚠  Could not detect monitor, skip background"
    fi
fi

# ---------------------------------------------------------
# 12. Kill existing panels and launch polybar
# ---------------------------------------------------------
echo ""
echo "==> Killing old panels..."
xfce4-panel --quit 2>/dev/null || true
pkill -9 plank 2>/dev/null || true
rm -rf "$HOME/.config/xfce4/panel" 2>/dev/null || true

echo "==> Launching polybar..."
~/.config/polybar/launch.sh

# ---------------------------------------------------------
# DONE
# ---------------------------------------------------------
cat << 'DONE'

===========================================================
✓ Installation complete!
===========================================================

Notes:
  • If you don't see Google Sans, fall back to Ubuntu font
    or install manually: https://fonts.google.com
  • jgmenu is invoked by clicking the Dell logo
  • Click the › / ‹ arrow to toggle hardware panel
  • Click the 🔌 power icon (right edge) for logout

Logs:
  polybar:  tail -f /tmp/polybar.log
  jgmenu:   run 'jgmenu' in terminal to see errors

Uninstall:
  pkill polybar
  rm -rf ~/.config/polybar ~/.config/jgmenu
  rm ~/.config/autostart/polybar.desktop

Enjoy your Dell rice! 🚀

DONE
