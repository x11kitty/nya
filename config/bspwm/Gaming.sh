#!/bin/bash

# --- Color Palette ---
PINK='\033[1;35m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

# --- Paths ---
# This path works for most modern Intel/AMD systems on Arch
PREF_PATH="/sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference"

# --- UI Elements ---
LINE="${PINK}───────────────────────────────────────${RESET}"

# Get current status (checking the first core)
CURRENT=$(cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference)

clear
echo -e "${LINE}"
echo -e "${CYAN}${BOLD}  🗼 TOKYO KERNEL-LEVEL CONTROL ${RESET}"
echo -e "  Current Mode: ${YELLOW}${CURRENT^^}${RESET}"
echo -e "${LINE}"
echo -e "  ${PINK}1)${RESET} 🔋 ${BOLD}POWER${RESET}        - [Min Watts / Cool]"
echo -e "  ${PINK}2)${RESET} ⚖️  ${BOLD}BALANCED${RESET}     - [Dynamic City Life]"
echo -e "  ${PINK}3)${RESET} ⚡ ${BOLD}PERFORMANCE${RESET}  - [Maximum Overdrive]"
echo -e "  ${PINK}q)${RESET} ❌ ${BOLD}EXIT${RESET}"
echo -e "${LINE}"

read -p "  Access Kernel > " choice

case $choice in
    1)
        echo "power" | sudo tee $PREF_PATH > /dev/null
        echo -e "\n  ${CYAN}» System:${RESET} ${YELLOW}Energy preference: POWER SAVER${RESET}"
        ;;
    2)
        echo "balance_performance" | sudo tee $PREF_PATH > /dev/null
        echo -e "\n  ${CYAN}» System:${RESET} ${YELLOW}Energy preference: BALANCED${RESET}"
        ;;
    3)
        echo "performance" | sudo tee $PREF_PATH > /dev/null
        echo -e "\n  ${CYAN}» System:${RESET} ${PINK}${BOLD}Energy preference: PERFORMANCE${RESET}"
        ;;
    q|[Qq])
        echo -e "\n  ${CYAN}Closing Terminal... Sayonara.${RESET}"
        exit 0
        ;;
    *)
        echo -e "\n  ${PINK}Error: Unauthorized Input.${RESET}"
        ;;
esac

echo -e "${LINE}"
