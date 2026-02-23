#!/bin/bash

# Exit on error
set -e

echo "🌌 Starting the Complete ArchyBspwm Installation..."

#Multilib
sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

## 0. LightDM Installation and Setup
echo "🖥️ Installing and configuring LightDM..."
sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter

# Enable the LightDM service to start on boot
sudo systemctl enable lightdm

#Perfect-Grub-system 
sudo tee /etc/default/grub > /dev/null <<EOF
# GRUB Core Settings
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Arch"

# Professional Silent Boot
# 'udev.log_level=3' and 'vt.global_cursor_default=0' keep the screen black and clean
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash vt.global_cursor_default=0"
GRUB_CMDLINE_LINUX=""

# Graphical Settings
GRUB_TERMINAL_OUTPUT="gfxterm"
GRUB_GFXMODE="1920x1080,auto" # Set this to your monitor's native res
GRUB_GFXPAYLOAD_LINUX="keep"

# Theme & Visuals
# I recommend installing the 'distro-grub-themes' or 'shv-grub-theme' from AUR
GRUB_THEME="/boot/grub/themes/arch-silence/theme.txt"

# Modern Functionality
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_SUBMENU="y"
GRUB_DISABLE_OS_PROBER="false" # Set to false if you dual-boot Windows

# Preloads
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
EOF

# Configure the background image in the greeter config
# This targets line 60 specifically as requested
sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null <<EOF
# LightDM GTK+ Greeter Configuration
# Professional Minimalist Setup

[greeter]
# Appearance
background = /usr/1.jpg
theme-name = Materia-dark
icon-theme-name = Adwaita
cursor-theme-name = Adwaita
user-background = false
default-user-image = /usr/1.png

# Fonts & Rendering
font-name = Sans 11
xft-antialias = true
xft-dpi = 96
xft-hintstyle = hintslight
xft-rgba = rgb

# Login Window Layout
position = 10%,start 50%,center
hide-user-image = false
round-user-image = true

# Panel Configuration
panel-position = top
indicators = ~host;~spacer;~clock;~spacer;~layout;~session;~power
clock-format = %A, %B %d  %H:%M

# Security
screensaver-timeout = 60
EOF


## 1. core Packages
sudo pacman -S --needed --noconfirm \
git nano curl wget less rust net-tools htop

## 1. Core Dependencies (Step 1 & Polybar Deps)
echo "📦 Installing system utilities and Xorg..."
sudo pacman -S --needed --noconfirm \
    bspwm sxhkd polybar xterm picom rofi kitty scrot nm-connection-editor \
    brightnessctl pamixer ffmpeg xorg-server xorg-xinit xorg-xrandr \
    xf86-video-intel xorg-xkill xorg-xset xorg-xrdb xorg-xprop libqalculate \
    intel-gpu-tools mpv xf86-video-fbdev xorg-xbacklight dmenu breeze-icons \
    git nano curl wget less rust net-tools htop gwenview spectacle mplayer \
    ttf-hack-nerd ttf-firacode-nerd papirus-icon-theme bc power-profiles-daemon \
    python-gobject python unzip unrar p7zip ufw ttc-iosevka feh stalonetray \
    ttf-font-awesome ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono \
    ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji gparted dolphin \
    wmctrl cpupower flatpak discover noto-fonts-cjk adobe-source-han-sans-jp-fonts \
    tlp python-sphinx python-packaging libuv cairo xcb-util xcb-util-wm \
    xcb-util-image xcb-util-xrm xcb-util-cursor alsa-lib libpulse jsoncpp \
    libmpdclient libcurl-gnutls libnl materia-gtk-theme github-cli breeze-gtk i3 flatpak krita vlc lutris

## 2. AUR Helper (Yay)
if ! command -v yay &> /dev/null; then
    echo "📦 Installing yay..."
    cd .. &&
    git clone https://aur.archlinux.org/yay.git &&
    cd yay && makepkg -si --noconfirm
fi

## 3. AUR Packages & Fonts
echo "🔡 Installing AUR packages and extra fonts..."
sudo yay -S --noconfirm wlogout nm-applet xwinwrap-git otf-ipafont \
    ttf-jetbrains-mono nerd-fonts-iosevka ttf-siji ttf-jetbrains-mono-nerd \
    whitesur-icon-theme-git ttf-iosevka-custom ttf-iosevka-nerd ttf-unifont 

## 4. Repository Setup
if [ ! -d "nya" ]; then
    git clone https://github.com/x11kitty/nya.git
fi
cd nya

echo "⚙️ Deploying configurations..."
sudo cp -r config/* ~/.config/
# Copying files with # in the name and renaming them to standard dotfiles
cp "#.Xresources" "$HOME/.Xresources"
# Copying files with # in the name and renaming them to standard dotfiles
cp "#.bashrc" "$HOME/.bashrc"

# Wallpaper for lightdm
sudo cp 1.jpg /usr
# PfP picture
sudo cp 1.png /usr

## 5. Permissions (Step 4)
echo "🔐 Setting execution permissions..."
sudo chmod +x ~/.config/bspwm/bspwmrc
sudo chmod +x ~/.config/sxhkd/sxhkdrc
sudo chmod +x ~/.config/bspwm/Archy.sh
sudo chmod +x ~/.config/bspwm/Disp.sh
sudo chmod +x ~/.config/bspwm/walls.sh
sudo chmod +x ~/.config/bspwm/power.sh
sudo chmod +x ~/.config/dolphinrc
sudo chmod +x ~/.config/bspwm/Gaming.sh

## 6. Audio Setup (Pipewire)
echo "🔊 Switching to Pipewire..."
sudo pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber

## 7. Gaming & Kernel (Zen)
echo "🎮 Installing Gaming Tools & Zen Kernel..."
sudo pacman -S --noconfirm linux-zen linux-zen-headers steam gamemode mangohud wine-staging gamescope yt-dlp

# Polybar Dependencies
sudo pacman -S --needed --noconfirm base-devel git cmake cairo libxcb xcb-proto xcb-util-image xcb-util-wm xcb-util-xrm python-sphinx

# Wine dependencies
sudo pacman -S --needed --noconfirm wine-staging winetricks giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libxxf86vm lib32-libxxf86vm cups samba dosbox

yay -S --noconfirm protonup-qt proton-ge-custom-bin ani-cli

echo "🔄 Updating Grub..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "✅ ALL DONE! Please REBOOT your system."

