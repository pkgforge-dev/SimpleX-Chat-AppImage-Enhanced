#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/opt/simplex/lib/simplex.png
export DESKTOP=/opt/simplex/lib/simplex-simplex.desktop # weirdest place to have a desktop entry lol
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
	/opt/simplex/bin/simplex \
	/opt/simplex/lib/*.so*   \
	/opt/simplex/lib/app     \
	/opt/simplex/lib/runtime
cp ./AppDir/lib/simplex/lib/libapplauncher.so ./AppDir/lib
rm -rf ./AppDir/lib/simplex

# this app ships its own libcrypto.so.3
# remove the one from archlinux so that this does not crash
f=./AppDir/shared/lib/app/resources/vlc/libcrypto.so.3
if [ -f "$f" ]; then
	rm -f ./AppDir/lib/"${f##*/}"
fi

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
