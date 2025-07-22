#!/bin/zsh
# ~/bin/wallpaper_picker.sh

set -euo pipefail

# ── paths ──────────────────────────────────────────────
WALLPAPER_DIR_BASE="$HOME/Pictures/Wallpapers"
STATIC_DIR="$WALLPAPER_DIR_BASE/Static"
ACTIVE_DIR="$WALLPAPER_DIR_BASE/Active"
ACTIVE_FILE="active.png"
ACTIVE_PATH="$ACTIVE_DIR/$ACTIVE_FILE"

mkdir -p "$STATIC_DIR" "$ACTIVE_DIR"

# ── pick a file with rofi ──────────────────────────────
chosen=$(
  find "$STATIC_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -print0 |
    sort -rz |
    while IFS= read -r -d '' f; do
      echo -en "$(basename "$f")\0icon\x1f$f\0meta\x1f$f\n"
    done |
    rofi -dmenu -i -p "Select Wallpaper" \
         -theme "$HOME/.config/rofi/config-wallpaper.rasi" \
         -show-icons -format 's'
)

[[ -z $chosen ]] && { echo "No wallpaper selected."; exit 0; }

[[ $chosen != /* ]] && chosen="$STATIC_DIR/$chosen"
[[ -f $chosen ]] || { echo "File not found: $chosen" >&2; exit 1; }

echo "→ selected: $chosen"

# ── unload previous texture so hyprpaper will re-read ──
hyprctl hyprpaper unload "$ACTIVE_PATH" || true

# ── copy, then (re)load ────────────────────────────────
cp -f "$chosen" "$ACTIVE_PATH"

hyprctl hyprpaper preload  "$ACTIVE_PATH"
hyprctl hyprpaper wallpaper ",$ACTIVE_PATH"

# ── colourschemes (pywal / wallust) ────────────────────
wal    -q -i "$ACTIVE_PATH"
pywalfox update
wallust run "$ACTIVE_PATH"

echo "Wallpaper updated ✔"

