#!/bin/bash

# --- Retro Tokyo Color Palette ---
PINK='\033[38;5;205m'
PURPLE='\033[38;5;93m'
CYAN='\033[38;5;51m'
BG_DARK='\033[48;5;234m'
RESET='\033[0m'
BOLD='\033[1m'

# [cite_start]Get the default display name [cite: 1]
DISPLAY_NAME=$(xrandr | grep " connected" | cut -d' ' -f1 | head -n 1)

clear
echo -e "${PURPLE}==========================================${RESET}"
echo -e "${PINK}${BOLD}    DISPLAY SETTINGS      ${RESET}"
echo -e "${CYAN}   Active Display: $DISPLAY_NAME${RESET}"
echo -e "${PURPLE}==========================================${RESET}"
echo -e "${CYAN}1)${RESET} Set Resolution & Refresh Rate"
echo -e "${CYAN}2)${RESET} Stretch Screen (Full Scaling)"
echo -e "${CYAN}3)${RESET} Apply Scaling (e.g., 1.5x1.5)"
echo -e "${CYAN}4)${RESET} Intel-Style Scale-From"
echo -e "${CYAN}5)${RESET} Exit"
echo -e "${PURPLE}==========================================${RESET}"
echo -ne "${PINK}Select an option [1-5]: ${RESET}"
read CHOICE

case $CHOICE in
    1)
        echo -ne "${CYAN}Enter Resolution (e.g., 1920x1080): ${RESET}"
        read RES
        echo -ne "${CYAN}Enter Refresh Rate (e.g., 60): ${RESET}"
        read RATE
        # [cite_start]Sets resolution and rate [cite: 1]
        xrandr --output "$DISPLAY_NAME" --mode "$RES" --rate "$RATE"
        ;;
    2)
        # [cite_start]Sets scaling mode to Full [cite: 1]
        xrandr --output "$DISPLAY_NAME" --set "scaling mode" "Full"
        echo -e "${PINK}Scaling mode set to Full.${RESET}"
        ;;
    3)
        echo -ne "${CYAN}Enter Scale Factor (e.g., 1.5x1.5): ${RESET}"
        read SCALE
        # [cite_start]Applies specific scale factor [cite: 1]
        xrandr --output "$DISPLAY_NAME" --scale "$SCALE"
        ;;
    4)
        echo -ne "${CYAN}Enter Mode (e.g., 1024x768): ${RESET}"
        read MODE
        # [cite_start]Mimics intelgfxcmdcenter behavior [cite: 1]
        xrandr --output "$DISPLAY_NAME" --mode "$MODE" --scale-from "$MODE"
        ;;
    5)
        exit 0
        ;;
    *)
        echo -e "${PINK}Invalid option.${RESET}"
        ;;
esac

echo -e "\n${PURPLE}Apply complete.${RESET}"
[cite_start]echo -e "${CYAN}Copy your command to ${BOLD}~/.config/bspwm/bspwmrc${RESET}${CYAN} for persistence. [cite: 1]${RESET}"
sleep 2
