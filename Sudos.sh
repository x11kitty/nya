## 1. User & Sudo Setup
echo "👤 User Configuration..."

# Ask for the username
read -p "Enter the username you want to configure: " username

# 1a. Add user to wheel group
usermod -aG wheel "$username"

# 1b. Set the password for the user
echo "🔐 Set the password for $username:"
passwd "$username"

# 1c. Enable sudo for the wheel group
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "✅ User '$username' is now a sudoer with a new password."
