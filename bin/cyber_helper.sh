#!/usr/bin/env bash
# ==========================================
# Asistente de Ciberseguridad, Redes y Universidad
# Creado para Joseph - CachyOS / KDE Plasma
# ==========================================

# Definir colores para una interfaz hermosa y moderna
C_RESET="\e[0m"
C_BOLD="\e[1m"
C_BLUE="\e[38;5;111m"
C_GREEN="\e[38;5;120m"
C_YELLOW="\e[38;5;222m"
C_RED="\e[38;5;203m"
C_PURPLE="\e[38;5;176m"
C_CYAN="\e[38;5;121m"

# Carpeta por defecto para los apuntes de la universidad
DIR_UNIVERSIDAD="$HOME/Universidad"

# Función para limpiar pantalla e imprimir encabezado
mostrar_banner() {
    clear
    echo -e "${C_PURPLE}${C_BOLD}"
    echo "  ██████╗██╗   ██╗██████╗ ███████╗██████╗ "
    echo " ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗"
    echo " ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝"
    echo " ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗"
    echo " ╚██████╗   ██║   ██████╔╝███████╗██║  ██║"
    echo "  ╚══════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝"
    echo -e "   [ CachyOS Terminal Assistant - Catppuccin ]${C_RESET}"
    echo -e "--------------------------------------------------------"
}

# ==========================================
# SECCIÓN: UNIVERSIDAD Y APUNTES
# ==========================================
gestionar_apuntes() {
    mostrar_banner
    echo -e "${C_BLUE}${C_BOLD}📝 UTILERÍA DE APUNTES UNIVERSITARIOS${C_RESET}\n"

    # Asegurar que existe el directorio base
    mkdir -p "$DIR_UNIVERSIDAD"

    echo -e "Ingresa la materia o curso (ej: Redes, Ciberseguridad, Programacion, Calculo):"
    read -p "❯ " MATERIA
    if [ -z "$MATERIA" ]; then
        echo -e "${C_RED}[!] La materia no puede estar vacía.${C_RESET}"
        sleep 1.5
        return
    fi

    # Formatear nombre de carpeta
    MATERIA_DIR="$DIR_UNIVERSIDAD/${MATERIA// /_}"
    mkdir -p "$MATERIA_DIR"

    echo -e "\nIngresa el título del apunte:"
    read -p "❯ " TITULO
    if [ -z "$TITULO" ]; then
        echo -e "${C_RED}[!] El título no puede estar vacío.${C_RESET}"
        sleep 1.5
        return
    fi

    # Crear nombre de archivo con fecha
    FECHA=$(date +"%Y-%m-%d")
    TITULO_LIMPIO="${TITULO// /_}"
    FILE_PATH="$MATERIA_DIR/${FECHA}_${TITULO_LIMPIO}.md"

    # Si no existe, crear con plantilla elegante en Markdown
    if [ ! -f "$FILE_PATH" ]; then
        cat <<EOF > "$FILE_PATH"
---
title: ${TITULO}
date: ${FECHA}
course: ${MATERIA}
type: note
---

# ${TITULO}

**Curso:** ${MATERIA}
**Fecha:** $(date +"%A, %d de %B de %Y")

---

## 📌 Conceptos Clave

- 

## ✍️ Notas de Clase



## 🔍 Enlaces & Recursos

- 
EOF
    fi

    echo -e "\n${C_GREEN}[+] Creando nota en: $FILE_PATH...${C_RESET}"
    echo -e "${C_GREEN}[+] Abriendo en Neovim...${C_RESET}"
    sleep 1
    nvim "$FILE_PATH"
}

