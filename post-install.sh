#!/bin/sh
set -e

# Archlinux Gnome post install script for my laptop use

# Install git and base-devel
sudo pacman -S git base-devel --needed --noconfirm

# Install yay (AUR helper)
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin
makepkg -si --noconfirm && cd ..

# Install essential packages
sudo pacman -S nano ufw bluez dconf cups --needed --noconfirm

# Install basic packages
sudo pacman -S fish firefox gufw dconf-editor fwupd sbctl stow android-tools ntfs-3g \
               gvfs-onedrive gparted qt6ct qbittorrent networkmanager-openvpn \
               power-profiles-daemon --needed --noconfirm

# Install extra packages
sudo pacman -S vlc keepassxc adw-gtk-theme jellyfin-server jellyfin-ffmpeg jellyfin-web \
               --needed --noconfirm

# Install basic fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
               ttf-jetbrains-mono-nerd --needed --noconfirm

# Set-up firewall
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable --now ufw.service

# Firewall exception for Gsconnect (KDE Connect)
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

# Install AUR Packages
yay -S extension-manager gdm-settings reflector-simple adwaita-qt6 --needed --noconfirm

# Set battery threshold to 80% (I currently use a Gnome extension as an alternative)
#yay -S bat-asus-battery-bin --needed --noconfirm
#sudo bat-asus-battery threshold 80
#sudo bat-asus-battery persist

# Set scroll-speed to 0.3 (sweet spot for my touchpad)
yay -S libinput-config --needed --noconfirm
sudo sh -c 'echo "scroll-factor=0.3" > /etc/libinput.conf'

# Enable bluetooth service
sudo systemctl enable --now bluetooth.service

# Enable power profiles daemon
sudo systemctl enable --now power-profiles-daemon.service

# Enable cups (printing system) service
sudo systemctl enable --now cups.service

# Add ntfs-3g plugin for accessing onedrive folder in Linux
sudo cp ./ntfs-plugin-9000001a.so /usr/lib64/ntfs-3g/

# Change default systemd power key and lid behavior
sudo sed -i \
  -e '/^#\?HandlePowerKey=/c\HandlePowerKey=suspend' \
  -e '/^#\?HandleLidSwitch=/c\HandleLidSwitch=ignore' \
  /etc/systemd/logind.conf

# Create directories before stowing
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/icons"

echo
echo

sh ./splashscreen_boot.sh
