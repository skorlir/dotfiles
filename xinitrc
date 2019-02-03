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

# bspwm
xrandr --output DP-0 --rotate left
~/.feh-set-background
sxhkd &
exec bspwm
