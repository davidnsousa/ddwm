#!/bin/sh

WIFIDEVICE=$(nmcli device status | awk '$2=="wifi"{print $1}')
BATDEVICE=$(echo /sys/class/power_supply/$(ls /sys/class/power_supply/ | grep BAT))

while true; do

    #Sound

    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$mute" = "yes" ]; then
        sound="Mute"
    else
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
        sound="$volume"
    fi


    #cpu

    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%d%%", 100 - $8}')
    
    #ram
    
    ram=$(free | awk '/Mem/ {printf "%d%%", $3/$2 * 100}')

    #bluetooth
    
    connection=$(bluetoothctl show | grep -q "Powered: yes" && echo "On" || echo "Off")
    device=$(bluetoothctl info | grep -q "Connected: yes" && bluetoothctl info | grep -o 'Name:.*' | sed 's/Name: //')
    if [ "$device" != "" ]; then
        bluetooth="↑ $device"
    else
        if [ "$connection" = On ]; then
            bluetooth="↑"
        else
            bluetooth="↓"
        fi
    fi

    #wifi
    
    connection=$(nmcli -t -f type,device,state connection show | grep wireless | grep activated > /dev/null && echo "up" || echo "down")
    ssid=$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d: -f2)
    adress=$(ip -4 address show dev $WIFIDEVICE | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}' | cut -d/ -f1)
    signal=$(nmcli -f IN-USE,SIGNAL device wifi | grep \* | awk '{print $2}')
    if [ "$connection" = "up" ]; then
        wifi="↑ $signal% $ssid $adress"
    else
        if [ "$(nmcli networking | grep enabled)" = "enabled" ] && [ "$(nmcli radio wifi | grep enabled)" = "enabled" ]; then
                wifi="↑"
        else
                wifi="↓"
        fi
    fi

    #vpn
    
    connection=$(nmcli connection show --active | grep -q -E "tun0|wg0" && echo "Connected" || echo "Disconnected")
    if [ "$connection" = "Connected" ]; then
        vpn="↑"
    else
        vpn="↓"
    fi

    # Battery

    capacity=$(cat "$BATDEVICE/capacity")
    status=$(cat "$BATDEVICE/status")
    if [ -z "$capacity" ] || [ -z "$status" ]; then
        bat="Error: Unable to retrieve battery information."
        exit 1
    fi

    if [ "$status" = "Charging" ]; then
        bat="↑ $capacity%"
    elif [ "$status" = "Not charging" ] || [ "$status" = "Full" ]; then
        bat="-"
    elif [ "$status" = "Discharging" ] || [ "$status" = "Not Charging" ]; then
        if [ "$capacity" -le 10 ]; then
            bat="↓ $capacity%"
        elif [ "$capacity" -le 20 ]; then
            bat="↓ $capacity%"
        else
            bat="↓ $capacity%"
        fi
    else
        bat="Unknown status: $status"
    fi
    
    # Notifications status
    
    paused=$(dunstctl is-paused)
    if [ "$paused" = "true" ]; then
        ntf="↓"
    else
        ntf="↑"
    fi

    xsetroot -name " VOL $sound | CPU $cpu | RAM $ram | BT $bluetooth | WIFI $wifi | VPN $vpn | BAT $bat | NTF $ntf | $(date "+%H:%M, %a, %b %d ")"
    sleep 1
done