# ==========================================
# SECCIÓN: ESCANEO DE RED LOCAL
# ==========================================
escanear_red() {
    mostrar_banner
    echo -e "${C_CYAN}${C_BOLD}🔍 ESCANER DE RED LOCAL (Ping Sweep)${C_RESET}\n"

    # Obtener interfaz por defecto y su IP/Subred
    INTERFAZ=$(ip route | grep default | awk '{print $5}' | head -n1)
    
    if [ -z "$INTERFAZ" ]; then
        echo -e "${C_RED}[!] No se detectó ninguna interfaz activa conectada a Internet.${C_RESET}"
        # Fallback a buscar cualquier ip local
        INTERFAZ=$(ip -4 addr | grep -v "127.0.0.1" | awk '{print $7}' | head -n1)
    fi

    RANGO=$(ip -o -f inet addr show dev "$INTERFAZ" | awk '{print $4}' | head -n1)

    if [ -z "$RANGO" ]; then
        echo -e "${C_RED}[!] No se pudo determinar el rango IP automáticamente.${C_RESET}"
        read -p "Ingresa el rango IP manualmente (ej: 192.168.1.0/24): " RANGO
    else
        echo -e "${C_GREEN}[+] Interfaz activa:${C_RESET} $INTERFAZ"
        echo -e "${C_GREEN}[+] Subred auto-detectada:${C_RESET} $RANGO"
        echo ""
    fi

    echo -e "¿Deseas iniciar un escaneo de dispositivos activos en $RANGO?"
    read -p "(S/n): " ACCION
    if [[ "$ACCION" =~ ^[Nn]$ ]]; then
        return
    fi

    echo -e "\n${C_YELLOW}[*] Buscando hosts encendidos con Nmap (Ping Scan)...${C_RESET}"
    if command -v nmap &> /dev/null; then
        sudo nmap -sn "$RANGO"
    else
        # Fallback si no está nmap
        echo -e "${C_RED}[!] Nmap no está instalado. Usando fallback lento con ping...${C_RESET}"
        SUBNET=$(echo "$RANGO" | cut -d'.' -f1-3)
        for i in {1..254}; do
            ping -c 1 -W 1 "$SUBNET.$i" | grep "bytes from" | awk '{print $4}' | tr -d ':' &
        done
        wait
    fi

    echo -e "\n${C_GREEN}[+] Escaneo finalizado. Presiona Enter para volver.${C_RESET}"
    read
}

# ==========================================
# SECCIÓN: AUDITORÍA DE PUERTOS
# ==========================================
auditar_puertos() {
    mostrar_banner
    echo -e "${C_YELLOW}${C_BOLD}🛡️ PUERTOS ABIERTOS Y SERVICIOS LOCALES${C_RESET}\n"
    echo -e "Esta lista muestra los servicios de tu computadora que aceptan conexiones de red."
    echo -e "En ciberseguridad, un puerto abierto innecesario es una vulnerabilidad potencial.\n"

    # Mostrar puertos locales escuchando
    if command -v ss &> /dev/null; then
        echo -e "${C_BOLD}Puerto   Protocolo   Servicio/Proceso${C_RESET}"
        echo -e "----------------------------------------"
        sudo ss -tulnp | awk 'NR>1 {print $5, $1, $7}' | sed 's/\*/any/g' | column -t
    else
        sudo netstat -tulanp
    fi

    echo -e "\n${C_GREEN}[+] Presiona Enter para volver.${C_RESET}"
    read
}

# ==========================================
# SECCIÓN: LEVANTAR SERVIDOR WEB RÁPIDO
# ==========================================
iniciar_servidor() {
    mostrar_banner
    echo -e "${C_GREEN}${C_BOLD}🌐 SERVIDOR WEB TEMPORAL (HTTP)${C_RESET}\n"
    echo -e "Ideal para transferir archivos rápidamente entre tu máquina y otra"
    echo -e "(por ejemplo, una máquina virtual de hacking o tu teléfono).\n"

    IP_LOCAL=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
    [ -z "$IP_LOCAL" ] && IP_LOCAL=$(hostname -I | awk '{print $1}')

    read -p "Ingresa el puerto en el que deseas levantar el servidor [8080]: " PUERTO
    PUERTO=${PUERTO:-8080}

    echo -e "\n${C_GREEN}[+] Servidor levantado en tu máquina local.${C_RESET}"
    echo -e "${C_BOLD}Dirección para acceder desde otros dispositivos en tu red:${C_RESET}"
    echo -e "👉 ${C_BLUE}http://$IP_LOCAL:$PUERTO${C_RESET}\n"
    echo -e "${C_YELLOW}[*] Compartiendo la carpeta actual: $(pwd)${C_RESET}"
    echo -e "${C_RED}[!] Presiona Ctrl+C para detener el servidor.${C_RESET}\n"
    
    python3 -m http.server "$PUERTO"
}

# ==========================================
# SECCIÓN: GUÍA DE PUERTOS Y NETWORKING
# ==========================================
mostrar_guia() {
    mostrar_banner
    echo -e "${C_BLUE}${C_BOLD}📚 CHEATSHEET DE PUERTOS COMUNES Y REDES${C_RESET}\n"
    
    echo -e "${C_YELLOW}1. Puertos Clave en Ciberseguridad y Redes:${C_RESET}"
    echo -e "  • ${C_GREEN}21 / TCP${C_RESET}   - FTP (Transferencia de archivos sin cifrar - inseguro)"
    echo -e "  • ${C_GREEN}22 / TCP${C_RESET}   - SSH (Administración remota segura, cifrada)"
    echo -e "  • ${C_GREEN}23 / TCP${C_RESET}   - Telnet (Administración remota sin cifrar - inseguro)"
    echo -e "  • ${C_GREEN}25 / TCP${C_RESET}   - SMTP (Envío de correos electrónicos)"
    echo -e "  • ${C_GREEN}53 / UDP/TCP${C_RESET} - DNS (Resolución de nombres a direcciones IP)"
    echo -e "  • ${C_GREEN}80 / TCP${C_RESET}   - HTTP (Tráfico web plano, no seguro)"
    echo -e "  • ${C_GREEN}443 / TCP${C_RESET}  - HTTPS (Tráfico web cifrado mediante SSL/TLS)"
    echo -e "  • ${C_GREEN}445 / TCP${C_RESET}  - SMB (Compartición de archivos en Windows - muy atacado)"
    echo -e "  • ${C_GREEN}3389 / TCP${C_RESET} - RDP (Escritorio remoto de Windows)"

    echo -e "\n${C_YELLOW}2. Clases de Direcciones IP (IPv4):${C_RESET}"
    echo -e "  • ${C_GREEN}Clase A:${C_RESET} 1.0.0.0 a 126.255.255.255    (Máscara /8 - Redes enormes)"
    echo -e "  • ${C_GREEN}Clase B:${C_RESET} 128.0.0.0 a 191.255.255.255  (Máscara /16 - Redes medianas)"
    echo -e "  • ${C_GREEN}Clase C:${C_RESET} 192.0.0.0 a 223.255.255.255  (Máscara /24 - Hogar / Redes pequeñas)"

    echo -e "\n${C_YELLOW}3. Rangos de Direcciones Privadas (RFC 1918):${C_RESET}"
    echo -e "  • 10.0.0.0 - 10.255.255.255"
    echo -e "  • 172.16.0.0 - 172.31.255.255"
    echo -e "  • 192.168.0.0 - 192.168.255.255"

    echo -e "\n${C_GREEN}[+] Presiona Enter para volver.${C_RESET}"
    read
}

# ==========================================
# DETECTOR DE ARGUMENTOS
# ==========================================
if [ "$1" == "--note" ]; then
    gestionar_apuntes
    exit 0
fi

# ==========================================
# MENÚ PRINCIPAL
# ==========================================
while true; do
    mostrar_banner
    echo -e "${C_BOLD}Elige una opción para comenzar:${C_RESET}\n"
    echo -e "  [${C_GREEN}1${C_RESET}] 🔍 Escanear dispositivos en red local (Nmap Ping Scan)"
    echo -e "  [${C_GREEN}2${C_RESET}] 🛡️ Listar puertos locales abiertos y procesos"
    echo -e "  [${C_GREEN}3${C_RESET}] 🌐 Iniciar servidor web temporal para compartir archivos"
    echo -e "  [${C_GREEN}4${C_RESET}] 📝 Tomar apuntes rápidos para la universidad"
    echo -e "  [${C_GREEN}5${C_RESET}] 📚 Ver guía rápida de puertos y networking"
    echo -e "  [${C_GREEN}6${C_RESET}] ❌ Salir"
    echo ""
    read -p "Ingresa tu elección: " OPCION

    case $OPCION in
        1) escanear_red ;;
        2) auditar_puertos ;;
        3) iniciar_servidor ;;
        4) gestionar_apuntes ;;
        5) mostrar_guia ;;
        6) 
            echo -e "\n${C_GREEN}[+] ¡Suerte en tus estudios y laboratorios! Saludos.${C_RESET}"
            exit 0 
            ;;
        *)
            echo -e "${C_RED}[!] Opción no válida.${C_RESET}"
            sleep 1
            ;;
    esac
done
