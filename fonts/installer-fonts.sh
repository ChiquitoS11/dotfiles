#!/bin/bash

exec > /dev/null 2>&1
set -e

FONTS=(
	"Agave"
	"Gohu"
	"JetBrainsMono"
	"FiraCode"
	"Hack"
	"CascadiaCode"
	"UbuntuMono"
	"Hermit"
)

BASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
FONT_ROOT="$HOME/.local/share/fonts"
TMP_BASE="/tmp/nerd-fonts"

mkdir -p "$FONT_ROOT" "$TMP_BASE"

for FONT in "${FONTS[@]}"; do
    FONT_DIR="$FONT_ROOT/$FONT"

    if [ -d "$FONT_DIR" ] && ls "$FONT_DIR"/*.ttf >/dev/null 2>&1; then
        continue
    fi

    TMP_DIR="$TMP_BASE/$FONT"
    mkdir -p "$TMP_DIR"


    if ! curl -fL "$BASE_URL/$FONT.zip" -o "$TMP_DIR/$FONT.zip"; then
        rm -rf "$TMP_DIR"
        continue
    fi


    unzip -q "$TMP_DIR/$FONT.zip" -d "$TMP_DIR"

    mkdir -p "$FONT_DIR"
    find "$TMP_DIR" \( -name "*.ttf" -o -name "*.otf" \) -exec cp -n {} "$FONT_DIR" \;

    rm -rf "$TMP_DIR"
done


# ---- Miracode ----
MIRACODE_DIR="$FONT_ROOT/Miracode"
MIRACODE_URL="https://github.com/IdreesInc/Miracode/releases/download/v1.0/Miracode.ttf"

if [ ! -f "$MIRACODE_DIR/Miracode.ttf" ]; then
    mkdir -p "$MIRACODE_DIR"
    curl -fL "$MIRACODE_URL" -o "$MIRACODE_DIR/Miracode.ttf"
fi


fc-cache -f
