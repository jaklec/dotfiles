#!/bin/sh
while true; do
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$status" = "Charging" ]; then
        icon="🔌"
    elif [ "$capacity" -ge 80 ]; then
        icon="█"
    elif [ "$capacity" -ge 60 ]; then
        icon="▆"
    elif [ "$capacity" -ge 40 ]; then
        icon="▄"
    elif [ "$capacity" -ge 20 ]; then
        icon="▂"
    else
        icon="▁"
    fi

    wifi=$(iw dev wlan0 link 2>/dev/null)
    if echo "$wifi" | grep -q 'Connected'; then
        ssid=$(echo "$wifi" | grep 'SSID:' | sed 's/.*SSID: //')
        wifi_info="W: $ssid"
    else
        wifi_info="W: --"
    fi

    mem_used=$(free -m | awk '/Mem:/ {printf "%.1fG/%.1fG", $3/1024, $2/1024}')
    ip=$(ip -4 addr show wlan0 2>/dev/null | awk '/inet / {split($2,a,"/"); print a[1]}')
    [ -z "$ip" ] && ip="--"

    echo "IP: $ip | RAM: $mem_used | $wifi_info | $icon ${capacity}% | $(date +'%Y-%m-%d %X')"
    sleep 5
done
