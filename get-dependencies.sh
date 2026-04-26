#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting binary..."
echo "---------------------------------------------------------------"
deb=https://github.com/simplex-chat/simplex-chat/releases/latest/download/simplex-desktop-ubuntu-24_04-$ARCH.deb
if ! wget --retry-connrefused --tries=30 "$deb" -O /tmp/temp.deb 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
ar xvf /tmp/temp.deb
tar -xvf ./data.tar.zst
rm -f ./*.zst /tmp/temp.deb
cp -rv ./opt/simplex /opt

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
