#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpaper"

selection=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -exec basename {} \; | sort | while read -r img; do
    echo -en "$img\0icon\x1f$WALLPAPER_DIR/$img\n"
done | rofi -dmenu -i -p "Gallery" \
    -show-icons \
    -theme-str '
        window {
            location:         center;
            anchor:           center;
            width:            750px;
            height:           650px;
            background-color: #00000080;
            border:           1px;
            border-color:     #ffffff15;
            border-radius:    12px;
        }
        mainbox {
            background-color: transparent;
            children:         [ listview ];
        }
        listview {
            background-color: transparent;
            columns:          4;
            lines:            4;           /* Forced 4 rows */
            fixed-columns:    true;
            fixed-height:     true;        /* Prevents Rofi from hiding rows */
            spacing:          5px;
            padding:          10px;
            scrollbar:        false;
            border:           0px;
        }
        element {
            background-color: transparent;
            orientation:      vertical;
            padding:          2px 0px;     /* Minimal padding to save space */
            spacing:          0px;
            border-radius:    8px;
        }
        element-icon {
            background-color: transparent;
            size:             125px;       /* Slightly smaller to ensure 4 rows fit */
            horizontal-align: 0.5;
        }
        element-text {
            background-color: transparent;
            text-color:       #ffffff;
            horizontal-align: 0.5;
            font:             "Sans 7";
            margin:           0px;
        }
        element selected {
            background-color: #ffffff12;
            border:           1px;
            border-color:     #ffffff20;
        }
    ')

if [ -n "$selection" ]; then
    feh --bg-fill "$WALLPAPER_DIR/$selection"
fi
