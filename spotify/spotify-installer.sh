#!/bin/bash

# Cerrar script si falla algo
set -e

# Instalar spotify normal
yay -S spotify --noconfirm > /dev/null

# Abrir Spotify en background y esperar inicialización
spotify & 
SPOTIFY_PID=$!
sleep 5  # Tiempo para que se cree ~/.config/spotify/prefs
echo "Spotify PID: $SPOTIFY_PID - Esperando inicialización..."

# Instalar Spicetify
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

# Por alguna razón necesitas esto :v
sudo chmod a+wr /opt/spotify
sudo chmod a+wr -R /opt/spotify/Apps

# Recargar spicetify por si las dudas
spicetify apply

# Cerrar el spotify abierto
kill "$SPOTIFY_PID"
