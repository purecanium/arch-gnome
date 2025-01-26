#!/bin/sh
set -e

# dconf back up and restore

BACKUP_DIR="$HOME/Documents/backups/dconf"
mkdir -p "$BACKUP_DIR"

echo "Choose an option:"
echo "1) Back up dconf settings"
echo "2) Restore dconf settings"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "Backing up dconf settings..."
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKUP_FILE="$BACKUP_DIR/dconf-backup_$TIMESTAMP"
        dconf dump / > "$BACKUP_FILE"
        echo "Backup completed: $BACKUP_FILE"
        ;;
    2)
        echo "Available backups:"
        BACKUP_FILES=("$BACKUP_DIR"/dconf-backup_*)

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
                echo "Restoring dconf settings from $CHOSEN_BACKUP..."
                dconf load / < "$CHOSEN_BACKUP"
                echo "Restore completed."
                break
            else
                echo "Invalid choice, please try again."
            fi
        done
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
