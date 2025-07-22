#!/bin/bash


# Define your wallpaper directory and active directory

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

ACTIVE_DIR="$WALLPAPER_DIR/Active"


# Ensure the Active directory exists

mkdir -p "$ACTIVE_DIR"


# Determine the primary monitor name

MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.primary) | .name')


# Fallback to focused monitor if primary is not found

if [[ -z "$MONITOR_NAME" ]]; then

    MONITOR_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

    if [[ -z "$MONITOR_NAME" ]]; then

        echo "Error: Could not determine monitor name. Ensure a monitor is connected." >&2

        exit 1

    fi

    echo "Warning: Primary monitor not found. Using focused monitor: $MONITOR_NAME"

fi


# Generate a list of image files with the required format for Wofi

find "$WALLPAPER_DIR" -maxdepth 1 \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) |

while read -r filepath; do

    filename=$(basename "$filepath")

    name_without_extension="${filename%.*}"

    echo "img:$filepath:text:$name_without_extension"

done | wofi --dmenu \

            --allow-images \

            --prompt "Select Wallpaper:" \

            --image-size 100 \

            --style ~/.config/wofi/style.css |

while read -r selected_entry; do

    selected_file=$(echo "$selected_entry" | sed -E 's/^img:(.*):text:(.*)$/\1/')

    FULL_PATH="$selected_file"


    if [[ -f "$FULL_PATH" ]]; then

        # Copy the selected wallpaper to the Active directory as active.png

        cp -f "$FULL_PATH" "$ACTIVE_DIR/active.png"


        # Set the wallpaper using hyprpaper

        hyprctl hyprpaper preload "$FULL_PATH"

        hyprctl hyprpaper wallpaper "$MONITOR_NAME,$FULL_PATH"


        # Apply the color scheme using wal

        wal -i "$FULL_PATH" -n

    else

        echo "Error: Selected file not found: $FULL_PATH" >&2

        exit 1

    fi

done

exit 0
