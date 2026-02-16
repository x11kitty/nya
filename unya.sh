#!/bin/bash

# Exit on error
set -e

echo "🗑️ Starting the ArchyBspwm Cleanup..."

## 1. Disable and Remove LightDM
echo "🖥️ Disabling LightDM..."
sudo systemctl disable lightdm || true
sudo pacman -Rs --noconfirm lightdm lightdm-gtk-greeter || true
# Clean up the specific config file created
sudo rm -f /etc/lightdm/lightdm-gtk-greeter.conf

## 2. Remove Core Window Manager & Apps
# We use -Rs to remove the packages and their unused dependencies
echo "📦 Removing BSPWM, Polybar, and utility packages..."
sudo pacman -Rs --noconfirm \
    bspwm sxhkd polybar picom rofi kitty scrot nm-connection-editor \
    brightnessctl pamixer xorg-xkill xorg-xset xorg-xrdb xorg-xprop \
    libqalculate intel-gpu-tools xf86-video-fbdev xorg-xbacklight \
    dmenu gwenview spectacle mplayer stalonetray feh \
    ttf-hack-nerd ttf-firacode-nerd papirus-icon-theme bc \
    power-profiles-daemon ttc-iosevka ttf-font-awesome \
    noto-fonts-cjk adobe-source-han-sans-jp-fonts tlp \
    materia-gtk-theme breeze-gtk || true

## 3. Remove AUR Packages
echo "🔡 Removing AUR packages..."
if command -v yay &> /dev/null; then
    yay -Rs --noconfirm wlogout nm-applet xwinwrap-git otf-ipafont \
        ttf-jetbrains-mono nerd-fonts-iosevka ttf-siji ttf-jetbrains-mono-nerd \
        whitesur-icon-theme-git ttf-iosevka-custom ttf-iosevka-nerd ttf-unifont || true
fi

## 4. Cleaning Configuration Files
echo "⚙️ Removing configuration files..."
# Remove the folders created in .config
rm -rf ~/.config/bspwm
rm -rf ~/.config/sxhkd
rm -rf ~/.config/polybar
rm -rf ~/.config/picom
rm -rf ~/.config/rofi
rm -rf ~/.config/kitty

# Remove dotfiles moved to $HOME
rm -f ~/.Xresources
rm -f ~/.bashrc

# Optional: Restore a default .bashrc if it was overwritten
if [ ! -f ~/.bashrc ]; then
    cp /etc/skel/.bashrc ~/.bashrc
    echo "📄 Restored default .bashrc from /etc/skel/"
fi

## 5. Reverting Audio (Optional)
# Note: Keeping Pipewire is usually recommended, but if you want it gone:
# sudo pacman -Rs --noconfirm pipewire pipewire-pulse wireplumber || true

## 6. Cleanup Gaming/Zen Kernel (CAUTION)
echo "🎮 Removing Zen Kernel and Gaming tools..."
# We keep the headers/kernel removal separate in case you are currently booted into it
sudo pacman -Rs --noconfirm steam gamemode mangohud wine-staging gamescope winetricks || true

echo "🔄 Updating Grub..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "✅ Cleanup complete."
echo "⚠️ IMPORTANT: If you removed your only desktop environment, please install another (like GNOME, KDE, or XFCE) before rebooting!"
