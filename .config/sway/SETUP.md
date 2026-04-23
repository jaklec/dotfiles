# Sway Setup Guide

## Prerequisites

```
sudo pacman -S sway swaylock-effects swayidle brightnessctl fuzzel foot mako grim
```

## Idle: Screen Lock and Display Off

Configured via `swayidle` in the sway config.

**Behavior:**
- After 5 minutes (300s) of inactivity: screen locks with swaylock
- After 6 minutes (360s) of inactivity: screen goes dark (brightness 0)
- On resume: brightness restores to previous level
- Before sleep: screen locks

**Config (in sway config):**
```
exec swayidle -w \
    timeout 300 'swaylock -f --screenshots --indicator --effect-blur 7x5' \
    timeout 360 'brightnessctl -s set 0' resume 'brightnessctl -r' \
    before-sleep 'swaylock -f --screenshots --indicator --effect-blur 7x5'
```

**Why brightness instead of `output * power off`:**
On AMD GPUs, `swaymsg "output * power off"` can make the screen impossible to wake without a reboot. Using `brightnessctl` to set brightness to 0 achieves the same visual effect and always recovers.

**Why no `--clock` in swayidle's swaylock:**
swaylock-effects with `--clock` redraws every second, which prevents the display-off timeout from working. The manual lock keybind (`$mod+Escape`) still uses `--clock` since there's no display-off to interfere with.

## Automatic Brightness on AC/Battery

A udev rule triggers `~/.config/sway/power-brightness.sh` on plug/unplug events. The same script runs at sway startup.

**Behavior:**
- On AC: brightness set to 100%
- On battery: brightness set to 60%
- Manual adjustment with brightness keys still works anytime

### Setup

1. Create the script at `~/.config/sway/power-brightness.sh`:

```sh
#!/bin/sh
if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
    brightnessctl set 100%
else
    brightnessctl set 60%
fi
```

```
chmod +x ~/.config/sway/power-brightness.sh
```

2. Create the udev rule at `/etc/udev/rules.d/90-brightness-power.rules`:

```
SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/home/jakob/.config/sway/power-brightness.sh"
SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/home/jakob/.config/sway/power-brightness.sh"
```

```
sudo cp /tmp/90-brightness-power.rules /etc/udev/rules.d/90-brightness-power.rules
sudo udevadm control --reload-rules
```

3. Add to sway config (runs on login):

```
exec ~/.config/sway/power-brightness.sh
```

## Notes

- The backlight device is at `/sys/class/backlight/amdgpu_bl1` (may differ on other machines)
- AC power status is at `/sys/class/power_supply/AC/online` (check with `ls /sys/class/power_supply/` on other machines — the name may differ)
- `power-profiles-daemon` handles CPU/GPU power profiles separately
