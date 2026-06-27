# Joseph's Dotfiles (Catppuccin Mocha) ✨

Configuración minimalista, estética y funcional diseñada para **CachyOS / Arch Linux** con el esquema de colores **Catppuccin Mocha**.

## 🚀 Instalación en un solo comando

Puedes instalar y configurar todo tu entorno ejecutando la siguiente línea en tu terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/dzenwertz/Joseph_ICV-Dotfiles/main/bootstrap.sh)"
```

*O si prefieres usar `wget`:*

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/dzenwertz/Joseph_ICV-Dotfiles/main/bootstrap.sh)"
```

Este comando:
1. Clonará el repositorio automáticamente en `~/.dotfiles`.
2. Actualizará tus paquetes del sistema.
3. Creará los enlaces simbólicos correctos en tu carpeta `~/.config`.
4. Configurará Zsh y tus herramientas favoritas.

---

## 📦 Componentes Incluidos

* **Window Manager:** [Hyprland](https://hyprland.org/) (Configuración suave con animaciones fluidas)
* **Barra de Estado:** [Waybar](https://github.com/Alexays/Waybar) (Estilo minimalista e informativo)
* **Lanzador de Aplicaciones:** [Rofi-Wayland](https://github.com/lbonn/rofi) (Menú de aplicaciones y apagado rápido)
* **Editor de Código:** [Neovim](https://neovim.io/) (Configuración optimizada con soporte Lua)
* **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/) (Acelerada por GPU, con tema Catppuccin)
* **Shell:** [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) (Prompt rápido, limpio y personalizable)
* **Multiplexor:** [tmux](https://github.com/tmux/tmux) (Sesiones persistentes y paneles eficientes)
* **Notificaciones:** [Dunst](https://dunst-project.org/) (Estilo Catppuccin flotante)
* **Información del Sistema:** [Fastfetch](https://github.com/fastfetch-cli/fastfetch) (Muestra de especificaciones limpia)

---

## 🛠️ Estructura del Repositorio

* `bin/` - Scripts útiles de utilidad diaria (selección de fondos, menú de apagado, asistente interactivo, etc.).
* `hypr/` - Archivos de configuración de Hyprland (`hyprland.conf`, `hyprlock.conf`, `hypridle.conf`).
* `waybar/` - Configuración y estilo CSS de la barra superior.
* `rofi/` - Temas y layouts para el lanzador de aplicaciones.
* `kitty/` - Configuración y atajos de teclado para la terminal.
* `nvim/` - Configuración inicial de Neovim en Lua.
* `zsh/` - Configuración de shell y aliases.
* `tmux/` - Layouts y atajos para tmux.
* `dunst/` - Notificaciones visuales.
* `fastfetch/` - Layout del fetcher de sistema.

---
*¡Disfruta de tu nuevo entorno de desarrollo!*
