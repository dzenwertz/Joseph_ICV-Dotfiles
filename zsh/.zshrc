# Zsh Configuration - Minimalist & Productive
# Theme: Catppuccin Mocha + Starship

# Paths and Environment Variables
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.dotfiles/bin
export EDITOR="nvim"
export VISUAL="nvim"

# Zsh History Settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Basic Zsh Keybindings (Emacs style, standard)
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Load Arch/CachyOS Zsh Plugins if installed
# These paths are standard for pacman-installed zsh-syntax-highlighting and zsh-autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ==========================================
# ALIASES & UTILITIES
# ==========================================

# Modern alternatives (Eza & Bat)
if command -v eza &> /dev/null; then
    alias ls='eza --icons=always --group-directories-first'
    alias ll='eza -lh --icons=always --git --group-directories-first'
    alias la='eza -a --icons=always --group-directories-first'
    alias lt='eza --tree --level=2 --icons=always'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias catp='bat' # with paging
fi

# Quick navigation (Zoxide)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# Starship Prompt Initialization
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# General Productivity Aliases
alias q="exit"
alias c="clear"
alias h="history"
alias update="sudo pacman -Syu"
alias yayup="yay -Sua"

# University & Note Taking (Markdown)
alias uni="cd ~/Universidad 2>/dev/null || cd ~"
alias apunte="cyber_helper.sh --note" # Calls our note helper
alias notas="ls ~/Universidad/*/*.md 2>/dev/null"

# Cybersecurity & Networking Aliases
alias myip="echo -e '\e[1;34m[Local IP]\e[0m'; ip -brief -color address; echo; echo -e '\e[1;32m[Public IP]\e[0m'; curl -s https://ifconfig.me; echo"
alias ports="sudo ss -tulanp"
alias listener="sudo tcpdump -i any -n"
alias serve="echo -e '\e[1;33m[+] Iniciando servidor HTTP en puerto 8000...\e[0m'; python3 -m http.server 8000"

# Nmap Scan Presets (For learning and labs)
alias nmap-fast="nmap -T4 -F --open"                     # Scan top ports fast
alias nmap-det="nmap -sC -sV -p- -oN nmap_detail.txt"    # Full detailed scan
alias nmap-vuln="nmap --script vuln -p-"                 # Vulnerability scanner
alias nmap-ping="nmap -sn"                               # Ping sweep to map network

# Security helper interactive script
alias cyberhelp="cyber_helper.sh"

# Wallpaper selector
alias fondo="wallpaper_selector.sh"

# Auto-completion improvements
autoload -Uz compinit
compinit -d ~/.zcompdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Start Fastfetch in interactive sessions
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi

# Quick Archive Extractor
extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar x "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"      ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"       ;;
      *)           echo "'$1' no se puede extraer mediante extract()" ;;
    esac
  else
    echo "'$1' no es un archivo válido"
  fi
}

# opencode
export PATH=$HOME/.opencode/bin:$PATH
