#!/bin/sh
set -e

# Archlinux Gnome post install script for my laptop use

# Install git and base-devel
sudo pacman -S git base-devel --needed --noconfirm

# Install yay
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin
makepkg -si --noconfirm && cd ..

# Install essential packages
sudo pacman -S nano ufw bluez dconf cups --needed --noconfirm

# Install basic packages
sudo pacman -S fish firefox gufw dconf-editor fwupd sbctl stow android-tools ntfs-3g gvfs-onedrive gparted qt6ct qbittorrent networkmanager-openvpn power-profiles-daemon os-prober --needed --noconfirm

# Install extra packages
sudo pacman -S vlc keepassxc adw-gtk-theme jellyfin-server jellyfin-ffmpeg jellyfin-web --needed --noconfirm

# Install basic fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd --needed --noconfirm

# Set-up firewall
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 6881:6889/udp 
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable --now ufw.service

# Install AUR Packages
yay -S extension-manager gdm-settings reflector-simple adwaita-qt5 --needed --noconfirm

# Set battery threshold to 80%
#yay -S bat-asus-battery-bin --needed --noconfirm
#sudo bat-asus-battery threshold 80
#sudo bat-asus-battery persist

# Set scroll-speed to 0.3 (sweet spot for my touchpad)
yay -S libinput-config --needed --noconfirm
sudo sh -c 'echo "scroll-factor=0.3" > /etc/libinput.conf'

# Enable bluetooth service
sudo systemctl enable --now bluetooth.service

# Enable cups (printing system) service
sudo systemctl enable --now cups.service

echo
echo

# Silent Boot Configuration
echo -e "## Silent Boot Configuration\n"
echo -e "1. \033[1mEdit Kernel Command Line\033[0m"
echo -e "   - Append the following to /etc/kernel/cmdline:"
echo -e "     \033[3mquiet splash loglevel=3 vt.global_cursor_default=0 plymouth.ignore-serial-consoles\033[0m"
echo -e "   - Example:"
echo -e "     \033[3mroot=PARTUUID=xxxx-xxxx-xxxx-xxxx rw quiet splash loglevel=3 vt.global_cursor_default=0 plymouth.ignore-serial-consoles\033[0m\n"
echo -e "2. \033[1mReinstall the Kernel\033[0m"
echo -e "   - Run:"
echo -e "     \033[3msudo pacman -S linux\033[0m\n"

# Plymouth Splash Screen Setup
echo -e "## Plymouth Splash Screen Setup\n"
echo -e "1. \033[1mInstall Plymouth\033[0m"
echo -e "   - Run:"
echo -e "     \033[3msudo pacman -S plymouth\033[0m\n"
echo -e "2. \033[1mModify mkinitcpio Configuration\033[0m"
echo -e "   - Open /etc/mkinitcpio.conf:"
echo -e "     \033[3msudo nano /etc/mkinitcpio.conf\033[0m"
echo -e "   - Add 'plymouth' before 'filesystems' in the HOOKS line:"
echo -e "     \033[3mHOOKS=(base udev autodetect modconf block plymouth filesystems keyboard fsck)\033[0m\n"
echo -e "3. \033[1mRegenerate Initramfs\033[0m"
echo -e "   - Run:"
echo -e "     \033[3msudo mkinitcpio -P\033[0m\n"
echo -e "4. \033[1mSet Plymouth Theme\033[0m"
echo -e "   - Set theme to 'bgrt' (or your preferred theme):"
echo -e "     \033[3msudo plymouth-set-default-theme -R bgrt\033[0m\n"
echo -e "5. \033[1mEnable Plymouth Service at Boot\033[0m"
echo -e "   - Run:"
echo -e "     \033[3msudo systemctl enable plymouth-start.service\033[0m\n"
