#!/bin/bash
# Interactive wallpaper selector using wofi - Supports static and animated wallpapers

WP_DIR="$HOME/Imágenes/wallpapers"
if [ ! -d "$WP_DIR" ] && [ -d "$HOME/Pictures/wallpapers" ]; then
    WP_DIR="$HOME/Pictures/wallpapers"
elif [ ! -d "$WP_DIR" ]; then
    mkdir -p "$WP_DIR"
fi

CHOICE=$(find "$WP_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" -o -name "*.mp4" -o -name "*.webm" \) -printf "%f\n" | sort | wofi --dmenu --prompt "Seleccionar fondo:")

if [ -n "$CHOICE" ] && [ -f "$WP_DIR/$CHOICE" ]; then
    "$HOME/.config/hypr/scripts/wallpaper.sh" "$WP_DIR/$CHOICE"
fi
