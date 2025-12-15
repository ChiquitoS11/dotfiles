#!/bin/bash

# POR SI FALLA EL SCRIPT SE CANCELA TODO
set -e

# pequenyos detalles
mkdir -p "$HOME/.config"


# ACTUALIZAR OS
sudo pacman -Syu > /dev/null
echo "Sistema operativo actualizado con exito."


# INSTALAR GIT
sudo pacman -S --needed base-devel git --noconfirm > /dev/null
echo "Instalacion de git completada con exito"


# CONFIGURAR GIT (opcional)
read -p "Desea configurar git? Puede hacerlo manualmente luego... (yes/no) " GITCONFIG

if [[ "${GITCONFIG,,}" == "yes" ]]; then
	bash "./git-signature/create_signature.sh"
fi


# INSTALAR YAY
if ! command -v yay > /dev/null; then
	mkdir -p "./yay"
	git clone https://aur.archlinux.org/yay.git "./yay/"
	(
		cd "./yay/" || exit 1
		makepkg -si
	)
fi


# INSTALAR ZSH 
yay -S zsh --noconfirm > /dev/null
chsh -s /usr/bin/zsh


# INSTALAR OH-MY-ZSH
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo "oh-my-zsh se ha instalado con exito."

# INSTALAR PLUGINS PARA OH-MY-ZSH
ZSH_PATH="$HOME/.oh-my-zsh/custom/plugins"

if [[ ! -d "$ZSH_PATH/zsh-autosuggestions" ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PATH/zsh-autosuggestions/"
fi
if [[ ! -d "$ZSH_PATH/zsh-syntax-highlighting" ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PATH/zsh-syntax-highlighting/"
fi
echo "Plugins instalados con exito"

# INSTALAR STARSHIP (opcional)
yay -S starship --noconfirm > /dev/null
starship preset pastel-powerline -o ~/.config/starship.toml


# INSTALAR STOW
yay -S stow --noconfirm > /dev/null


# CONFIGURAR STOW
if [[ ! -e "$HOME/.zshrc" ]]; then # .zshrc
	rm "$HOME/.zshrc"
fi
(
	cd "$HOME/dotfiles" 
	stow zsh
)

if [[ ! -e "$HOME/.config/kitty/kitty.conf" ]]; then # kitty
	rm "$HOME/.config/kitty/kitty.conf"
fi
(
	cd "$HOME/dotfiles" 
	stow kitty
)

rm ~/.config/kitty/kitty.conf
(
	cd "$HOME

# Aplicaciones extra
yay -S lsd --noconfirm > /dev/null
sudo yay -S neovim


# Informar de la instalacion exitosa
echo "---------------------------------"
echo "Instalacion completada con exito!"
echo "Por favor reinicie su terminal o ejecute 'zsh' (Algunas configuraciones necesitan reinicio del sistema)"
