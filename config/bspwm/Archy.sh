#!/bin/bash

# --- Retro Tokyo Color Palette ---
PINK='\033[38;5;205m'
PURPLE='\033[38;5;93m'
CYAN='\033[38;5;51m'
BOLD='\033[1m'
RESET='\033[0m'

clear
echo -e "${PURPLE}==========================================${RESET}"
echo -e "${PINK}${BOLD}   ＡＲＣＨ  ＭＡＩＮＴＥＮＡＮＣＥ   ${RESET}"
echo -e "${CYAN}   System Care & Optimization Tool${RESET}"
echo -e "${PURPLE}==========================================${RESET}"
echo -e "${CYAN}1)${RESET} Update Repos (Pacman & Yay)"
echo -e "${CYAN}2)${RESET} Clear Cache (Deep Clean)"
echo -e "${CYAN}3)${RESET} Remove Orphaned Packages"
echo -e "${CYAN}4)${RESET} Clean Package Cache (paccache)"
echo -e "${CYAN}5)${RESET} Verify Package Integrity"
echo -e "${CYAN}6)${RESET} View Critical Journal Logs"
echo -e "${CYAN}7)${RESET} Create Snapshot (Timeshift/Btrfs)"
echo -e "${CYAN}8)${RESET} Manage Configs (Pacdiff)"
echo -e "${CYAN}9)${RESET} Exit"
echo -e "${PURPLE}==========================================${RESET}"
echo -ne "${PINK}Select an action [1-9]: ${RESET}"
read CHOICE

case $CHOICE in
    1)
        echo -e "${CYAN}Running full system upgrade...${RESET}"
        sudo pacman -Syu && yay -Syu
        ;;
    2)
        echo -e "${CYAN}Clearing package caches...${RESET}"
        sudo pacman -Scc && sudo pacman -Sc
        yay -Scc && yay -Sc
        ;;
    3)
        echo -e "${CYAN}Searching for and removing orphans...${RESET}"
        pacman -Qdtq | sudo pacman -Rns -
        ;;
    4)
        echo -e "${CYAN}Cleaning cache, keeping last 2 versions...${RESET}"
        sudo paccache -rk2
        ;;
    5)
        echo -e "${CYAN}Checking for corrupted files...${RESET}"
        sudo pacman -Qkk
        ;;
    6)
        echo -e "${CYAN}Displaying critical errors...${RESET}"
        journalctl -p 3 -xb
        ;;
    7)
        echo -e "${CYAN}Choose Snapshot Method:${RESET}"
        echo "a) Timeshift"
        echo "b) Btrfs manual"
        read -p "Selection: " SNAP
        if [ "$SNAP" == "a" ]; then
            sudo timeshift --create --comments "Pre-update snapshot"
        else
            sudo btrfs subvolume snapshot / /snapshots/$(date +%Y-%m-%d)
        fi
        ;;
    8)
        echo -e "${CYAN}Searching for .pacnew and .pacsave...${RESET}"
        find /etc -name "*.pacnew" -o -name "*.pacsave"
        echo -e "${PINK}Starting pacdiff...${RESET}"
        sudo pacdiff
        ;;
    9)
        exit 0
        ;;
    *)
        echo -e "${PINK}Invalid option.${RESET}"
        ;;
esac

echo -e "\n${PURPLE}Task completed.${RESET}"
read -p "Press enter to close..."
