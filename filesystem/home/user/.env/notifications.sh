#!/bin/sh

# Battery notifications

BATDEVICE=$(echo /sys/class/power_supply/$(ls /sys/class/power_supply/ | grep BAT))

while true; do
    capacity=$(cat "$BATDEVICE/capacity")
    status=$(cat "$BATDEVICE/status")
    if [ "$status" = "Discharging" ] || [ "$status" = "Not Charging" ]; then
        if [ "$capacity" -le  10 ]; then
            notify-send --urgency=critical "Batttery low!"
        fi
    else
        bat="Unknown status: $status"
    fi
    sleep 60
done &

last=$(cat "$BATDEVICE/status")
while true; do
    status=$(cat "$BATDEVICE/status")
    if [ "$status" = "Discharging" ] && [ "$last" != "Discharging" ]; then
        notify-send "Battery discharging"
    elif [ "$status" = "Charging" ] && [ "$last" != "Charging" ]; then
        notify-send "Battery Charging"
    fi
    last="$status"
    sleep 2
done &

# Check for system updates

# Check network connection before checking for updates
while ! ping -q -c 1 -W 1 ping.eu > /dev/null; do
    sleep 5
done

new_packages=$(yay -Qu | wc -l)
if [[ $new_packages -gt 0 ]]; then
    notify-send "Upates available!" 
fi

