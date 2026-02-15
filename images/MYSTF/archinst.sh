#!/bin/bash

echo "--- Arch Linux Custom Installer ---"

# 1. Gather User Info
read -p "Target drive (e.g., /dev/sda): " DRIVE
read -p "Hostname: " MY_HOSTNAME
read -p "Username: " MY_USER
read -s -p "User Password: " MY_PASS
echo -e "\n"

# 2. CHOOSE YOUR DESKTOP
echo "Which Desktop Environment would you like?"
echo "1) GNOME"
echo "2) KDE Plasma"
echo "3) XFCE (Lightweight)"
echo "4) None (CLI only)"
read -p "Enter choice [1-4]: " DE_CHOICE

case $DE_CHOICE in
    1) DE_PKGS="gnome gnome-extra" ;;
    2) DE_PKGS="plasma-desktop sddm konsole dolphin" ;;
    3) DE_PKGS="xfce4 xfce4-goodies lightdm lightdm-gtk-greeter" ;;
    *) DE_PKGS="" ;;
esac

# 3. CHOOSE ADDITIONAL TOOLS
read -p "Install Graphics Drivers? (nvidia/mesa/none): " GPU_TYPE
read -p "Install Web Browser? (firefox/chromium/none): " BROWSER

# --- INSTALLATION START ---

# Partitioning & Mounting (Simplified for UEFI)
parted -s "$DRIVE" mklabel gpt
parted -s "$DRIVE" mkpart ESP fat32 1MiB 513MiB
parted -s "$DRIVE" set 1 esp on
parted -s "$DRIVE" mkpart primary ext4 513MiB 100%

mkfs.fat -F32 "${DRIVE}1"
mkfs.ext4 -F "${DRIVE}2"

mount "${DRIVE}2" /mnt
mkdir -p /mnt/boot
mount "${DRIVE}1" /mnt/boot

# Pacstrap (Base + your selections)
pacstrap /mnt base linux linux-firmware nano networkmanager sudo $DE_PKGS $GPU_TYPE $BROWSER

genfstab -U /mnt >> /mnt/etc/fstab

# --- INTERNAL CONFIGURATION ---
cat <<EOF > /mnt/setup.sh
#!/bin/bash
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$MY_HOSTNAME" > /etc/hostname

useradd -m -G wheel "$MY_USER"
echo "$MY_USER:$MY_PASS" | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable Services
systemctl enable NetworkManager
[[ "$DE_CHOICE" == "1" ]] && systemctl enable gdm
[[ "$DE_CHOICE" == "2" ]] && systemctl enable sddm
[[ "$DE_CHOICE" == "3" ]] && systemctl enable lightdm

EOF

arch-chroot /mnt bash /setup.sh
rm /mnt/setup.sh

echo "Done! Type 'reboot' to start your new Arch system."
