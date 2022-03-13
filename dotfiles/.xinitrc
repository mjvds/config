#!/bin/bash
xrdb "/home"~/.Xresources
exec bspwm -c "/home/$USER/.mark/dotfiles/config/bspwm/bspwmrc"
