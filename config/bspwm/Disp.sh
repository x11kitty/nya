#!/bin/bash

# --- The G.O.A.T. Dracula Palette ---
BG='\033[48;5;235m'
FG='\033[38;5;231m'
PURPLE='\033[38;5;141m'
CYAN='\033[38;5;117m'
PINK='\033[38;5;212m'
GREEN='\033[38;5;84m'
ORANGE='\033[38;5;215m'
RED='\033[38;5;203m'
RESET='\033[0m'
BOLD='\033[1m'

# Get the default display name
DISPLAY_NAME=$(xrandr | grep " connected" | cut -d' ' -f1 | head -n 1)

clear
echo -e "${PURPLE}      ___           ___           ___           ___     ${RESET}"
echo -e "${PURPLE}     /  /\         /  /\         /  /\         /  /\    ${RESET}"
echo -e "${CYAN}    /  /::\       /  /::\       /  /:/_       /  /::\   ${RESET}"
echo -e "${CYAN}   /  /:/\:\     /  /:/\:\     /  /:/ /\     /  /:/\:\  ${RESET}"
echo -e "${PINK}  /  /:/  \:\   /  /:/  \:\   /  /:/ /:/_   /  /:/~/:/  ${RESET}"
echo -e "${PINK} /__/:/ \__\:\ /__/:/ \__\:\ /__/:/ /:/ /\ /__/:/ /:/   ${RESET}"
echo -e "${ORANGE} \  \:\ /  /:/ \  \:\ /  /:/ \  \:\/:/ /:/ \  \:\/:/    ${RESET}"
echo -e "${ORANGE}  \  \:\  /:/   \  \:\  /:/   \  \::/ /:/   \  \::/     ${RESET}"
echo -e "${RED}   \  \:\/:/     \  \:\/:/     \  \:\/:/     \  \:\     ${RESET}"
echo -e "${RED}    \  \::/       \  \::/       \  \::/       \  \:\    ${RESET}"
echo -e "${RED}     \__\/         \__\/         \__\/         \__\/    ${RESET}"
echo ""
echo -e "  ${BOLD}${FG}SYSTEM INTERFACE${RESET} ${PURPLE}>>${RESET} ${CYAN}${BOLD}XRANDR_ENGINE${RESET}"
echo -e "  ${BOLD}${FG}ACTIVE_TARGET${RESET}    ${PURPLE}>>${RESET} ${PINK}${BOLD}$DISPLAY_NAME${RESET}"
echo -e "${PURPLE}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${BOLD}${CYAN}01${RESET} ${FG}󰑭 SET RESOLUTION & HZ${RESET}"
echo -e "  ${BOLD}${CYAN}02${RESET} ${FG}󰊓 STRETCH (FULL SCALE)${RESET}"
echo -e "  ${BOLD}${CYAN}03${RESET} ${FG}󰆾 CUSTOM SCALE FACTOR${RESET}"
echo -e "  ${BOLD}${CYAN}04${RESET} ${FG}󱎔 INTEL SCALE-FROM${RESET}"
echo -e "  ${BOLD}${RED}05${RESET} ${FG}󰈆 TERMINATE SCRIPT${RESET}"
echo ""
echo -e "${PURPLE}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -ne "  ${BOLD}${PINK}λ${RESET} ${FG}Execute command: ${RESET}"
read CHOICE

case $CHOICE in
    1)
        echo -ne "\n  ${CYAN}󰑭 Mode (e.g. 1920x1080): ${RESET}"
        read RES
        echo -ne "  ${CYAN}󱥸 Rate (e.g. 144): ${RESET}"
        read RATE
        # Sets resolution and rate
        xrandr --output "$DISPLAY_NAME" --mode "$RES" --rate "$RATE"
        ;;
    2)
        # Sets scaling mode to Full
        xrandr --output "$DISPLAY_NAME" --set "scaling mode" "Full"
        echo -e "\n  ${GREEN}󰄬 Buffer updated to Full Stretch.${RESET}"
        ;;
    3)
        echo -ne "\n  ${CYAN}󰆾 Factor (e.g. 1.25x1.25): ${RESET}"
        read SCALE
        # Applies specific scale factor
        xrandr --output "$DISPLAY_NAME" --scale "$SCALE"
        ;;
    4)
        echo -ne "\n  ${CYAN}󰊓 Base Mode (e.g. 1280x960): ${RESET}"
        read MODE
        # Mimics intelgfxcmdcenter behavior
        xrandr --output "$DISPLAY_NAME" --mode "$MODE" --scale-from "$MODE"
        ;;
    5)
        echo -e "  ${RED}Shutting down...${RESET}"
        exit 0
        ;;
    *)
        echo -e "\n  ${RED}󰀦 FATAL: Selection out of bounds.${RESET}"
        ;;
esac

echo -e "\n  ${GREEN}${BOLD}CORE SYNC COMPLETE.${RESET}"
# Persistence hint
echo -e "  ${COMMENT}Add to bspwmrc for persistence.${RESET}"
sleep 1.5
