#!/bin/sh
# Force display back on after suspend resume on AMD
# Log everything for debugging
exec >> /tmp/sway-resume.log 2>&1
echo "=== Resume at $(date) ==="

sleep 1

# Method 1: toggle output off/on to force re-init
swaymsg output eDP-1 power off
sleep 0.2
swaymsg output eDP-1 power on

# Method 2: disable/enable to force full modeset
sleep 0.5
swaymsg output eDP-1 disable
sleep 0.2
swaymsg output eDP-1 enable

echo "=== Done ==="
