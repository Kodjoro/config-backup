#!/bin/bash

# This script uses wofi to display a power menu and execute the selected action.

# Define the power options
options=" Power Off\n başlat Restart\n Lock\n Logout"

# Use wofi to display the menu and get the user's choice
choice=$(echo -e "$options" | wofi -i --dmenu -p "Power Menu:")

# Execute the selected action
case "$choice" in
    " Power Off")
        systemctl poweroff
        ;;
    " başlat Restart")
        systemctl reboot
        ;;
    " Lock")
        # Replace swaylock-effects with your lock screen command if different
        swaylock-effects
        ;;
    " Logout")
        # Replace hyprctl dispatch exit with the command to exit your Hyprland session
        # This is the standard way to exit Hyprland
        hyprctl dispatch exit
        ;;
    *)
        # Do nothing if no option is selected or wofi is closed
        ;;
esac

