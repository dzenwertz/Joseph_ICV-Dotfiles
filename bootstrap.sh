#!/usr/bin/env bash
# ========================================================
# Script Bootstrap para Dotfiles de Joseph
# Permite la instalación con un solo comando vía curl/wget
# ========================================================

REPO_URL="https://github.com/dzenwertz/Joseph_ICV-Dotfiles.git"
TARGET_DIR="$HOME/.dotfiles"

C_RESET="\e[0m"
C_BOLD="\e[1m"
C_BLUE="\e[38;5;111m"
C_GREEN="\e[38;5;120m"
C_RED="\e[38;5;203m"

echo -e "${C_BLUE}${C_BOLD}[*] Preparando instalación de Dotfiles...${C_RESET}"

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${C_RED}[!] Error: git no está instalado. Instálalo primero con pacman/yay.${C_RESET}"
    exit 1
fi

# Clonar o actualizar el repositorio
if [ -d "$TARGET_DIR" ]; then
    echo -e "${C_BLUE}[*] El directorio $TARGET_DIR ya existe. Actualizando repositorio...${C_RESET}"
    cd "$TARGET_DIR" || exit 1
    git pull
else
    echo -e "${C_BLUE}[*] Clonando dotfiles en $TARGET_DIR...${C_RESET}"
    git clone "$REPO_URL" "$TARGET_DIR"
fi

# Ejecutar el instalador
if [ -f "$TARGET_DIR/install.sh" ]; then
    echo -e "${C_GREEN}[+] Repositorio listo. Iniciando instalador...${C_RESET}"
    cd "$TARGET_DIR" || exit 1
    chmod +x install.sh
    ./install.sh
else
    echo -e "${C_RED}[!] Error: No se encontró install.sh en el repositorio clonado.${C_RESET}"
    exit 1
fi
