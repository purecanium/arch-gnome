#!/bin/sh
set -e

# Firefox profile back up and restore

BACKUP_DIR="$HOME/Documents/.backups/firefox"
PROFILE_DIR="$HOME/.mozilla/firefox"

mkdir -p "$BACKUP_DIR"

echo "Choose an option:"
echo "1) Backup Firefox Profiles"
echo "2) Restore Firefox Profiles"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "Backing up Firefox profiles..."
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKUP_FILE="$BACKUP_DIR/firefox-profiles_$TIMESTAMP.tar.gz"
        if [ -z "$(ls -A "$PROFILE_DIR")" ]; then
            echo "Error: Firefox profile directory is empty. Backup aborted."
            exit 1
        fi
        tar -czf "$BACKUP_FILE" -C "$PROFILE_DIR" .
        echo "Backup completed: $BACKUP_FILE"
        ;;
    2)
        echo "Available backups:"
        BACKUP_FILES=($(ls "$BACKUP_DIR"/*.tar.gz 2>/dev/null))

        if [ ${#BACKUP_FILES[@]} -eq 0 ]; then
            echo "No backups found."
            exit 1
        fi

        mkdir -p $HOME/.mozilla/firefox
        PS3="Select a backup to restore: "
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
        
        echo "Restoring Firefox profiles from $CHOSEN_BACKUP..."
        rm -rf "$PROFILE_DIR"/*
        tar -xzf "$CHOSEN_BACKUP" -C "$PROFILE_DIR"
        echo "Restore completed."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
