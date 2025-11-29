#!/bin/sh

# Autostart apps

var t &

# Check network connection before autostarting network dependent apps
while ! ping -q -c 1 -W 1 ping.eu > /dev/null; do
    sleep 5
done

# Autostart network dependent apps

