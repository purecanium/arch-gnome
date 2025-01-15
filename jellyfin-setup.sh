#!/bin/bash
set -e

# 
# Jellyfin Media Server setup, backup, and restore script
# 

BACKUP_DIR="$HOME/Documents/backups/jellyfin"
DATA_DIR="/var/lib/jellyfin"
CONFIG_DIR="/etc/jellyfin"

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Prompt user for action"
echo "Choose an option:"
echo "1) Set up Jellyfin"
echo "2) Back up Jellyfin"
echo "3) Restore Jellyfin"
read -p "Enter choice (1,2,3): " choice

case $choice in
    1)  echo "Setting up Jellyfin..."
        sudo pacman -S jellyfin-server jellyfin-ffmpeg jellyfin-web --needed --noconfirm
        sudo ufw allow 8096/tcp
        echo "Set up completed."
        ;;        
    2)
        echo "Backing up Jellyfin..."
        sudo systemctl disable --now jellyfin.service
        sudo cp -a "$DATA_DIR" "$BACKUP_DIR/data"
        sudo cp -a "$CONFIG_DIR" "$BACKUP_DIR/config"
        sudo chown -R $USER:$USER "$BACKUP_DIR/data"
        sudo chown -R $USER:$USER "$BACKUP_DIR/config"
        sudo systemctl enable --now jellyfin.service
        echo "Back up completed."
        ;;
    3)
        echo "Restoring Jellyfin..."
        sudo systemctl disable --now jellyfin.service
        sudo rm -rf "$DATA_DIR" || true
        sudo rm -rf "$CONFIG_DIR" || true
        sudo cp -a "$BACKUP_DIR/data" "$DATA_DIR"
        sudo cp -a "$BACKUP_DIR/config" "$CONFIG_DIR"
        sudo chown -R $Jellyfin:$Jellyfin "$DATA_DIR"
        sudo chown -R $Jellyfin:$Jellyfin "$CONFIG_DIR"
        sudo systemctl enable --now jellyfin.service
        echo "Restore completed."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac