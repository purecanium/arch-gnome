#!/bin/bash

restore_file="$HOME/Documents/backups/dconf-backup"
[ -e "$HOME/Documents/backups/dconf-backup" ] && dconf load / < "$HOME/Documents/backups/dconf-backup" || echo "File does not exist."
