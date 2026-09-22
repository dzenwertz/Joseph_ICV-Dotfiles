#!/bin/bash
# ==============================================================================
# RETH Power Menu - Hyprland
# Minimalist power options menu (Apagar, Suspender, Reiniciar) powered by wofi
# ==============================================================================

# Toggle: close if already open
if pgrep -x wofi >/dev/null; then
    killall wofi
    exit 0
fi

OP_SHUTDOWN="  Apagar"
OP_SUSPEND="󰤄  Suspender"
OP_REBOOT="  Reiniciar"

CHOICE=$(printf "%s\n%s\n%s" "$OP_SHUTDOWN" "$OP_SUSPEND" "$OP_REBOOT" | wofi \
    --dmenu \
    --prompt "Sistema" \
    --width 260 \
    --height 200 \
    --lines 3 \
    --location center \
    --hide-scroll \
    --insensitive)

case "$CHOICE" in
    "$OP_SHUTDOWN")
        systemctl poweroff
        ;;
    "$OP_SUSPEND")
        systemctl suspend
        ;;
    "$OP_REBOOT")
        systemctl reboot
        ;;
    *)
        exit 0
        ;;
esac
