#!/bin/sh

#
# This is all auto-generated cruft
#

# User configuration files (may not exist)
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
# System-wide configuration files (may not exist)
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge system-wide configuration files into X defaults
if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

# Merge user configuration files into X defaults
if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# Run any system-wide X startup shell scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f # Because... security? lol, hardly
fi

#
# Here's where actual user-stuff happens
#

# Rotate connected output(s)
xrandr -q                                           \
  | grep "\bconnected\b"                            \
  | while read -r monitor
  do echo $monitor                                  \
    | cut -d' ' -f1                                 \
    | xargs -I {} xrandr --output {} --rotate left
  done

# Set random background image
~/.feh-set-background

# Start simple X hotkey daemon
sxhkd &

# Start dunst for notifications
source ~/.aliases.xq
width=$(xq-primary-width)
dunst_width=$(($width / 5))
if [[ $dunst_width < 300 ]]; then dunst_width=300; fi
dunst -geometry "${dunst_width}x5+50+50" &

# Replace process with bspwm (window manager)
exec bspwm
