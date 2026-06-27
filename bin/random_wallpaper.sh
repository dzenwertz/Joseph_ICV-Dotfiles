#!/usr/bin/env bash
# ==========================================
# Seleccionar un Fondo Aleatorio - Catppuccin Mocha
# ==========================================

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    exit 1
fi

random_wall=$(ls "$WALLPAPER_DIR" | grep -E '\.(jpg|jpeg|png|webp)$' | shuf -n 1)
if [ -n "$random_wall" ]; then
    awww img "$WALLPAPER_DIR/$random_wall" --transition-type outer --transition-pos 0.85,0.97 --transition-step 90
fi
