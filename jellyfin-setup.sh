#!/bin/bash
Set -e

# 
# Jellyfin Media Server setup, backup, and restore script
# 

sudo pacman -S jellyfin-server jellyfin-ffmpeg jellyfin-web --needed --noconfirm
sudo ufw allow 8096/tcp

while true; do
    read -p "Enter your name: " name
    if [[ -n "$name" ]]; then
        echo "Hello, $name!"
        break
    else
        echo "Name cannot be empty. Please try again."
    fi
done
