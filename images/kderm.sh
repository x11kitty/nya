#!/bin/bash
# purge_kde_total.sh

echo "Step 1: Stopping SDDM and Display Services..."
sudo systemctl disable sddm
sudo systemctl stop sddm

echo "Step 2: Removing KDE, Plasma, X11, and Wayland sessions..."
# This list covers the core meta-packages and the specific X11 session you added
sudo pacman -Rns --noconfirm \
    plasma-meta \
    plasma-x11-session \
    kde-applications \
    sddm \
    kwin-x11 \
    plasma-workspace \
    xdg-desktop-portal-kde \
    wayland \
    qt6-wayland \
    qt5-wayland

echo "Step 3: Removing unused orphan dependencies..."
# This cleans up any libraries that were only there for KDE
sudo pacman -Qtdq | sudo pacman -Rns - 2>/dev/null

echo "Step 4: Deep Cleaning Configuration Directories..."
# System-wide autostart and KDE configs
sudo rm -rf /etc/xdg/autostart/*kde*
sudo rm -rf /etc/xdg/plasma*
sudo rm -rf /usr/share/wayland-sessions/plasma*
sudo rm -rf /usr/share/xsessions/plasma*

# User-specific local data (the stuff that causes 'ghost' settings)
rm -rf ~/.local/share/plasma*
rm -rf ~/.local/share/kde*
rm -rf ~/.local/share/kwin
rm -rf ~/.config/plasma*
rm -rf ~/.config/kde*
rm -rf ~/.cache/kde*
rm -rf ~/.cache/plasma*

echo "------------------------------------------------"
echo "KDE Plasma has been completely removed."
echo "You are now at a command-line-only state."
echo "It is highly recommended to reboot now."
echo "------------------------------------------------"
