#!/bin/sh
cd "$(dirname "$0")" || exit

cp /usr/src/linux/.config kernel/.config
cp $HOME/.emacs.d/init.el emacs/init.el
cp $HOME/.config/i3/config i3/config
