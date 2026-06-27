#!/usr/bin/env bash
# ==========================================
# Menú de Escritorio con Rofi - Catppuccin Mocha
# ==========================================

opciones="󰸉 Cambiar Fondo\n Abrir Terminal\n󰉋 Explorador de Archivos\n Editar Configuración de Atajos\n󰐥 Apagar/Reiniciar"

seleccion=$(echo -e "$opciones" | rofi -dmenu -p "󰨇 Escritorio" -config "$HOME/.config/rofi/config.rasi")

case "$seleccion" in
    *Fondo)
        /home/joseph/.local/bin/wallpaper_selector.sh
        ;;
    *Terminal)
        kitty &
        ;;
    *Explorador*)
        dolphin &
        ;;
    *Editar*)
        kitty -e nvim "$HOME/.config/hypr/hyprland.conf" &
        ;;
    *Apagar*)
        /home/joseph/.local/bin/powermenu.sh
        ;;
esac
