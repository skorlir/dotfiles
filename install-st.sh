#!/bin/sh -ex
# -e: fail on any error
# -x: output current command

cower -ddt ~/software st-git

cd ~/sssoftware/st-git

ln -s ~/.st-config.h config.h
ln -s ~/.st-colors colors

makepkg -fi
