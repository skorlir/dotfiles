#!/bin/sh -ex
# -e: fail on any error
# -x: output current command

mkdir -p ~/software
cd ~/software

yay -G st

cd ~/software/st

ln -s ~/.st-config.h config.h
ln -s ~/.st-colors colors

makepkg --syncdeps --install
