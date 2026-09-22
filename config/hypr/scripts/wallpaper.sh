#!/bin/bash
# Wallpaper manager for Hyprland - Supports static images and animated videos (mpvpaper)

WP_DIR="$HOME/Imágenes/wallpapers"
if [ ! -d "$WP_DIR" ] && [ -d "$HOME/Pictures/wallpapers" ]; then
    WP_DIR="$HOME/Pictures/wallpapers"
elif [ ! -d "$WP_DIR" ]; then
    mkdir -p "$WP_DIR"
fi
CURRENT_FILE="$HOME/.config/hypr/current_wallpaper"
CURRENT_LINK="$HOME/.config/hypr/wallpaper.png"

if [ -n "$1" ] && [ -f "$1" ]; then
    TARGET_WP="$1"
else
    # If no argument, pick random wallpaper (image or video)
    CURRENT_TARGET=$(cat "$CURRENT_FILE" 2>/dev/null)
    TARGET_WP=$(find "$WP_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" -o -name "*.mp4" -o -name "*.webm" \) | grep -v "$CURRENT_TARGET" | shuf -n 1)
    if [ -z "$TARGET_WP" ]; then
        TARGET_WP=$(find "$WP_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" -o -name "*.mp4" -o -name "*.webm" \) | shuf -n 1)
    fi
fi

if [ -n "$TARGET_WP" ] && [ -f "$TARGET_WP" ]; then
    echo "$TARGET_WP" > "$CURRENT_FILE"
    EXTENSION="${TARGET_WP##*.}"
    EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

    if [ "$EXTENSION" = "mp4" ] || [ "$EXTENSION" = "webm" ] || [ "$EXTENSION" = "mkv" ]; then
        # Animated video wallpaper with hardware acceleration and auto-pause
        killall -9 swaybg 2>/dev/null
        killall -9 mpvpaper mpvpaper-holder 2>/dev/null
        sleep 0.1
        nohup mpvpaper -p -o "no-audio loop hwdec=auto" '*' "$TARGET_WP" >/dev/null 2>&1 &
        disown
    else
        # Static image wallpaper
        killall -9 mpvpaper mpvpaper-holder 2>/dev/null
        killall -9 swaybg 2>/dev/null
        sleep 0.1
        ln -sf "$TARGET_WP" "$CURRENT_LINK"
        nohup swaybg -i "$TARGET_WP" -m fill >/dev/null 2>&1 &
        disown
    fi
fi
