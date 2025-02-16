#!/bin/bash
echo "install my cool hyprland setup?[y/n]"
scriptdir=$(dirname $(dirname $0))
echo $scriptdir
read answ
if [[ $answ == "y" ]]; then
	sudo pacman -Syu hyprland fuzzel waybar alacritty dunst nwg-look firefox gedit nautilus pavucontrol pipewire pipewire-pulse pipewire-alsa font-manager base-devel gtk3 gtk4 qt5-wayland qt6-wayland mpv fastfetch file-roller gnome-disk-utility playerctl gnome-calculator shotwell xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper hyprcursor networkmanager adw-gtk-theme mc nano network-manager-applet unzip wpa_supplicant flatpak wireplumber
	echo "installing fonts"
	sudo pacman -S cantarell-fonts ttf-font-awesome ttf-nerd-fonts-symbols noto-fonts ttf-fira-code
	#cp $scriptdir/dotfiles $HOME
	if lspci | grep -i nvidia; then
		echo "Nvidia GPU detected. Running Nvidia patch script..."    
   	 	$scriptdir/setup/nvidia-setup.sh
	fi	
else
	echo "aborting:("
	exit
fi
