#!/usr/bin/env bash
# ==============================================================================
# RETH Dotfiles  ·  Universal Linux Installer
# Author: Joseph ICV (dzenwertz) <dzenwertz05@gmail.com> / RETH Labs
# Supports: Arch Linux, EndeavourOS, Manjaro
# ==============================================================================

set -e

REPO_URL="https://github.com/dzenwertz/Joseph_ICV-Dotfiles.git"
RAW_URL="https://raw.githubusercontent.com/dzenwertz/Joseph_ICV-Dotfiles/main"

echo "------------------------------------------------------------------------------"
echo "RETH Dotfiles  ·  Arch Linux + Hyprland Minimalist Setup"
echo "https://github.com/dzenwertz/Joseph_ICV-Dotfiles"
echo "------------------------------------------------------------------------------"

if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

# Detect package managers
if ! command -v pacman >/dev/null 2>&1; then
    echo "Error: Este instalador esta optimizado para Arch Linux y distribuciones basadas en Arch."
    exit 1
fi

AUR_HELPER=""
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
fi

# [1/5] Prepare source files if running via curl
TEMP_DIR=""
if [ ! -d "./config" ]; then
    echo "[1/5] Descargando archivos de RETH Dotfiles..."
    TEMP_DIR=$(mktemp -d)
    git clone --depth=1 "$REPO_URL" "$TEMP_DIR"
    cd "$TEMP_DIR"
else
    echo "[1/5] Archivos locales detectados."
fi

# [2/5] System Dependencies
echo "[2/5] Instalando paquetes y dependencias del sistema..."
PACMAN_PKGS=(
    hyprland
    waybar
    wofi
    kitty
    fastfetch
    swaybg
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    imagemagick
    jq
    libnotify
    ttf-font-awesome
    noto-fonts
    noto-fonts-emoji
)

$SUDO pacman -Sy --needed --noconfirm "${PACMAN_PKGS[@]}" 2>/dev/null || true

# AUR dependencies
if [ -n "$AUR_HELPER" ]; then
    echo "Instalando paquetes desde AUR ($AUR_HELPER)..."
    $AUR_HELPER -S --needed --noconfirm mpvpaper ttf-jetbrains-mono-nerd 2>/dev/null || true
else
    echo "Aviso: No se detecto yay o paru. Asegurate de instalar mpvpaper y ttf-jetbrains-mono-nerd manualmente."
fi

# [3/5] Backup existing configurations
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.config/reth_dotfiles_backup_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"
echo "[3/5] Creando respaldo de configuraciones existentes en $BACKUP_DIR..."

for cfg in hypr waybar fastfetch kitty wofi; do
    if [ -d "$HOME/.config/$cfg" ] || [ -f "$HOME/.config/$cfg" ]; then
        mv "$HOME/.config/$cfg" "$BACKUP_DIR/"
    fi
done

# [4/5] Deploy Dotfiles
echo "[4/5] Desplegando configuraciones de RETH..."
mkdir -p "$HOME/.config"

cp -r config/hypr "$HOME/.config/"
cp -r config/waybar "$HOME/.config/"
cp -r config/fastfetch "$HOME/.config/"
cp -r config/kitty "$HOME/.config/"
cp -r config/wofi "$HOME/.config/"

chmod +x "$HOME/.config/hypr/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/waybar/launch.sh" 2>/dev/null || true

# Setup Wallpapers Directory
WP_DIR="$HOME/Imágenes/wallpapers"
if [ ! -d "$WP_DIR" ] && [ -d "$HOME/Pictures" ]; then
    WP_DIR="$HOME/Pictures/wallpapers"
fi
mkdir -p "$WP_DIR"

if [ -d "./wallpapers" ]; then
    cp -r ./wallpapers/* "$WP_DIR/" 2>/dev/null || true
fi

# Setup default wallpaper link
if [ -f "$WP_DIR/default.jpg" ]; then
    ln -sf "$WP_DIR/default.jpg" "$HOME/.config/hypr/wallpaper.png"
    echo "$WP_DIR/default.jpg" > "$HOME/.config/hypr/current_wallpaper"
fi

# Bashrc Fastfetch Integration
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "fastfetch" "$HOME/.bashrc"; then
        echo -e "\n# Auto-launch fastfetch on terminal open\nalias neofetch='fastfetch'\nfastfetch" >> "$HOME/.bashrc"
    fi
fi

# [5/5] Optional Polkit rule for BitLocker / NTFS disk mounting
echo "[5/5] Configurando politicas de sistema..."
if [ -f "./system/etc/polkit-1/rules.d/10-udisks2.rules" ]; then
    $SUDO mkdir -p /etc/polkit-1/rules.d
    $SUDO cp ./system/etc/polkit-1/rules.d/10-udisks2.rules /etc/polkit-1/rules.d/10-udisks2.rules
    $SUDO chmod 644 /etc/polkit-1/rules.d/10-udisks2.rules
fi

# Clean temp directory if created
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo "------------------------------------------------------------------------------"
echo "Instalacion completada exitosamente."
echo "Configuraciones respaldadas en: $BACKUP_DIR"
echo "Reinicia tu sesion de Hyprland o recarga con Super + M para disfrutar de RETH Dotfiles."
echo "------------------------------------------------------------------------------"
