#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This file needs root permissions."
    exit 1
fi

#sudo pacman -Syu
#sudo pacman -S --needed base-devel git
#git clone https://aur.archlinux.org/yay.git ~/Desktop/
#cd yay
#makepkg -si
echo "condicion cumplida uwu"
