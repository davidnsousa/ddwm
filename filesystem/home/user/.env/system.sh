#!/bin/sh

CONFIG_FILES="$HOME/.env/* $HOME/.config/gtk-3.0/settings.ini $HOME/.gtkrc-2.0 $HOME/.bashrc $HOME/.xinitrc $HOME/.Xresources"

connect_disconnect_wifi() {
        nmcli device | grep wifi | awk '{print $3}' | grep -w connected && nmcli device disconnect $WIFIDEVICE || nmcli device connect $WIFIDEVICE
}

toggle_wifi() {
        nmcli radio wifi | grep enabled && nmcli radio wifi off || nmcli radio wifi on
}

toggle_networking() {
        nmcli networking | grep enabled && nmcli networking off || nmcli networking on
}

wifi_menu() {	
        selected=$(nmcli -t -f ssid dev wifi | grep -E -v '^$' | dmenu -p "Networks:")
        if [[ -n "$selected" ]]; then
                var tr "nmcli device wifi connect "$selected" --ask"
        fi
}

bluetooth_menu() {
	devices=$(bluetoothctl devices | grep "Device" | cut -f2- -d' ')
	selection=$(echo -e "$devices\nbluetoothctl\nToggle" | dmenu -p "Bluetooth:")

	if [ -n "$selection" ]; then
                if [ "$selection" == "bluetoothctl" ]; then
                        var tr bluetoothctl
                elif [ "$selection" == "Toggle" ]; then
                        bluetoothctl show | grep -q "Powered: yes" && bluetoothctl power off || bluetoothctl power on
                else
                        mac=$(echo "$selection" | cut -f1 -d' ')
                        echo -e "connect $mac\nquit" | bluetoothctl
                fi
	fi
}

network_menu (){ 
        option=$(echo -e "List networks\nConnect/Disconnect network\nEnable/Disable wifi\nEnable/Disable Networking\nBluetooth" | dmenu -p "Settings:")
        if [[ -n "$option" ]]; then
                case "$option" in
                        "List networks")
                                wifi_menu
                                ;;
                        "Connect/Disconnect network")
                                connect_disconnect_wifi
                                ;;
                        "Enable/Disable wifi")
                                toggle_wifi
                                ;;
                        "Enable/Disable Networking")
                                toggle_networking
                                ;;
                        "Bluetooth")
                                bluetooth_menu
                                ;;
                esac
        fi
}

search_menu() {	
	options="$(find $HOME -type f -printf '%f\n')"
	chosen="$(echo -e "$options" | dmenu -p 'Search ~:'  )"
	xdg-open "$(find $HOME -type f -name "$chosen" -print -quit)"
}

exit_menu() {
	option0="Lock"
	option1="Leave X"
	option2="Reboot"
	option3="Shutdown"

	options="$option0\n$option1\n$option2\n$option3"

	chosen="$(echo -e "$options" | dmenu -p "System:" )"
	case $chosen in
                $option0)
                        slock;;
                $option1)
                        pkill -u $USER X;;
                $option2)
                        reboot;;
                $option3)
                        shutdown now;;
        esac
}

update_mirrors () {
        rate-mirrors --allow-root --protocol https arch | grep -v '^#' | sudo tee /etc/pacman.d/mirrorlist
        notify-send "Mirrors set!"
}

option=$(echo -e "Network\nSound\nDisplay\nSystem monitor\nSearch files\nUpdate system\nUpdate mirrors\nConfiguration files\nApps\nExit" | dmenu -p "System:")
if [[ -n "$option" ]]; then
        case "$option" in
                "Network")
                        network_menu
                        ;;
                "Sound")
                        var s
                        ;;
                "Display")
                        var d
                        ;;
                "System monitor")
                        var sm
                        ;;
                "Search files")
                        search_menu
                        ;;
                "Update system")
                        var us
                        ;;
                "Update mirrors")
                        update_mirrors
                        ;;
                "Configuration files")
                        var cf $CONFIG_FILES
                        ;;
                "Apps")
                        var tr $HOME/.env/install_apps.sh
                        ;;
                "Exit")
                        exit_menu
                        ;;
        esac
fi
