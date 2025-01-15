#!/bin/bash
set -e

# 
# Archlinux Gnome post install script for my laptop use
# 

# Install git and base-devel
sudo pacman -S git base-devel --needed --noconfirm

# Install yay
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin
makepkg -si --noconfirm && cd ..

# Install essential packages
sudo pacman -S nano ufw bluez dconf cups --needed --noconfirm

# Install basic packages
sudo pacman -S fish firefox gufw dconf-editor fwupd sbctl stow android-tools ntfs-3g gvfs-onedrive gparted qt5ct qbittorrent networkmanager-openvpn --needed --noconfirm

# Install extra packages
sudo pacman -S vlc keepassxc jellyfin-server jellyfin-ffmpeg jellyfin-web --needed --noconfirm

# Install basic fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --needed --noconfirm

# Set-up firewall
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tc
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable --now ufw.service

# Install AUR Packages
yay -S extension-manager gdm-settings reflector-simple --needed --noconfirm

# Set battery threshold to 80%
yay -S bat-asus-battery-bin --needed --noconfirm
sudo bat-asus-battery threshold 80
sudo bat-asus-battery persist

# Set scroll-speed to 0.3 (sweet spot for my touchpad)
yay -S libinput-config --needed --noconfirm
sudo sh -c 'echo "scroll-factor=0.3" > /etc/libinput.conf'

# Enable bluetooth service
sudo systemctl enable --now bluetooth.service

# Enable cups (printing system) service
sudo systemctl enable --now cups.service
