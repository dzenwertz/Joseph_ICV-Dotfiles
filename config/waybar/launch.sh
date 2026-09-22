#!/bin/bash
# Launch Waybar persistently

killall waybar 2>/dev/null
while pgrep -u $UID -x waybar >/dev/null; do sleep 0.1; done

nohup waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css >/tmp/waybar.log 2>&1 &
disown
