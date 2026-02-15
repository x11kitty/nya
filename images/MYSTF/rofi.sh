#!/bin/bash

# 1. Extract wallpaper path
WALLPAPER=$(grep -oP "'.*?'" ~/.fehbg | head -1 | tr -d "'")

# 2. Precise Crop + Resize
# We crop your area, then resize it to 800px width so it fits the Rofi panel easily
magick "$WALLPAPER" -crop 1826x2158+980+2 -resize 380x "$HOME/.config/rofi/current_wallpaper.jpg"

# 3. Launch Rofi
rofi -show drun
