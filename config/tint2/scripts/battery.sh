#!/bin/bash
ICON_BASE_PATH=/home/$USER/.mark/config/tint2/icons
STATUS=$(cat /sys/class/power_supply/CMB0/status)
CHARGE=$(cat /sys/class/power_supply/CMB0/capacity)

if [ "$STATUS" = "Discharging" ]; then
  if [ "$CHARGE" -lt "10" ]; then
    echo "$ICON_BASE_PATH/battery-010.svg"
  elif [ "$CHARGE" -lt "20" ]; then
    echo "$ICON_BASE_PATH/battery-020.svg"
  elif [ "$CHARGE" -lt "30" ]; then
    echo "$ICON_BASE_PATH/battery-030.svg"
  elif [ "$CHARGE" -lt "40" ]; then
    echo "$ICON_BASE_PATH/battery-040.svg"
  elif [ "$CHARGE" -lt "50" ]; then
    echo "$ICON_BASE_PATH/battery-050.svg"
  elif [ "$CHARGE" -lt "60" ]; then
    echo "$ICON_BASE_PATH/battery-060.svg"
  elif [ "$CHARGE" -lt "70" ]; then
    echo "$ICON_BASE_PATH/battery-070.svg"
  elif [ "$CHARGE" -lt "80" ]; then
    echo "$ICON_BASE_PATH/battery-080.svg"
  elif [ "$CHARGE" -lt "90" ]; then
    echo "$ICON_BASE_PATH/battery-090.svg"
  elif [ "$CHARGE" -eq "100" ]; then
    echo "$ICON_BASE_PATH/battery-100.svg"
  fi
fi

if [ "$STATUS" = "Charging" ]; then
fi
