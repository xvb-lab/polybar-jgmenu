#!/usr/bin/env bash
#
# ═══════════════════════════════════════════════════════════════════
#  Catppuccin Frappé Setup Script
#  Autore originale: Jona (jonalinux.uk@gmail.com)
#  Target: Linux Mint XFCE (Ubuntu-based) con xfce4-terminal + Bash
#
#  Cosa fa:
#    1. Installa i 4 colorscheme Catppuccin per xfce4-terminal
#       (Latte, Frappé, Macchiato, Mocha) in
#       ~/.local/share/xfce4/terminal/colorschemes/
#    2. Fa il backup di ~/.bashrc in ~/.bashrc.bak-catppuccin-YYYYMMDD
#    3. Rimuove eventuali installazioni precedenti di questo PS1
#    4. Aggiunge in fondo a ~/.bashrc un PS1 multi-line con:
#         - colori Catppuccin Frappé (truecolor)
#         - username@hostname, path, ora
#         - git branch + dirty indicator
#         - exit code del comando precedente (solo se ≠ 0)
#
#  Uso:
#    chmod +x setup-catppuccin-frappe.sh
#    ./setup-catppuccin-frappe.sh
#
#  Poi: in xfce4-terminal → Preferences → Colors → Presets
#  seleziona "Catppuccin Frappé" (o un altro flavor).
#
#  Per disinstallare:
#    ./setup-catppuccin-frappe.sh --uninstall
# ═══════════════════════════════════════════════════════════════════

set -euo pipefail

# ─── Colori per i messaggi dello script ──────────────────────────────
c_info='\033[38;2;140;170;238m'    # blue
c_ok='\033[38;2;166;209;137m'      # green
c_warn='\033[38;2;229;200;144m'    # yellow
c_err='\033[38;2;231;130;132m'     # red
c_reset='\033[0m'

info()  { echo -e "${c_info}[INFO]${c_reset} $*"; }
ok()    { echo -e "${c_ok}[OK]${c_reset}   $*"; }
warn()  { echo -e "${c_warn}[WARN]${c_reset} $*"; }
err()   { echo -e "${c_err}[ERR]${c_reset}  $*" >&2; }

# ─── Marker usati per trovare/rimuovere il blocco in .bashrc ─────────
MARKER_START="# >>> CATPPUCCIN FRAPPE PS1 >>>"
MARKER_END="# <<< CATPPUCCIN FRAPPE PS1 <<<"

BASHRC="$HOME/.bashrc"
COLORSCHEMES_DIR="$HOME/.local/share/xfce4/terminal/colorschemes"
CATPPUCCIN_BASE_URL="https://raw.githubusercontent.com/catppuccin/xfce4-terminal/main/themes"
FLAVORS=(latte frappe macchiato mocha)

# ─── Uninstall ───────────────────────────────────────────────────────
uninstall() {
    info "Rimozione blocco Catppuccin da $BASHRC..."
    if grep -qF "$MARKER_START" "$BASHRC" 2>/dev/null; then
        local backup="$BASHRC.bak-catppuccin-uninstall-$(date +%Y%m%d-%H%M%S)"
        cp "$BASHRC" "$backup"
        ok "Backup creato: $backup"
        # Rimuove tutto ciò che sta tra i marker (inclusi i marker)
        sed -i "/$MARKER_START/,/$MARKER_END/d" "$BASHRC"
        ok "Blocco PS1 Catppuccin rimosso da .bashrc"
    else
        warn "Nessun blocco Catppuccin trovato in .bashrc — niente da rimuovere"
    fi

    info "I file colorscheme in $COLORSCHEMES_DIR NON vengono toccati."
    info "Se vuoi rimuoverli anche quelli:"
    for flavor in "${FLAVORS[@]}"; do
        echo "  rm -f $COLORSCHEMES_DIR/catppuccin-${flavor}.theme"
    done

    ok "Uninstall completato. Ricarica con: source ~/.bashrc"
    exit 0
}

# ─── Gestione argomenti ──────────────────────────────────────────────
if [[ "${1:-}" == "--uninstall" || "${1:-}" == "-u" ]]; then
    uninstall
fi

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    sed -n '3,30p' "$0"
    exit 0
fi

# ─── Check dipendenze ────────────────────────────────────────────────
if ! command -v curl >/dev/null 2>&1; then
    err "curl non è installato. Installa con: sudo apt install curl"
    exit 1
fi

