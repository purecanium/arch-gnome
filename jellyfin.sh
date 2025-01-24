#!/usr/bin/env
set -e

# Jellyfin back up and restore script

BACKUP_DIR="$HOME/Documents/backups/jellyfin"
DATA_DIR="/var/lib/jellyfin"
CONFIG_DIR="/etc/jellyfin"

mkdir -p "$BACKUP_DIR"

echo "Choose an option:"
echo "1) Back up Jellyfin"
echo "2) Restore Jellyfin"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "Backing up Jellyfin..."
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKUP_FILE="$BACKUP_DIR/jellyfin_$TIMESTAMP.tar.gz"
        sudo systemctl disable --now jellyfin.service
        sudo tar -czf "$BACKUP_FILE" "$DATA_DIR" "$CONFIG_DIR"
        sudo chown "$USER:$USER" "$BACKUP_FILE"
        sudo systemctl enable --now jellyfin.service
        echo "Backup completed: $BACKUP_FILE"
        ;;
    2)
        echo "Available backups:"
        BACKUP_FILES=($(ls "$BACKUP_DIR"/*.tar.gz 2>/dev/null))

        if [ ${#BACKUP_FILES[@]} -eq 0 ]; then
            echo "No backups found."
            exit 1
        fi

        PS3="Select a backup to restore (or type 'cancel' to exit): "
        select CHOSEN_BACKUP in "${BACKUP_FILES[@]}" "cancel"; do
            if [[ "$CHOSEN_BACKUP" == "cancel" ]]; then
                echo "Restore canceled."
                exit 0
            fi

            if [[ -n "$CHOSEN_BACKUP" ]]; then
                break
            else
                echo "Invalid choice, please try again."
            fi
        done

        echo "Restoring Jellyfin from $CHOSEN_BACKUP..."
        sudo systemctl disable --now jellyfin.service
        sudo rm -rf "$DATA_DIR" || true
        sudo rm -rf "$CONFIG_DIR" || true
        sudo tar -xzf "$CHOSEN_BACKUP" -C /
        sudo chown -R "$Jellyfin:$Jellyfin" "$DATA_DIR" "$CONFIG_DIR"
        sudo systemctl enable --now jellyfin.service
        echo "Restore completed."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
