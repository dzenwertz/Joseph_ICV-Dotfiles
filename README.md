# Joseph's Dotfiles (Catppuccin Mocha) 

Configuración de entorno de escritorio minimalista para **CachyOS / Arch Linux**.

## Instalación rápida (Un solo comando)

Ejecuta este comando en la terminal para instalar todo automáticamente:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/dzenwertz/Joseph_ICV-Dotfiles/main/bootstrap.sh)"
```

### ¿Qué hace?
1. Clona este repositorio en `~/.dotfiles`.
2. Instala los paquetes necesarios (de sistema y de Hyprland).
3. Crea los enlaces simbólicos en `~/.config`.
4. Configura Zsh como shell por defecto.

## 📦 Componentes incluidos
- **Window Manager:** Hyprland
- **Barra de Estado:** Waybar
- **Lanzador:** Rofi-Wayland
- **Terminal:** Kitty
- **Editor:** Neovim (configurado con Lua)
- **Shell:** Zsh + Starship
- **Notificaciones:** Dunst
- **Sistema:** Tmux, Fastfetch, scripts en `bin/`
