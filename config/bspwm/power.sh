#!/bin/bash

# Configuration
ICON_DIR="/usr/share/wlogout/icons"
BG_COLOR="#00000080"

# Define options with Rofi-specific icon syntax
options="Lock\0icon\x1f$ICON_DIR/lock.png\n\
Logout\0icon\x1f$ICON_DIR/logout.png\n\
Suspend\0icon\x1f$ICON_DIR/suspend.png\n\
Hibernate\0icon\x1f$ICON_DIR/hibernate.png\n\
Reboot\0icon\x1f$ICON_DIR/reboot.png\n\
Shutdown\0icon\x1f$ICON_DIR/shutdown.png"

# Launch Rofi
selected=$(echo -e "$options" | rofi -dmenu -i -p "Power" \
    -show-icons \
    -theme-str '
        window {
            location:         east;
            anchor:           east;
            x-offset:         -15px;
            width:            125px;
            height:           610px;
            background-color: '$BG_COLOR';
            border:           1px;
            border-color:     #ffffff15;
            border-radius:    15px;
        }
        mainbox {
            background-color: transparent;
            children:         [ listview ];
            padding:          0px;
        }
        listview {
            background-color: transparent;
            columns:          1;
            lines:            6;
            fixed-height:     true;
            fixed-columns:    true;
            spacing:          0px;
            padding:          10px 0px;
            scrollbar:        false;
            border:           0px;
        }
        element {
            background-color: transparent;
            orientation:      vertical;
            padding:          12px 0px;
            border-radius:    10px;
            margin:           2px 5px;
        }
        element-icon {
            background-color: transparent;
            size:             45px;
            horizontal-align: 0.5;
        }
        element-text {
            background-color: transparent;
            text-color:       #ffffff;
            horizontal-align: 0.5;
            font:             "Sans 8";
        }
        element selected {
            background-color: #ffffff15;
            border:           1px;
            border-color:     #ffffff20;
        }
    ')

# Logic handling
case "$selected" in
    *Lock)
        # Tries hyprlock, then swaylock, then falls back to loginctl
        if command -v hyprlock >/dev/null; then
            hyprlock
        elif command -v swaylock >/dev/null; then
            swaylock
        else
            loginctl lock-session
        fi
        ;;
    *Logout)
        # terminate-user is more reliable than terminate-session for scripts
        loginctl terminate-user "$USER"
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Hibernate)
        systemctl hibernate
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
esac
