#!/usr/bin/env bash
# ~/.config/hypr/scripts/power-menu.sh

declare -A ICONS=(
  [Lock]=lock [Logout]=logout [Suspend]=pause_circle
  [Shutdown]=power_settings_new [Hibernate]=power [Reboot]=restart_alt
)
declare -A ACTIONS=(
  [Lock]="swaylock"
  [Logout]="hyprctl dispatch exit"
  [Suspend]="systemctl suspend"
  [Shutdown]="systemctl poweroff"
  [Hibernate]="systemctl hibernate"
  [Reboot]="systemctl reboot"
)

# 1) Build a proper JSON array
menu_json="["

for name in "${!ICONS[@]}"; do
  menu_json+="{\"name\":\"$name\",\"icon\":\"${ICONS[$name]}\"},"
done

# strip trailing comma, close array
menu_json="${menu_json%,}]"

# 2) Pipe that array into Wofi (grid mode) and capture the chosen "name"
choice=$(printf '%s' "$menu_json" \
         | wofi --show grid --json - --style ~/.config/wofi/style.css
        ) || exit 0

# 3) Extract the .name field with jq
sel=$(jq -r '.name' <<< "$choice")

# 4) Dispatch the associated action
exec bash -c "${ACTIONS[$sel]}"

