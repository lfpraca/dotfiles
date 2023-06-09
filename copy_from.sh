#!/bin/sh
cd "$(dirname "$0")" || exit

cp /usr/src/linux/.config kernel/.config
cp $HOME/.emacs.d/init.el emacs/init.el
cp $HOME/.config/i3/config i3/config
cp $HOME/.config/polybar/config.ini polybar/config.ini
cp $HOME/.config/polybar/launch.sh polybar/launch.sh
cp /etc/X11/xorg.conf.d/00-keyboard.conf xorg/00-keyboard.conf
cp $HOME/.Xresources .Xresources
cp $HOME/.gtkrc-2.0 .gtkrc-2.0
cp $HOME/.config/gtk-3.0/settings.ini gtk-3.0/settings.ini
