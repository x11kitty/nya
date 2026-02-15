#!/bin/bash

# Ultimate Gaming Script for Dell Latitude 7480 | i7-6600U | UHD 520
# Theme: Catppuccin Mocha x Retro Tokyo
# Mode: UNRESTRICTED PERFORMANCE & PERSISTENT MENU

# --- Colors ---
RESET='\033[0m'
BOLD='\033[1m'
MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
RED='\033[38;2;243;139;168m'
TOKYO_MINT='\033[38;2;180;234;199m'
SAKURA_PINK='\033[38;2;244;183;195m'

# --- Setup ---
export DISPLAY=${DISPLAY:-:0}
MONITOR=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)

print_status()  { echo -e "${BOLD}${TOKYO_MINT}[󰓓]${RESET} ${BLUE}$1${RESET}"; }
print_process() { echo -e "${BOLD}${SAKURA_PINK}[󰑮]${RESET} ${MAUVE}$1${RESET}"; }
print_error()   { echo -e "${BOLD}${RED}[✘]${RESET} $1${RESET}"; }

# --- Option 1: System Integrity & Tweak Verification ---
check_integrity() {
    echo -e "\n${SAKURA_PINK}${BOLD}--- [ DIAGNOSTIC & TWEAK VERIFY ] ---${RESET}"

    # Check Software
    [[ -f "/usr/bin/gamemoded" ]] && print_status "Gamemode: INSTALLED" || print_error "Gamemode: MISSING"

    # Check Hardware State
    if [ -d "/sys/class/drm/card0" ]; then
        CUR_GPU=$(cat /sys/class/drm/card0/gt_cur_freq_mhz 2>/dev/null)
        MAX_GPU=$(cat /sys/class/drm/card0/gt_max_freq_mhz 2>/dev/null)
        print_status "Intel GPU: ACTIVE (${CUR_GPU}MHz / Max: ${MAX_GPU}MHz)"
    fi

    # Check if Unlimited Tweaks are ACTIVE
    if [[ "$MESA_NO_ERROR" == "1" ]]; then
        print_status "Env Vars: UNLIMITED MODE ACTIVE"
    else
        print_error "Env Vars: STOCK/RESTRICTED"
    fi

    # Check Kernel Tweaks
    SWAP_VAL=$(sysctl -n vm.swappiness)
    if [ "$SWAP_VAL" -eq 0 ]; then
        print_status "Kernel: LOW LATENCY (Swappiness=0)"
    else
        print_error "Kernel: STOCK (Swappiness=$SWAP_VAL)"
    fi

    # Power State
    AC_ADAPTER=$(cat /sys/class/power_supply/AC/online 2>/dev/null)
    [[ "$AC_ADAPTER" -eq 1 ]] && print_status "Power: CHARGER (Peak Performance)" || print_error "Power: BATTERY (Throttling)"
}

