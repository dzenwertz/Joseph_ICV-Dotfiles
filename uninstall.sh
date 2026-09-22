#!/usr/bin/env bash
# ==============================================================================
# RETH Dotfiles  ·  Uninstaller & Restore Utility
# ==============================================================================

set -e

echo "Desinstalando RETH Dotfiles..."

LATEST_BACKUP=$(ls -td "$HOME/.config/reth_dotfiles_backup_"* 2>/dev/null | head -n 1)

if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
    echo "Restaurando respaldo previo desde: $LATEST_BACKUP"
    rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/fastfetch" "$HOME/.config/kitty" "$HOME/.config/wofi"
    cp -r "$LATEST_BACKUP/"* "$HOME/.config/"
    echo "Configuraciones anteriores restauradas."
else
    echo "No se encontro respaldo previo. Eliminando configuraciones de RETH..."
    rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/fastfetch" "$HOME/.config/kitty" "$HOME/.config/wofi"
fi

if [ -f "/etc/polkit-1/rules.d/10-udisks2.rules" ]; then
    if [ "$EUID" -ne 0 ]; then
        sudo rm -f "/etc/polkit-1/rules.d/10-udisks2.rules" 2>/dev/null || true
    else
        rm -f "/etc/polkit-1/rules.d/10-udisks2.rules" 2>/dev/null || true
    fi
fi

echo "Listo. RETH Dotfiles ha sido desinstalado."
