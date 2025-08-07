#!/bin/bash

# Get update count
updates=$(checkupdates 2>/dev/null | wc -l)

if [ -z "$updates" ] || [ "$updates" = "0" ]; then
    # If no updates, output JSON with text and class for styling
    echo '{"text": "0", "class": "no-updates", "tooltip": "System is up to date"}'
else
    # If updates available, output JSON with number and tooltip
    echo "{\"text\": \"$updates\", \"class\": \"has-updates\", \"tooltip\": \"$updates updates available\"}"
fi