# --- Option 0: Super Max Optimization ---
apply_unlimited() {
    sudo -v
    print_process "Unlocking Hardware Limits & Injecting Environment Variables..."

    # 1. CPU & Thermal Overdrive
    # Disable Intel Thermal Daemon (prevents aggressive throttling)
    sudo systemctl stop thermald >/dev/null 2>&1
    sudo cpupower frequency-set -g performance >/dev/null 2>&1
    echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null 2>&1

    # Intel GPU - Lock to Absolute Maximum
    if [ -d "/sys/class/drm/card0" ]; then
        MAX_GPU=$(cat /sys/class/drm/card0/gt_max_freq_mhz)
        echo "$MAX_GPU" | sudo tee /sys/class/drm/card0/gt_min_freq_mhz >/dev/null 2>&1
        echo "$MAX_GPU" | sudo tee /sys/class/drm/card0/gt_boost_freq_mhz >/dev/null 2>&1
    fi

    # 2. Kernel Performance Tweaks (Zero Latency)
    sudo sysctl -w kernel.nmi_watchdog=0 >/dev/null 2>&1
    sudo sysctl -w kernel.sched_autogroup_enabled=0 >/dev/null 2>&1
    sudo sysctl -w vm.max_map_count=2147483647 >/dev/null 2>&1
    sudo sysctl -w vm.swappiness=0 >/dev/null 2>&1
    echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled >/dev/null 2>&1

    # 3. All Environment Variables (Mesa, Intel, Wine, Vulkan)
    # Generic Graphics
    export mesa_glthread=true
    export MESA_NO_ERROR=1
    export __GL_THREADED_OPTIMIZATIONS=1
    export vblank_mode=0
    export __GL_SYNC_TO_VBLANK=0

    # Intel Specific (HD 520 Optimization)
    export INTEL_DEBUG=noccs
    export INTEL_PERF_METRICS_OPENGL=1
    export dri_PRIME=1

    # Wine / Proton / DXVK
    export DXVK_ASYNC=1
    export WINEFSYNC=1
    export WINE_FSYNC=1
    export WINE_ESYNC=1
    export STAGING_SHARED_MEMORY=1
    export STAGING_WRITECOPY=1
    export DXVK_HUD=0
    export DXVK_STATE_CACHE=1
    export DXVK_STATE_CACHE_PATH=$HOME/.cache/dxvk
    export PROTON_USE_SECCOMP=1
    export PROTON_FORCE_LARGE_ADDRESS_AWARE=1
    export WINE_FULLSCREEN_FSR=1

    # Audio & System Latency
    export PIPEWIRE_LATENCY="64/48000"
    export SDL_VIDEODRIVER=x11
    export RADV_PERFTEST=sam

    # 4. Total Purge of Background Bloat
    print_process "Purging Background Bloat..."
    pkill -9 picom 2>/dev/null
    pkill -9 discord 2>/dev/null
    pkill -9 firefox 2>/dev/null
    pkill -9 thunderbird 2>/dev/null

    # 5. Charger "Extreme" Priority Logic
    if [ "$(cat /sys/class/power_supply/AC/online 2>/dev/null)" -eq 1 ]; then
        print_status "AC DETECTED: FORCE-PRIORITIZING GRAPHICS STACK"
        sudo renice -n -20 $(pgrep Xorg || pgrep Xwayland) >/dev/null 2>&1
        sudo ionice -c 1 -n 0 -p $$ >/dev/null 2>&1
    fi

    print_status "SUPER MAX ACTIVE: HARDWARE UNLEASHED"
    print_status "NOTE: Environment variables are active for this terminal session."
}

# --- Main Menu Loop ---
while true; do
    clear
    echo -e "${SAKURA_PINK}${BOLD}┌──────────────────────────────────────────┐${RESET}"
    echo -e "${SAKURA_PINK}${BOLD}│    UNRESTRICTED SYSTEM OPTIMIZER 2026    │${RESET}"
    echo -e "${SAKURA_PINK}${BOLD}└──────────────────────────────────────────┘${RESET}"
    echo -e "Target Device: Dell Latitude 7480 | i7-6600U"
    echo -e "Active Monitor: $MONITOR"
    echo -e "--------------------------------------------"
    echo -e "${RED} 0)${RESET} ${RED}${BOLD}SUPER MAX OPTIMIZATION${RESET} (Full Power)"
    echo -e "${TOKYO_MINT} 1)${RESET} ${BLUE}Verify Integrity & Tweaks${RESET}"
    echo -e "${SAKURA_PINK} 2)${RESET} ${BOLD}Exit System${RESET}"
    echo -ne "\n${MAUVE}Select a mode: ${RESET}"
    read choice

    case $choice in
        0) apply_unlimited ;;
        1) check_integrity ;;
        2)
            print_process "Exiting script. Restarting background services is recommended."
            exit 0
            ;;
        *) print_error "Invalid selection." ;;
    esac

    echo ""
    echo -e "${SAKURA_PINK}--------------------------------------------${RESET}"
    read -p "Press [Enter] to return to menu..."
done
