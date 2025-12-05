#!/bin/sh

case $1 in
        "t") alacritty;;                           # Terminal
        "f") pcmanfm ${@:2};;                      # File Manager
        "tr") alacritty -e ${@:2};;                # Terminal run
        "e") geany ${@:2};;                        # Editor
        "s") var tr pulsemixer;;                   # Sound Manager                                        
        "d") arandr;;                              # Display Manager
        "sm") var tr btop;;                        # System monitor
        "us") var tr yay;;                         # Update system
        "cf") var e -i ${@:2};;                    # Configuration files
        "ss") flameshot gui;;                      # Secreenshot
        "wb") notify-send "Set the default web browser variable" "edit ~/.env/vars.sh";;        # Web browser 
        "vpnon") notify-send "Set the default VPN connect variable" "edit ~/.env/vars.sh";;     # Connect vpn           
        "vpnoff") notify-send "Set the default VPN disconnect variable" "edit ~/.env/vars.sh";; # Disconnect vpn                      
        "cloud") notify-send "Set the default cloud services variable" "edit ~/.env/vars.sh";;  # Start cloud services                      
esac
