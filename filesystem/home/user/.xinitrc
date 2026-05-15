#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xset s off
xset -dpms
xset s noblank
# Disable key repeat for volume/mute media keys to prevent rapid-fire toggling.
# The hex keycodes below correspond to XF86XK_AudioLowerVolume, XF86XK_AudioRaiseVolume,
# and XF86XK_AudioMute as defined in config.h. If those bindings are changed or remapped,
# update these keycodes accordingly.
xset -r XF86AudioLowerVolume
xset -r XF86AudioRaiseVolume
xset -r XF86AudioMute

export QT_ENABLE_HIGHDPI_SCALING=0

udiskie --no-notify &

var() {
    ~/.env/vars.sh $@
};

export -f var

sh ~/.env/autostart.sh &
sh ~/.env/status.sh &
sh ~/.env/notifications.sh &

exec dwm
