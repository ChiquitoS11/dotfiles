#!/bin/bash

set -e

KEY="id_ed25519"
KEY_PATH="$HOME/.ssh/$KEY"


# Comprobar dependencias
if ! command -v git > /dev/null; then
	echo "Git no esta instalado"
	exit 1
fi

if ! command -v ssh-keygen > /dev/null ; then
	echo "ssh-keygen no esta instalado"
	exit 1
fi

echo "Todas las dependencias han sido encontradas (git, ssh-keygen)"


# Configurando git
read -p "Name: " NAME
read -p "Email: " EMAIL

echo "Name: $NAME"
echo "Email: $EMAIL"
echo "Si esta mal, parar script y volver a ejecutar"
sleep 8 # Pausar unos segundos por si el usuario quiere cancelar

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"


# Creando el SSH
echo "Creando SSH..."

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$KEY_PATH" ]]; then
	ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
else
	echo "Clave SSH existente..."
fi


# Configurando SSH
echo "Configurando SSH..."
git config --global gpg.format ssh
git config --global user.signingkey "$KEY_PATH.pub"
git config --global commit.gpgsign true


echo "---------------------------------------------------------------------------------------"
echo "CONFIGURACION COMPLETADA."
echo "Pegar el siguiente codigo en el ssh de su GitHub."
cat "$KEY_PATH.pub"
