#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIPO="xcrun lipo"
STRIP="xcrun strip"

SRCDIR=$DIR/luajit-2.1
DESTDIR=$DIR/macos
PLUGINDIR=$DIR/Plugins/macOS

rm "$DESTDIR"/lib/*.a
cd "$SRCDIR" || exit
mkdir -p "$DESTDIR"/lib

make clean
ISDKF="-arch x86_64"
make HOST_CC="gcc" TARGET_FLAGS="$ISDKF" TARGET=x86_64 BUILDMODE=static || exit
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/lib/libluajit-x86_64.a

make clean
ISDKF="-arch arm64"
make HOST_CC="gcc" TARGET_FLAGS="$ISDKF" TARGET=arm64 BUILDMODE=static || exit
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/lib/libluajit-arm64.a

cd "$DESTDIR" || exit
$LIPO -create "$DESTDIR"/lib/libluajit-*.a -output "$DESTDIR"/lib/libluajit.a
$STRIP -S "$DESTDIR"/lib/libluajit.a
xcodebuild clean
xcodebuild -configuration=Release ONLY_ACTIVE_ARCH=NO

mkdir -p "$PLUGINDIR"
cp -r build/Release/tolua.bundle "$PLUGINDIR"
