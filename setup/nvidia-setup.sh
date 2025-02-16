#!/bin/bash

# Define environment variables for Hyprland
ENV_VARS="env = LIBVA_DRIVER_NAME,nvidia"
ENV_VARS_GLX="env = __GLX_VENDOR_LIBRARY_NAME,nvidia"

# Define the modprobe options to add for Nvidia
MODPROBE_OPTIONS="options nvidia_drm modeset=1 fbdev=1"

# Path to the modprobe configuration for Nvidia
MODPROBE_CONF="/etc/modprobe.d/nvidia.conf"

# Define the Nvidia modules to add to mkinitcpio
NVIDIA_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

# Path to the mkinitcpio configuration file
MKINITCONF="/etc/mkinitcpio.conf"

# Path to the Hyprland configuration file
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"

# Backup mkinitcpio.conf file before editing
cp $MKINITCONF ${MKINITCONF}.bak

# Check if the Nvidia modules are already present in the MODULES line
if ! grep -q "MODULES=.*nvidia.*" $MKINITCONF; then
    # If not, append them to the MODULES line
    sed -i "/^MODULES=/s/()/($NVIDIA_MODULES)/" $MKINITCONF
    echo "Nvidia modules added to $MKINITCONF"
else
    echo "Nvidia modules already present in $MKINITCONF"
fi

# Regenerate the initramfs
echo "Regenerating initramfs..."
sudo mkinitcpio -P

# Optionally, install Nvidia drivers if not installed
if ! pacman -Qs nvidia > /dev/null; then
    echo "Installing Nvidia drivers..."
    sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland
else
    echo "Nvidia drivers already installed."
fi

# Check if the modprobe options are present, and add them if not
if ! grep -q "nvidia_drm modeset=1 fbdev=1" "$MODPROBE_CONF"; then
    # If not, add the options to the file
    echo "$MODPROBE_OPTIONS" | sudo tee -a "$MODPROBE_CONF" > /dev/null
    echo "Modprobe options added to $MODPROBE_CONF"
else
    echo "Modprobe options already present in $MODPROBE_CONF"
fi

# Check if the Hyprland environment variables are present, and add them if not
if ! grep -q "$ENV_VARS" "$HYPRLAND_CONF"; then
    # If not, add the environment variable to the file
    echo "$ENV_VARS" | tee -a "$HYPRLAND_CONF" > /dev/null
    echo "$ENV_VARS added to $HYPRLAND_CONF"
else
    echo "$ENV_VARS already exists in $HYPRLAND_CONF"
fi

if ! grep -q "$ENV_VARS_GLX" "$HYPRLAND_CONF"; then
    # If not, add the environment variable to the file
    echo "$ENV_VARS_GLX" | tee -a "$HYPRLAND_CONF" > /dev/null
    echo "$ENV_VARS_GLX added to $HYPRLAND_CONF"
else
    echo "$ENV_VARS_GLX already exists in $HYPRLAND_CONF"
fi

echo "Patched Sucessfuly enjoy your nvidia GPU)"