# ─── 1. Installa colorscheme xfce4-terminal ──────────────────────────
info "Creazione directory colorscheme: $COLORSCHEMES_DIR"
mkdir -p "$COLORSCHEMES_DIR"

info "Download colorscheme Catppuccin (tutti e 4 i flavor)..."
for flavor in "${FLAVORS[@]}"; do
    target="$COLORSCHEMES_DIR/catppuccin-${flavor}.theme"
    if curl -fsSL "$CATPPUCCIN_BASE_URL/catppuccin-${flavor}.theme" -o "$target"; then
        ok "  catppuccin-${flavor}.theme"
    else
        err "  Download fallito per catppuccin-${flavor}"
        exit 1
    fi
done

# ─── 2. Backup .bashrc ───────────────────────────────────────────────
if [[ -f "$BASHRC" ]]; then
    backup="$BASHRC.bak-catppuccin-$(date +%Y%m%d-%H%M%S)"
    cp "$BASHRC" "$backup"
    ok "Backup di .bashrc: $backup"
else
    warn ".bashrc non trovato — ne creo uno nuovo"
    touch "$BASHRC"
fi

# ─── 3. Rimuovi eventuali installazioni precedenti ───────────────────
if grep -qF "$MARKER_START" "$BASHRC"; then
    info "Blocco Catppuccin già presente — lo sostituisco"
    sed -i "/$MARKER_START/,/$MARKER_END/d" "$BASHRC"
fi

# ─── 4. Aggiungi il blocco PS1 ───────────────────────────────────────
info "Aggiunta PS1 Catppuccin Frappé a $BASHRC..."

cat >> "$BASHRC" << 'CATPPUCCIN_BLOCK'

# >>> CATPPUCCIN FRAPPE PS1 >>>
# Blocco gestito da setup-catppuccin-frappe.sh — non modificare i marker.
# Per rimuovere: ./setup-catppuccin-frappe.sh --uninstall

# Palette Frappé (truecolor ANSI)
_cf_mauve='\[\e[38;2;202;158;230m\]'
_cf_red='\[\e[38;2;231;130;132m\]'
_cf_peach='\[\e[38;2;239;159;118m\]'
_cf_yellow='\[\e[38;2;229;200;144m\]'
_cf_green='\[\e[38;2;166;209;137m\]'
_cf_teal='\[\e[38;2;129;200;190m\]'
_cf_blue='\[\e[38;2;140;170;238m\]'
_cf_subtext='\[\e[38;2;165;173;206m\]'
_cf_overlay='\[\e[38;2;115;121;148m\]'
_cf_reset='\[\e[0m\]'

# Branch git corrente + indicatore dirty (silent fuori dai repo)
_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null \
          || git describe --tags --exact-match 2>/dev/null)
    if [ -n "$branch" ]; then
        local status=""
        if ! git diff --quiet 2>/dev/null \
           || ! git diff --cached --quiet 2>/dev/null; then
            status=" ●"
        fi
        echo " on ${branch}${status}"
    fi
}

# Exit code ultimo comando (mostrato solo se != 0)
_exit_status() {
    local ec=$?
    if [ $ec -ne 0 ]; then
        echo "✘ $ec "
    fi
}

# Prompt multi-line
PS1="\n${_cf_overlay}╭─ ${_cf_blue}\u${_cf_subtext}@${_cf_teal}\h${_cf_subtext} in ${_cf_yellow}\w${_cf_mauve}\$(_git_branch)${_cf_subtext} at ${_cf_peach}\A\n${_cf_overlay}╰─ ${_cf_red}\$(_exit_status)${_cf_green}❯${_cf_reset} "
export PS1
# <<< CATPPUCCIN FRAPPE PS1 <<<
CATPPUCCIN_BLOCK

ok "PS1 Catppuccin Frappé installato"

# ─── Messaggio finale ────────────────────────────────────────────────
echo
ok "Setup completato!"
echo
info "Prossimi passi:"
echo "  1. Ricarica la shell:          ${c_ok}source ~/.bashrc${c_reset}"
echo "  2. In xfce4-terminal apri:     Preferences → Colors → Presets"
echo "  3. Seleziona:                  Catppuccin Frappé"
echo
info "Se vedi quadratini al posto di ╭ ╰ ❯ ● ✘ installa un Nerd Font"
info "oppure un font con glifi Unicode completi (es. JetBrainsMono, FiraCode)."
echo
info "Per disinstallare il PS1:         ${c_warn}./setup-catppuccin-frappe.sh --uninstall${c_reset}"
