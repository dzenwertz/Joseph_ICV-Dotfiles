#!/usr/bin/env bash
# ==========================================
# Script de Instalación de Dotfiles - Catppuccin Mocha
# Diseñado dinámicamente para CachyOS / Arch Linux
# ==========================================

C_RESET="\e[0m"
C_BOLD="\e[1m"
C_BLUE="\e[38;5;111m"
C_GREEN="\e[38;5;120m"
C_YELLOW="\e[38;5;222m"
C_RED="\e[38;5;203m"
C_PURPLE="\e[38;5;176m"

# Obtener directorio actual del script
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

banner() {
    echo -e "${C_PURPLE}${C_BOLD}"
    echo "    ╦ ╦╔═╗╦  ╔═╗╔═╗╔╦╗╔═╗  ╔╦╗╔═╗╔╦╗╔═╗╦╦  ╔═╗╔═╗"
    echo "    ║║║║╣ ║  ║  ║ ║║║║║╣    ║║║ ║ ║ ╠╣ ║║  ║╣ ╚═╗"
    echo "    ╚╩╝╚═╝╩═╝╚═╝╚═╝╩ ╩╚═╝  ═╩╝╚═╝ ╩ ╚  ╩╩═╝╚═╝╚═╝"
    echo -e "   [ Catppuccin Mocha Dotfiles Installer for Joseph ]${C_RESET}"
    echo -e "--------------------------------------------------------"
}

# 1. Instalar paquetes necesarios
instalar_paquetes() {
    echo -e "\n${C_BLUE}[*] Actualizando e instalando paquetes necesarios con pacman...${C_RESET}"
    
    # Paquetes base y CLI
    PAQUETES_BASE=(
        kitty zsh starship tmux neovim
        fzf zoxide eza bat nmap tcpdump
        ttf-jetbrains-mono-nerd git
    )
    
    # Paquetes opcionales para Hyprland
    PAQUETES_HYPR=(
        hyprland waybar rofi-wayland
        swww dunst pavucontrol
    )

    echo -e "${C_YELLOW}[?] ¿Deseas instalar también los paquetes de Hyprland? (Recomendado si quieres probarlo)${C_RESET}"
    read -p "(S/n): " INST_HYPR
    
    SOLO_BASE=true
    if [[ ! "$INST_HYPR" =~ ^[Nn]$ ]]; then
        SOLO_BASE=false
    fi

    # Unir arreglos de paquetes
    PAQUETES=("${PAQUETES_BASE[@]}")
    if [ "$SOLO_BASE" = false ]; then
        PAQUETES+=("${PAQUETES_HYPR[@]}")
    fi

    echo -e "${C_GREEN}[+] Paquetes a instalar:${C_RESET} ${PAQUETES[*]}"
    sudo pacman -S --needed "${PAQUETES[@]}"
}

# 2. Helper para crear enlaces simbólicos de forma segura
linkear_archivo() {
    local origen="$1"
    local destino="$2"

    # Verificar si el archivo/directorio origen existe
    if [ ! -e "$origen" ]; then
        echo -e "${C_RED}[!] Error: El origen $origen no existe. Saltando...${C_RESET}"
        return
    fi

    # Si el destino ya existe
    if [ -e "$destino" ] || [ -L "$destino" ]; then
        # Si es un enlace simbólico que ya apunta a nuestro origen, no hacer nada
        if [ "$(readlink -f "$destino")" = "$origen" ]; then
            echo -e "${C_GREEN}[✔] Ya enlazado:${C_RESET} $destino -> $origen"
            return
        fi
        
        # Crear respaldo
        echo -e "${C_YELLOW}[!] Detectado archivo existente en $destino. Respaldando...${C_RESET}"
        mv "$destino" "${destino}.bak"
    fi

    # Asegurar que el directorio padre del destino existe
    mkdir -p "$(dirname "$destino")"

    # Crear enlace simbólico
    ln -s "$origen" "$destino"
    echo -e "${C_GREEN}[+] Enlazado con éxito:${C_RESET} $destino -> $origen"
}

# 3. Aplicar enlaces de dotfiles
aplicar_enlaces() {
    echo -e "\n${C_BLUE}[*] Creando enlaces simbólicos de dotfiles...${C_RESET}"
    
    # Crear carpetas de configuración si no existen
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"

    # Enlazar configs base
    linkear_archivo "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
    linkear_archivo "$SCRIPT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
    linkear_archivo "$SCRIPT_DIR/kitty" "$HOME/.config/kitty"
    linkear_archivo "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    linkear_archivo "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

    # Enlazar scripts útiles
    chmod +x "$SCRIPT_DIR/bin/cyber_helper.sh"
    linkear_archivo "$SCRIPT_DIR/bin/cyber_helper.sh" "$HOME/.local/bin/cyber_helper.sh"

    # Enlazar configs de Hyprland si el usuario las quiere
    echo -e "\n${C_YELLOW}[?] ¿Deseas aplicar la configuración de Hyprland, Waybar y Rofi?${C_RESET}"
    read -p "(S/n): " LINK_HYPR
    if [[ ! "$LINK_HYPR" =~ ^[Nn]$ ]]; then
        linkear_archivo "$SCRIPT_DIR/hypr" "$HOME/.config/hypr"
        linkear_archivo "$SCRIPT_DIR/waybar" "$HOME/.config/waybar"
        linkear_archivo "$SCRIPT_DIR/rofi" "$HOME/.config/rofi"
    fi
}

# 4. Configurar Zsh como shell por defecto
cambiar_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo -e "\n${C_YELLOW}[?] ¿Deseas cambiar tu shell por defecto a Zsh?${C_RESET}"
        read -p "(S/n): " CAMBIO
        if [[ ! "$CAMBIO" =~ ^[Nn]$ ]]; then
            echo -e "${C_BLUE}[*] Cambiando shell por defecto...${C_RESET}"
            chsh -s "$(which zsh)"
            echo -e "${C_GREEN}[+] Shell cambiada a Zsh. Por favor cierra sesión y vuelve a entrar para aplicar.${C_RESET}"
        fi
    else
        echo -e "\n${C_GREEN}[✔] Zsh ya es tu shell por defecto.${C_RESET}"
    fi
}

# Ejecución principal
clear
banner

echo -e "¿Deseas iniciar la instalación de tus nuevos dotfiles?"
read -p "(S/n): " CONTINUAR
if [[ "$CONTINUAR" =~ ^[Nn]$ ]]; then
    echo -e "\n${C_RED}[!] Instalación cancelada.${C_RESET}"
    exit 0
fi

instalar_paquetes
aplicar_enlaces
cambiar_shell

echo -e "\n${C_PURPLE}${C_BOLD}✨ ¡Instalación completada con éxito! ✨${C_RESET}"
echo -e "  • Para usar tu nueva shell abre otra terminal o ejecuta: ${C_BLUE}zsh${C_RESET}"
echo -e "  • Abre ${C_BLUE}kitty${C_RESET} para ver el diseño visual estilo Catppuccin."
echo -e "  • Abre ${C_BLUE}nvim${C_RESET} para que se descarguen los plugins de editor automáticamente."
echo -e "  • Ejecuta ${C_BLUE}cyberhelp${C_RESET} para iniciar el asistente interactivo."
echo -e "  • Si deseas entrar a Hyprland, cierra sesión y selecciónalo en la pantalla de inicio (SDDM)."
echo -e "\nDisfruta de tu nuevo entorno minimalista. ¡Mucho éxito en tus estudios!"
