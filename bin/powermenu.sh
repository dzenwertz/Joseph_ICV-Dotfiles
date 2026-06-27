#!/usr/bin/env bash
# ==========================================
# Menú de Apagado con Rofi - Catppuccin Mocha
# ==========================================

opciones=" Suspender\n Reiniciar\n⏻ Apagar\n󰗼 Cerrar Sesión"

seleccion=$(echo -e "$opciones" | rofi -dmenu -p "󰐥 Sistema" -config "$HOME/.config/rofi/config.rasi")

case "$seleccion" in
    *Suspender)
        systemctl suspend
        ;;
    *Reiniciar)
        systemctl reboot
        ;;
    *Apagar)
        systemctl poweroff
        ;;
    *Cerrar*)
        hyprctl dispatch exit
        ;;
esac
