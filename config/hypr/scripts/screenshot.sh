#!/bin/bash
# Screenshot script with grim and slurp

DIR="$HOME/Imágenes/Capturas"
mkdir -p "$DIR"
FILE="$DIR/captura_$(date +'%Y-%m-%d_%H-%M-%S').png"

case "$1" in
    "area")
        GEOM=$(slurp)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" "$FILE"
            if command -v wl-copy >/dev/null 2>&1; then
                wl-copy -t image/png < "$FILE"
            fi
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Captura realizada" "Guardada en $FILE" -i "$FILE"
            fi
        fi
        ;;
    "window")
        GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" "$FILE"
            if command -v wl-copy >/dev/null 2>&1; then
                wl-copy -t image/png < "$FILE"
            fi
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Captura de ventana" "Guardada en $FILE" -i "$FILE"
            fi
        fi
        ;;
    *)
        grim "$FILE"
        if command -v wl-copy >/dev/null 2>&1; then
            wl-copy -t image/png < "$FILE"
        fi
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Captura de pantalla completa" "Guardada en $FILE" -i "$FILE"
        fi
        ;;
esac
