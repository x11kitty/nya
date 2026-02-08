#!/bin/bash

# --- Color Palette (Tokyo Night / Mocha) ---
export FZF_DEFAULT_OPTS='
  --color=bg+:#24283b,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#9ece6a,info:#7dcfff,pointer:#7aa2f7
  --color=marker:#9ece6a,fg+:#e0af68,prompt:#bb9af7,hl+:#7aa2f7
  --color=border:#565f89,label:#ff9e64,query:#c0caf5
'

C_BLUE='\033[38;5;111m'
C_MAGENTA='\033[38;5;176m'
C_CYAN='\033[38;5;120m'
C_RED='\033[38;5;167m'
C_GREY='\033[38;5;243m'
C_BOLD='\033[1m'
NC='\033[0m'

# 1. Fast System Info Fetch
INTERFACE=$(nmcli -t -f DEVICE,TYPE device | grep :wifi | cut -d: -f1 | head -n1)
CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
[ -z "$CURRENT_SSID" ] && CURRENT_SSID="Disconnected"
HOST_NAME=$(hostname) # Fetch system hostname

# 2. Optimized Scan Function (Cached for Instant Opening)
get_list() {
    nmcli -t -f "BARS,SIGNAL,SSID" device wifi list | awk -F: '
    /^[ \t]*$/ {next}
    $3 != "" {
        sig=$2;
        if(sig > 70) col="\033[32m";
        else if(sig > 40) col="\033[33m";
        else col="\033[31m";
        printf "%s %s%-3s%% \033[0m %s\n", $1, col, sig, $3
    }' | sort -u
}

# 3. Background Rescan (Hardware scans while you view the list)
(nmcli device wifi rescan >/dev/null 2>&1 &)

# 4. Main Interface
clear
echo -e "${C_MAGENTA}${C_BOLD} 󰀝 NETWORK_OS v2.0${NC}"
# Added $HOST_NAME to the system info line
echo -e "${C_GREY} 󰒋 $HOST_NAME  󱘖 $INTERFACE  󰩟 $(hostname -I | awk '{print $1}')  󱚽 $CURRENT_SSID${NC}\n"

selection=$(get_list | fzf \
    --ansi \
    --header "󰄵 [Enter] Connect  [Ctrl-R] Manual Rescan" \
    --prompt " SHIFT_JIS > " \
    --bind "ctrl-r:reload(nmcli device wifi list --rescan yes > /dev/null && get_list)" \
    --height=15 \
    --reverse \
    --border=rounded \
    --inline-info \
    --pointer="󰁔" \
    --marker="󰄬 ")

[ -z "$selection" ] && exit 0

# Extract SSID
chosen_ssid=$(echo "$selection" | sed -E 's/^.{14}//')

# 5. Connection Logic
clear
echo -e "${C_BLUE}${C_BOLD}󱚽 HANDSHAKE: ${NC}$chosen_ssid"

if nmcli -t -f NAME connection show | grep -qx "$chosen_ssid"; then
    echo -e "${C_GREY}Using existing profile...${NC}"
    nmcli connection up "$chosen_ssid" --timeout 10
else
    while true; do
        echo -e "${C_GREY}Security key required for uplink...${NC}"
        read -rs -p "  󰷈  Password: " pass
        echo -e "\n${C_CYAN}Analysing handshake...${NC}"

        if nmcli --ask no device wifi connect "$chosen_ssid" password "$pass" > /dev/null 2>&1; then
            break
        else
            echo -e "${C_RED}${C_BOLD}󰅙 ERROR: WRONG PASSWORD${NC}"
            echo -e "${C_GREY}Please re-enter credentials.${NC}\n"
        fi
    done
fi

# 6. Result
NEW_IP=$(hostname -I | awk '{print $1}')
echo -e "${C_CYAN}Done! Local IP: ${C_BOLD}${NEW_IP:-None}${NC}"
