#!/bin/sh
# Adjust brightness based on AC/battery state
if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
    brightnessctl set 100%
else
    brightnessctl set 60%
fi
