#!/bin/bash

# POR SI FALLA EL SCRIPT SE CANCELA TODO
set -e

# pequenyos detalles
mkdir -p "$HOME/.config"


# ACTUALIZAR OS
echo "Actualizando OS..."
sudo pacman -Syu > /dev/null
echo "Sistema operativo actualizado con exito."
echo ""


# INSTALAR FUENTES
echo "Instalado fuentes..."
bash "./fonts/installer-fonts.sh"
echo "Las fuentes se han instalado con exito"
echo ""


# INSTALAR GIT
echo "Instalando git.."
sudo pacman -S --needed base-devel git --noconfirm > /dev/null
echo "Git se ha instalado con exito"
echo ""


# CONFIGURAR GIT (opcional)
read -p "Desea configurar git? Puede hacerlo manualmente luego... (yes/no) " GITCONFIG

if [[ "${GITCONFIG,,}" == "yes" ]]; then
	bash "./git-signature/create_signature.sh"
fi
echo ""


# INSTALAR YAY
echo "Instalando yay"
if ! command -v yay > /dev/null; then
	mkdir -p "./yay"
	git clone https://aur.archlinux.org/yay.git "./yay/"
	(
		cd "./yay/" || exit 1
		makepkg -si
	)
fi
echo "Yay se ha instalado con exito"
echo ""


# INSTALAR ZSH 
echo "Instalando ZSH..."
yay -S zsh --noconfirm > /dev/null
chsh -s /usr/bin/zsh
echo "ZSH se ha instalado con exito"
echo ""


# INSTALAR OH-MY-ZSH
echo "Instalando OH-MY-ZSH..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo "OH-MY-ZSH se ha instalado con exito."
echo ""


# INSTALAR PLUGINS PARA OH-MY-ZSH
echo "Instalando plugins para OH-MY-ZSH..."
ZSH_PATH="$HOME/.oh-my-zsh/custom/plugins"

if [[ ! -d "$ZSH_PATH/zsh-autosuggestions" ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PATH/zsh-autosuggestions/"
fi
if [[ ! -d "$ZSH_PATH/zsh-syntax-highlighting" ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PATH/zsh-syntax-highlighting/"
fi
echo "Plugins OH-MY-ZSH instalados con exito"
echo ""


# INSTALAR STARSHIP (opcional)
echo "Instalando starship..."
yay -S starship --noconfirm > /dev/null
starship preset pastel-powerline -o ~/.config/starship.toml
echo "Starship instalado con exito"
echo ""


# INSTALAR STOW
echo "Instalando stow..."
yay -S stow --noconfirm > /dev/null
echo "Stow se ha instalado con exito"
echo ""


# CONFIGURAR STOW
echo "Configurando Stow..."
if [[ -e "$HOME/.zshrc" ]]; then # .zshrc
	rm "$HOME/.zshrc"
fi
(
	cd "$HOME/dotfiles" 
	stow zsh
)

if [[ -e "$HOME/.config/kitty/kitty.conf" ]]; then # kitty
	rm "$HOME/.config/kitty/kitty.conf"
fi
(
	cd "$HOME/dotfiles" 
	stow kitty
)
echo "Stow configurado con exito"
echo ""


# Aplicaciones extra
echo "Instalando paquetes de ayuda... (lsd, neovim)"
yay -S lsd --noconfirm > /dev/null
sudo yay -S neovim --noconfirm > /dev/null
echo "Paquetes de ayuda instalados con exito"
echo ""

# Informar de la instalacion exitosa
echo "---------------------------------"
echo "Instalacion completada con exito!"
echo "Por favor reinicie su terminal o ejecute 'zsh'"
echo "Tenga en cuento que algunas de estas configuraciones necesitan un reinicio, por favor reinicie el ordenador."
