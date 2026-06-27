#!/usr/bin/env bash
# ==========================================
# Selector de Fondo con Rofi - Catppuccin Mocha
# ==========================================

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Validar que exista el directorio
if [ ! -d "$WALLPAPER_DIR" ]; then
    mkdir -p "$WALLPAPER_DIR"
fi

# Listar imágenes, agregando la opción "🎲 Aleatorio" al inicio
choice=$( (echo "🎲 Aleatorio"; ls "$WALLPAPER_DIR" | grep -E '\.(jpg|jpeg|png|webp)$') | rofi -dmenu -p "󰸉 Fondo" -config "$HOME/.config/rofi/config.rasi")

if [ -n "$choice" ]; then
    if [ "$choice" = "🎲 Aleatorio" ]; then
        ~/.local/bin/random_wallpaper.sh
    else
        awww img "$WALLPAPER_DIR/$choice" --transition-type outer --transition-pos 0.85,0.97 --transition-step 90
    fi
fi
