#!/bin/bash

root_dir=$(pwd)

# PKGS FOR DE

PKGS=(
  xorg-server
  xorg-xinit
  xorg-xkill
  xorg-xev
  xdg-utils
  xorg-xsetroot
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xclip
  alacritty
  gvfs
  udiskie
  btop
  pulsemixer
  networkmanager
  light
  arc-solid-gtk-theme
  arc-icon-theme
  ttf-dejavu
  bluez
  bluez-utils
  man-db
  arandr
  dunst
  xf86-input-synaptics
  pipewire-pulse
  dialog
  libnotify
  slock
  pcmanfm
  xarchiver
  flameshot
  feh
  neovim
  ttf-jetbrains-mono-nerd
  nano
  rate-mirrors-bin
  ufw
)

fc-cache -fv

sudo pacman -S --needed --noconfirm base-devel git which

# INSTALL yay

which yay || (
  cd $HOME
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  yay --save --nocleanmenu --nodiffmenu
  cd $root_dir
)

# UPDATE SYSTEM

yay --noconfirm

# INSTALL PKGS

for PKG in ${PKGS[@]}; do
    yay -S --needed --noconfirm $PKG
done

# OPTIONAL: Printing/scanning support

if dialog --yesno "Do you want printing/scanning support?" 7 50; then
    for PKG in cups sane sane-airscan ipp-usb xsane; do
        yay -S --needed --noconfirm $PKG
    done
    sudo systemctl enable cups.service
    sudo systemctl enable ipp-usb.service
fi

# ENABLE SERVICES

sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable ufw.service

sudo ufw enable
sudo rfkill unblock bluetooth

# add user to group video to control backlight with program light

sudo gpasswd -a $USER video

# COPY CONFIGURATION FILES

cp -r filesystem/home/user/. $HOME
sudo cp filesystem/etc/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/

# BUILD dwm and dmenu

cd $HOME/dwm
sudo make clean install
cd $HOME/dmenu
sudo make clean install

echo
echo "Finished! Reboot."
