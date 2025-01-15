#!/bin/bash

mkdir -p "$HOME/Documents/backups"
dconf dump / > "$HOME/Documents/backups/dconf-backup"
