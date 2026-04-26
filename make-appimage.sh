#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/opt/simplex/simplex-simplex.desktop # weirdest place to have a desktop entry lol
export DESKTOP=/opt/simplex/simplex.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
	/opt/simplex/bin/simplex \
	/opt/simplex/lib/*.so*   \
	/opt/simplex/lib/app     \
	/opt/simplex/lib/runtime

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
