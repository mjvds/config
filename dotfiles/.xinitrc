#!/bin/bash
xrdb /home/$USER/.mark/dotfiles/.Xresources
exec bspwm -c "/home/$USER/.mark/dotfiles/config/bspwm/bspwmrc"
